<template>
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
    <!-- 销售趋势图 -->
    <div class="dashboard-panel p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-lg font-bold text-chinese-dark">销售趋势</h3>
        <div class="flex space-x-2">
          <button 
            v-for="period in ['月', '季', '年']"
            :key="period"
            @click="selectedPeriod = period"
            class="px-3 py-1 text-sm rounded-lg transition-all duration-200"
            :class="selectedPeriod === period ? 'bg-chinese-red text-white' : 'text-chinese-dark hover:bg-chinese-beige'"
          >
            {{ period }}
          </button>
        </div>
      </div>
      <div class="h-64">
        <v-chart 
          :option="lineChartOption" 
          :autoresize="true"
          class="w-full h-full"
        />
      </div>
    </div>

    <!-- 产品分类饼图 -->
    <div class="dashboard-panel p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-lg font-bold text-chinese-dark">产品分类分布</h3>
        <div class="flex items-center space-x-2 text-sm text-gray-600">
          <span class="w-3 h-3 bg-chinese-red rounded-full"></span>
          <span>总计: {{ totalProducts }}个</span>
        </div>
      </div>
      <div class="h-64">
        <v-chart 
          :option="pieChartOption" 
          :autoresize="true"
          class="w-full h-full"
        />
      </div>
    </div>

    <!-- 地区销售柱状图 -->
    <div class="dashboard-panel p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-lg font-bold text-chinese-dark">地区销售分布</h3>
        <div class="text-sm text-gray-600">
          单位: 万元
        </div>
      </div>
      <div class="h-64">
        <v-chart 
          :option="barChartOption" 
          :autoresize="true"
          class="w-full h-full"
        />
      </div>
    </div>

    <!-- 扶贫成效雷达图 -->
    <div class="dashboard-panel p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-lg font-bold text-chinese-dark">扶贫成效评估</h3>
        <div class="text-sm text-gray-600">
          综合评分: {{ overallScore }}分
        </div>
      </div>
      <div class="h-64">
        <v-chart 
          :option="radarChartOption" 
          :autoresize="true"
          class="w-full h-full"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { dashboardData } from '@/data/dashboard'

// 响应式数据
const selectedPeriod = ref('月')
const chartData = ref(dashboardData)

// 计算属性
const totalProducts = computed(() => {
  return chartData.value.categoryData.reduce((sum, item) => sum + item.value, 0)
})

const overallScore = computed(() => {
  return 85.6 // 综合评分
})

// 折线图配置
const lineChartOption = computed(() => ({
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderColor: '#c3272b',
    borderWidth: 1,
    textStyle: {
      color: '#2c3e50',
      fontSize: 12
    }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    data: chartData.value.monthlyTrend.map(item => item.month),
    axisLine: {
      lineStyle: {
        color: '#c3272b'
      }
    },
    axisTick: {
      alignWithLabel: true
    },
    axisLabel: {
      color: '#2c3e50',
      fontSize: 12
    }
  },
  yAxis: {
    type: 'value',
    axisLine: {
      lineStyle: {
        color: '#789262'
      }
    },
    axisLabel: {
      color: '#2c3e50',
      fontSize: 12
    },
    splitLine: {
      lineStyle: {
        color: '#f8f3e6'
      }
    }
  },
  series: [
    {
      name: '销售额',
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      itemStyle: {
        color: '#c3272b'
      },
      lineStyle: {
        color: '#c3272b',
        width: 3
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0,
            color: 'rgba(195, 39, 43, 0.3)'
          }, {
            offset: 1,
            color: 'rgba(195, 39, 43, 0.1)'
          }]
        }
      },
      data: chartData.value.monthlyTrend.map(item => item.sales)
    },
    {
      name: '订单数',
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 6,
      itemStyle: {
        color: '#789262'
      },
      lineStyle: {
        color: '#789262',
        width: 2
      },
      data: chartData.value.monthlyTrend.map(item => item.orders)
    }
  ]
}))

