<template>
  <div class="relative w-full h-full min-h-96">
    <!-- 加载状态 -->
    <div v-if="loading" class="absolute inset-0 flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 rounded-lg">
      <div class="text-center">
        <div class="relative">
          <div class="animate-spin rounded-full h-16 w-16 border-4 border-blue-200 border-t-blue-600 mx-auto mb-4"></div>
          <div class="absolute inset-0 flex items-center justify-center">
            <div class="w-8 h-8 bg-blue-600 rounded-full animate-pulse"></div>
          </div>
        </div>
        <p class="text-gray-700 font-medium">正在加载地图数据...</p>
        <div class="mt-2 flex justify-center space-x-1">
          <div class="w-2 h-2 bg-blue-400 rounded-full animate-bounce"></div>
          <div class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
          <div class="w-2 h-2 bg-blue-600 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
        </div>
      </div>
    </div>
    
    <!-- 错误状态 -->
    <div v-else-if="error" class="absolute inset-0 flex items-center justify-center bg-gradient-to-br from-red-50 to-pink-100 rounded-lg">
      <div class="text-center">
        <div class="text-red-500 text-6xl mb-4 animate-bounce">⚠️</div>
        <p class="text-red-600 mb-4 font-medium">地图数据加载失败</p>
        <p class="text-red-500 text-sm mb-6">请检查网络连接或稍后重试</p>
        <button @click="retryLoad" 
                class="px-6 py-3 bg-gradient-to-r from-red-500 to-pink-500 text-white rounded-lg 
                       hover:from-red-600 hover:to-pink-600 transition-all duration-300 
                       transform hover:scale-105 shadow-lg">
          <span class="flex items-center space-x-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
            </svg>
            <span>重新加载</span>
          </span>
        </button>
      </div>
    </div>
    
    <!-- 地图容器 -->
    <div 
      v-else 
      ref="chartContainer" 
      class="w-full h-full min-h-96 relative rounded-lg overflow-hidden shadow-inner"
      :class="{ 'opacity-0': loading }"
    ></div>
    
    <!-- 地图控制面板 -->
    <div v-if="!loading && !error" class="absolute top-4 left-4 space-y-2">
      <!-- 视图模式切换 -->
      <div class="bg-white/95 backdrop-blur-sm rounded-lg p-3 shadow-lg border border-gray-200">
        <div class="text-xs text-gray-600 mb-2 font-medium">视图模式</div>
        <div class="flex space-x-2">
          <button @click="switchViewMode('heat')" 
                  :class="[
                    'px-3 py-1 text-xs rounded-md transition-all duration-200',
                    viewMode === 'heat' 
                      ? 'bg-blue-500 text-white shadow-md' 
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  ]">
            热力图
          </button>
          <button @click="switchViewMode('scatter')" 
                  :class="[
                    'px-3 py-1 text-xs rounded-md transition-all duration-200',
                    viewMode === 'scatter' 
                      ? 'bg-green-500 text-white shadow-md' 
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  ]">
            散点图
          </button>
        </div>
      </div>
      
      <!-- 数据更新时间 -->
      <div class="bg-white/95 backdrop-blur-sm rounded-lg p-3 shadow-lg border border-gray-200">
        <div class="text-xs text-gray-600 mb-1">最后更新</div>
        <div class="text-xs font-medium text-gray-800">{{ lastUpdateTime }}</div>
        <button @click="refreshData" 
                class="mt-2 text-xs text-blue-600 hover:text-blue-800 transition-colors flex items-center space-x-1">
          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
          </svg>
          <span>刷新</span>
        </button>
      </div>
    </div>
    
    <!-- 地图说明和图例 -->
    <div v-if="!loading && !error" class="absolute top-4 right-4 bg-white/95 backdrop-blur-sm rounded-lg p-4 shadow-lg border border-gray-200">
      <div class="text-sm font-medium text-gray-800 mb-3">项目分布密度</div>
      <div class="space-y-2">
        <div class="flex items-center space-x-2 text-xs">
          <div class="w-4 h-4 rounded-full bg-gradient-to-r from-blue-200 to-blue-300 shadow-sm"></div>
          <span class="text-gray-600">1-15个项目</span>
        </div>
        <div class="flex items-center space-x-2 text-xs">
          <div class="w-4 h-4 rounded-full bg-gradient-to-r from-blue-400 to-blue-500 shadow-sm"></div>
          <span class="text-gray-600">16-30个项目</span>
        </div>
        <div class="flex items-center space-x-2 text-xs">
          <div class="w-4 h-4 rounded-full bg-gradient-to-r from-blue-600 to-indigo-600 shadow-sm"></div>
          <span class="text-gray-600">31-45个项目</span>
        </div>
        <div class="flex items-center space-x-2 text-xs">
          <div class="w-4 h-4 rounded-full bg-gradient-to-r from-red-500 to-pink-500 shadow-sm"></div>
          <span class="text-gray-600">45+个项目</span>
        </div>
      </div>
      
      <!-- 统计摘要 -->
      <div class="mt-4 pt-3 border-t border-gray-200">
        <div class="text-xs text-gray-600 mb-2">实时统计</div>
        <div class="grid grid-cols-2 gap-2 text-xs">
          <div class="text-center">
            <div class="font-bold text-blue-600">{{ totalProjects }}</div>
            <div class="text-gray-500">总项目</div>
          </div>
          <div class="text-center">
            <div class="font-bold text-green-600">{{ activeMeasures }}</div>
            <div class="text-gray-500">实施中</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 地区详情弹窗 -->
    <div v-if="selectedRegionPopup" 
         class="absolute inset-0 bg-black/50 flex items-center justify-center z-50"
         @click="closeRegionPopup">
      <div class="bg-white rounded-xl p-6 max-w-md w-full mx-4 transform transition-all duration-300"
           @click.stop>
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-bold text-gray-900">{{ selectedRegionPopup.name }}</h3>
          <button @click="closeRegionPopup" 
                  class="text-gray-400 hover:text-gray-600 transition-colors">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
        
        <div class="grid grid-cols-2 gap-4 mb-4">
          <div class="bg-blue-50 rounded-lg p-3 text-center">
            <div class="text-2xl font-bold text-blue-600">{{ selectedRegionPopup.value }}</div>
            <div class="text-sm text-gray-600">扶贫项目</div>
          </div>
          <div class="bg-green-50 rounded-lg p-3 text-center">
            <div class="text-2xl font-bold text-green-600">{{ selectedRegionPopup.beneficiaries || 'N/A' }}</div>
            <div class="text-sm text-gray-600">受益人数</div>
          </div>
        </div>
        
        <button @click="viewRegionDetails" 
                class="w-full py-2 bg-gradient-to-r from-blue-500 to-indigo-500 text-white 
                       rounded-lg hover:from-blue-600 hover:to-indigo-600 transition-all duration-200
                       transform hover:scale-[1.02]">
          查看详细信息
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, onUnmounted, nextTick } from 'vue'
import * as echarts from 'echarts'