// 饼图配置
const pieChartOption = computed(() => ({
  tooltip: {
    trigger: 'item',
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderColor: '#c3272b',
    borderWidth: 1,
    textStyle: {
      color: '#2c3e50',
      fontSize: 12
    },
    formatter: '{a} <br/>{b}: {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    textStyle: {
      color: '#2c3e50',
      fontSize: 12
    }
  },
  series: [
    {
      name: '产品分类',
      type: 'pie',
      radius: ['30%', '70%'],
      center: ['60%', '50%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 8,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false,
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: 14,
          fontWeight: 'bold',
          color: '#2c3e50'
        },
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      },
      labelLine: {
        show: false
      },
      data: chartData.value.categoryData.map((item, index) => ({
        name: item.name,
        value: item.value,
        itemStyle: {
          color: getColorByIndex(index)
        }
      }))
    }
  ]
}))

// 柱状图配置
const barChartOption = computed(() => ({
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderColor: '#c3272b',
    borderWidth: 1,
    textStyle: {
      color: '#2c3e50',
      fontSize: 12
    }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    data: Object.keys(chartData.value.regionData),
    axisLine: {
      lineStyle: {
        color: '#c3272b'
      }
    },
    axisLabel: {
      color: '#2c3e50',
      fontSize: 12,
      rotate: 45
    }
  },
  yAxis: {
    type: 'value',
    axisLine: {
      lineStyle: {
        color: '#789262'
      }
    },
    axisLabel: {
      color: '#2c3e50',
      fontSize: 12
    },
    splitLine: {
      lineStyle: {
        color: '#f8f3e6'
      }
    }
  },
  series: [
    {
      name: '销售额',
      type: 'bar',
      barWidth: '60%',
      itemStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0,
            color: '#c3272b'
          }, {
            offset: 1,
            color: '#789262'
          }]
        },
        borderRadius: [4, 4, 0, 0]
      },
      data: Object.values(chartData.value.regionData).map(item => item.sales)
    }
  ]
}))

// 雷达图配置
const radarChartOption = computed(() => ({
  tooltip: {
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderColor: '#c3272b',
    borderWidth: 1,
    textStyle: {
      color: '#2c3e50',
      fontSize: 12
    }
  },
  radar: {
    indicator: [
      { name: '产业发展', max: 100 },
      { name: '就业增长', max: 100 },
      { name: '收入提升', max: 100 },
      { name: '教育改善', max: 100 },
      { name: '医疗保障', max: 100 },
      { name: '基础设施', max: 100 }
    ],
    center: ['50%', '50%'],
    radius: '70%',
    splitNumber: 4,
    axisLine: {
      lineStyle: {
        color: '#c3272b'
      }
    },
    splitLine: {
      lineStyle: {
        color: '#f8f3e6'
      }
    },
    splitArea: {
      areaStyle: {
        color: ['rgba(195, 39, 43, 0.1)', 'rgba(248, 243, 230, 0.2)']
      }
    }
  },
  series: [
    {
      name: '扶贫成效',
      type: 'radar',
      symbol: 'circle',
      symbolSize: 8,
      itemStyle: {
        color: '#c3272b'
      },
      lineStyle: {
        color: '#c3272b',
        width: 2
      },
      areaStyle: {
        color: 'rgba(195, 39, 43, 0.2)'
      },
      data: [
        {
          value: [85, 92, 78, 88, 82, 95],
          name: '2023年度'
        }
      ]
    }
  ]
}))

// 根据索引获取颜色
const getColorByIndex = (index) => {
  const colors = [
    '#c3272b', '#789262', '#d4a574', '#2c3e50',
    '#e74c3c', '#3498db', '#9b59b6', '#f39c12',
    '#1abc9c', '#34495e', '#e67e22', '#95a5a6'
  ]
  return colors[index % colors.length]
}

// 生命周期
onMounted(() => {
  // 这里可以添加数据加载逻辑
  console.log('数据可视化组件已加载')
})
</script>

<style scoped>
.dashboard-panel {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(248, 243, 230, 0.3);
}
</style> 