const props = defineProps({
  data: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['region-click', 'data-refresh'])

const chartContainer = ref(null)
const loading = ref(true)
const error = ref(false)
const viewMode = ref('heat') // 'heat' | 'scatter'
const selectedRegionPopup = ref(null)
const lastUpdateTime = ref('')
let chart = null
let resizeObserver = null

// 计算属性
const totalProjects = computed(() => {
  return provinceData.reduce((sum, item) => sum + item.value, 0)
})

const activeMeasures = computed(() => {
  return Math.floor(totalProjects.value * 0.75) // 模拟75%的项目正在实施
})

// 省份扶贫项目数据（增强版）
const provinceData = [
  { name: '北京', value: 15, code: 'BJ', coord: [116.46, 39.92], beneficiaries: 4500, category: 'developed' },
  { name: '天津', value: 12, code: 'TJ', coord: [117.2, 39.13], beneficiaries: 3600, category: 'developed' },
  { name: '河北', value: 28, code: 'HE', coord: [114.48, 38.03], beneficiaries: 8400, category: 'developing' },
  { name: '山西', value: 45, code: 'SX', coord: [112.53, 37.87], beneficiaries: 13500, category: 'key' },
  { name: '内蒙古', value: 22, code: 'NM', coord: [111.65, 40.82], beneficiaries: 6600, category: 'developing' },
  { name: '辽宁', value: 18, code: 'LN', coord: [123.38, 41.8], beneficiaries: 5400, category: 'developing' },
  { name: '吉林', value: 16, code: 'JL', coord: [125.35, 43.88], beneficiaries: 4800, category: 'developing' },
  { name: '黑龙江', value: 24, code: 'HL', coord: [126.63, 45.75], beneficiaries: 7200, category: 'developing' },
  { name: '上海', value: 8, code: 'SH', coord: [121.48, 31.22], beneficiaries: 2400, category: 'developed' },
  { name: '江苏', value: 19, code: 'JS', coord: [118.78, 32.04], beneficiaries: 5700, category: 'developed' },
  { name: '浙江', value: 17, code: 'ZJ', coord: [120.19, 30.26], beneficiaries: 5100, category: 'developed' },
  { name: '安徽', value: 31, code: 'AH', coord: [117.27, 31.86], beneficiaries: 9300, category: 'developing' },
  { name: '福建', value: 14, code: 'FJ', coord: [119.3, 26.08], beneficiaries: 4200, category: 'developed' },
  { name: '江西', value: 26, code: 'JX', coord: [115.89, 28.68], beneficiaries: 7800, category: 'developing' },
  { name: '山东', value: 21, code: 'SD', coord: [117, 36.65], beneficiaries: 6300, category: 'developed' },
  { name: '河南', value: 35, code: 'HA', coord: [113.65, 34.76], beneficiaries: 10500, category: 'developing' },
  { name: '湖北', value: 29, code: 'HB', coord: [114.31, 30.52], beneficiaries: 8700, category: 'developing' },
  { name: '湖南', value: 33, code: 'HN', coord: [113, 28.21], beneficiaries: 9900, category: 'developing' },
  { name: '广东', value: 20, code: 'GD', coord: [113.23, 23.16], beneficiaries: 6000, category: 'developed' },
  { name: '广西', value: 27, code: 'GX', coord: [108.33, 22.84], beneficiaries: 8100, category: 'developing' },
  { name: '海南', value: 9, code: 'HI', coord: [110.35, 20.02], beneficiaries: 2700, category: 'developing' },
  { name: '重庆', value: 23, code: 'CQ', coord: [106.54, 29.59], beneficiaries: 6900, category: 'developing' },
  { name: '四川', value: 36, code: 'SC', coord: [104.06, 30.67], beneficiaries: 10800, category: 'key' },
  { name: '贵州', value: 42, code: 'GZ', coord: [106.71, 26.57], beneficiaries: 12600, category: 'key' },
  { name: '云南', value: 38, code: 'YN', coord: [102.73, 25.04], beneficiaries: 11400, category: 'key' },
  { name: '西藏', value: 13, code: 'XZ', coord: [91.11, 29.97], beneficiaries: 3900, category: 'special' },
  { name: '陕西', value: 25, code: 'SN', coord: [108.95, 34.27], beneficiaries: 7500, category: 'developing' },
  { name: '甘肃', value: 35, code: 'GS', coord: [103.73, 36.03], beneficiaries: 10500, category: 'key' },
  { name: '青海', value: 11, code: 'QH', coord: [101.74, 36.56], beneficiaries: 3300, category: 'special' },
  { name: '宁夏', value: 10, code: 'NX', coord: [106.27, 38.47], beneficiaries: 3000, category: 'special' },
  { name: '新疆', value: 32, code: 'XJ', coord: [87.68, 43.77], beneficiaries: 9600, category: 'key' }
]

// 加载中国地图数据
const loadChinaMap = async () => {
  try {
    loading.value = true
    error.value = false
    
    // 使用公开的地图数据URL，添加备用数据源
    const urls = [
      'https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json',
      'https://raw.githubusercontent.com/hchunhui/hanzi/master/china.json'
    ]
    
    for (const url of urls) {
      try {
        const response = await fetch(url)
        if (response.ok) {
          const geoJson = await response.json()
          echarts.registerMap('china', geoJson)
          return true
        }
      } catch (err) {
        console.warn(`尝试从 ${url} 加载地图数据失败:`, err)
        continue
      }
    }
    
    throw new Error('所有地图数据源都无法访问')
  } catch (err) {
    console.warn('地图数据加载失败，使用备用可视化方案:', err)
    return false
  }
}

// 初始化图表
const initChart = async () => {
  if (!chartContainer.value) return
  
  try {
    chart = echarts.init(chartContainer.value, null, {
      renderer: 'canvas'
    })
    
    // 尝试加载真实地图数据
    const mapLoaded = await loadChinaMap()
    
    if (mapLoaded && viewMode.value === 'heat') {
      createRealMap()
    } else {
      createFallbackVisualization()
    }
    
    setupEventListeners()
    updateLastUpdateTime()
    loading.value = false
    
  } catch (err) {
    console.error('图表初始化失败:', err)
    error.value = true
    loading.value = false
  }
}

// 创建真实地图（热力图模式）
const createRealMap = () => {
  const option = {
    title: {
      text: '全国扶贫项目分布热力图',
      left: 'center',
      top: 20,
      textStyle: {
        color: '#333',
        fontSize: 18,
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'item',
      formatter: function (params) {
        const data = provinceData.find(item => item.name === params.name)
        if (data) {
          return `
            <div style="padding: 12px; max-width: 250px;">
              <div style="font-weight: bold; margin-bottom: 8px; color: #333; font-size: 14px;">${params.name}</div>
              <div style="margin-bottom: 4px;">
                <span style="color: #666;">扶贫项目：</span>
                <span style="color: #1890ff; font-weight: bold;">${data.value}个</span>
              </div>
              <div style="margin-bottom: 4px;">
                <span style="color: #666;">受益人数：</span>
                <span style="color: #52c41a; font-weight: bold;">${data.beneficiaries}人</span>
              </div>
              <div style="margin-bottom: 8px;">
                <span style="color: #666;">项目类型：</span>
                <span style="color: #722ed1;">${getCategoryName(data.category)}</span>
              </div>
              <div style="color: #999; font-size: 12px;">点击查看详细信息</div>
            </div>
          `
        }
        return `${params.name}<br/>暂无数据`
      },
      backgroundColor: 'rgba(255, 255, 255, 0.98)',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      borderRadius: 10,
      textStyle: {
        color: '#333',
        fontSize: 13
      },
      extraCssText: 'box-shadow: 0 8px 32px rgba(0,0,0,0.12); backdrop-filter: blur(10px);'
    },
    visualMap: {
      min: 0,
      max: 50,
      left: 'left',
      bottom: 'bottom',
      text: ['项目多', '项目少'],
      calculable: true,
      inRange: {
        color: ['#e6f3ff', '#91c7f7', '#4a90e2', '#1a73e8', '#c3272b']
      },
      textStyle: {
        color: '#333'
      },
      borderColor: '#ccc',
      borderWidth: 1
    },
    series: [
      {
        name: '扶贫项目',
        type: 'map',
        map: 'china',
        roam: true,
        scaleLimit: {
          min: 0.8,
          max: 3
        },
        emphasis: {
          label: {
            show: true,
            color: '#fff',
            fontSize: 14,
            fontWeight: 'bold'
          },
          itemStyle: {
            areaColor: '#c3272b',
            borderColor: '#fff',
            borderWidth: 2,
            shadowBlur: 10,
            shadowColor: 'rgba(0,0,0,0.3)'
          }
        },
        select: {
          label: {
            show: true,
            color: '#fff'
          },
          itemStyle: {
            areaColor: '#1a73e8'
          }
        },
        itemStyle: {
          borderColor: '#fff',
          borderWidth: 1.5,
          areaColor: '#f5f5f5'
        },
        data: provinceData.map(item => ({
          name: item.name,
          value: item.value,
          code: item.code,
          category: item.category,
          beneficiaries: item.beneficiaries
        }))
      }
    ]
  }
  
  chart.setOption(option, true)
}

// 创建备用可视化方案（散点图模式）
const createFallbackVisualization = () => {
  const option = {
    title: {
      text: '全国扶贫项目分布散点图',
      left: 'center',
      top: 20,
      textStyle: {
        color: '#333',
        fontSize: 18,
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'item',
      formatter: function (params) {
        const [x, y, value, name, code, beneficiaries, category] = params.data
        return `
          <div style="padding: 12px; max-width: 250px;">
            <div style="font-weight: bold; margin-bottom: 8px; color: #333; font-size: 14px;">${name}</div>
            <div style="margin-bottom: 4px;">
              <span style="color: #666;">扶贫项目：</span>
              <span style="color: #1890ff; font-weight: bold;">${value}个</span>
            </div>
            <div style="margin-bottom: 4px;">
              <span style="color: #666;">受益人数：</span>
              <span style="color: #52c41a; font-weight: bold;">${beneficiaries}人</span>
            </div>
            <div style="margin-bottom: 8px;">
              <span style="color: #666;">项目类型：</span>
              <span style="color: #722ed1;">${getCategoryName(category)}</span>
            </div>
            <div style="color: #999; font-size: 12px;">点击查看详细信息</div>
          </div>
        `
      },
      backgroundColor: 'rgba(255, 255, 255, 0.98)',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      borderRadius: 10,
      textStyle: {
        color: '#333'
      },
      extraCssText: 'box-shadow: 0 8px 32px rgba(0,0,0,0.12); backdrop-filter: blur(10px);'
    },
    grid: {
      left: '5%',
      right: '5%',
      top: '15%',
      bottom: '10%',
      containLabel: true
    },
    xAxis: {
      type: 'value',
      min: 70,
      max: 140,
      show: false
    },
    yAxis: {
      type: 'value',
      min: 15,
      max: 55,
      show: false
    },
    series: [
      {
        name: '扶贫项目',
        type: 'scatter',
        symbolSize: function (data) {
          return Math.max(data[2] * 0.8 + 8, 12)
        },
        itemStyle: {
          color: function(params) {
            const value = params.data[2]
            const category = params.data[6]
            
            // 根据项目类型和数量决定颜色
            if (category === 'key') return '#c3272b'
            if (category === 'special') return '#722ed1'
            if (value >= 30) return '#1a73e8'
            if (value >= 20) return '#4a90e2'
            return '#91c7f7'
          },
          opacity: 0.85,
          borderColor: '#fff',
          borderWidth: 2
        },
        emphasis: {
          itemStyle: {
            opacity: 1,
            borderWidth: 3,
            shadowBlur: 15,
            shadowColor: 'rgba(0,0,0,0.4)'
          },
          label: {
            show: true,
            formatter: '{@[3]}',
            position: 'top',
            fontSize: 12,
            fontWeight: 'bold',
            color: '#333',
            backgroundColor: 'rgba(255,255,255,0.9)',
            borderRadius: 6,
            padding: [6, 10],
            shadowBlur: 5,
            shadowColor: 'rgba(0,0,0,0.1)'
          }
        },
        data: provinceData.map(item => [
          item.coord[0], // 经度
          item.coord[1], // 纬度  
          item.value,    // 项目数量
          item.name,     // 省份名称
          item.code,     // 省份代码
          item.beneficiaries, // 受益人数
          item.category  // 项目类型
        ])
      }
    ]
  }
  
  chart.setOption(option, true)
}

// 获取类型名称
const getCategoryName = (category) => {
  const categoryMap = {
    'key': '重点扶贫地区',
    'special': '特殊扶贫地区',
    'developing': '发展中地区',
    'developed': '发达地区'
  }
  return categoryMap[category] || '未分类'
}

// 切换视图模式
const switchViewMode = (mode) => {
  if (viewMode.value === mode) return
  
  viewMode.value = mode
  loading.value = true
  
  setTimeout(() => {
    if (mode === 'heat') {
      createRealMap()
    } else {
      createFallbackVisualization()
    }
    loading.value = false
  }, 300)
}

// 更新最后更新时间
const updateLastUpdateTime = () => {
  const now = new Date()
  lastUpdateTime.value = now.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 刷新数据
const refreshData = () => {
  loading.value = true
  
  // 模拟数据刷新
  setTimeout(() => {
    // 可以在这里调用API更新数据
    updateLastUpdateTime()
    emit('data-refresh')
    
    // 重新渲染图表
    if (viewMode.value === 'heat') {
      createRealMap()
    } else {
      createFallbackVisualization()
    }
    
    loading.value = false
  }, 1000)
}

// 关闭地区详情弹窗
const closeRegionPopup = () => {
  selectedRegionPopup.value = null
}

// 查看地区详情
const viewRegionDetails = () => {
  if (selectedRegionPopup.value) {
    emit('region-click', selectedRegionPopup.value)
    closeRegionPopup()
  }
}

// 设置事件监听器
const setupEventListeners = () => {
  if (!chart) return
  
  // 点击事件
  chart.on('click', function (params) {
    let regionData = null
    
    if (params.componentType === 'series') {
      if (params.seriesType === 'map') {
        // 真实地图模式
        regionData = provinceData.find(item => item.name === params.name)
      } else if (params.seriesType === 'scatter') {
        // 备用可视化模式
        const [x, y, value, name, code, beneficiaries, category] = params.data
        regionData = {
          name,
          code,
          value,
          coord: [x, y],
          beneficiaries,
          category
        }
      }
      
      if (regionData) {
        selectedRegionPopup.value = regionData
      }
    }
  })
  
  // 鼠标悬停效果
  chart.on('mouseover', function (params) {
    if (params.componentType === 'series') {
      chart.getZr().setCursorStyle('pointer')
    }
  })
  
  chart.on('mouseout', function () {
    chart.getZr().setCursorStyle('default')
  })
}

// 重新加载
const retryLoad = () => {
  error.value = false
  loading.value = true
  nextTick(() => {
    initChart()
  })
}

// 监听数据变化
watch(() => props.data, () => {
  if (chart && !loading.value && !error.value) {
    // 可以根据props.data更新图表数据
    const currentOption = chart.getOption()
    if (currentOption && currentOption.series && currentOption.series[0]) {
      // 更新数据逻辑
      refreshData()
    }
  }
}, { deep: true })

// 监听视图模式变化
watch(viewMode, (newMode) => {
  if (chart && !loading.value && !error.value) {
    switchViewMode(newMode)
  }
})

// 处理窗口大小变化
const handleResize = () => {
  if (chart) {
    chart.resize()
  }
}

onMounted(async () => {
  await nextTick()
  initChart()
  
  // 使用ResizeObserver监听容器大小变化
  if (chartContainer.value && window.ResizeObserver) {
    resizeObserver = new ResizeObserver(handleResize)
    resizeObserver.observe(chartContainer.value)
  } else {
    // 备用方案
    window.addEventListener('resize', handleResize)
  }
})

onUnmounted(() => {
  if (chart) {
    chart.dispose()
    chart = null
  }
  
  if (resizeObserver) {
    resizeObserver.disconnect()
  } else {
    window.removeEventListener('resize', handleResize)
  }
})
</script>

<style scoped>
.opacity-0 {
  opacity: 0;
  transition: opacity 0.3s ease;
}

/* 自定义动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out;
}

/* 美化滚动条 */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style> 