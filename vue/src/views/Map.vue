<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 页面头部 -->
    <div class="bg-white shadow-sm border-b">
      <div class="container mx-auto px-4 py-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-3xl font-bold text-gray-900 flex items-center space-x-3">
              <span class="text-4xl">🗺️</span>
              <span>扶贫地图</span>
            </h1>
            <p class="text-gray-600 mt-2">全国扶贫项目分布与成效实时展示</p>
          </div>
          <div class="flex items-center space-x-6">
            <div class="text-center">
              <div class="text-3xl font-bold text-blue-600 animate-pulse">{{ totalProjects }}</div>
              <div class="text-sm text-gray-600">扶贫项目</div>
            </div>
            <div class="text-center">
              <div class="text-3xl font-bold text-green-600 animate-pulse">{{ totalBeneficiaries.toLocaleString() }}</div>
              <div class="text-sm text-gray-600">受益人数</div>
            </div>
            <div class="text-center">
              <div class="text-3xl font-bold text-purple-600 animate-pulse">{{ onlineUsers }}</div>
              <div class="text-sm text-gray-600">在线用户</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="container mx-auto px-4 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
        <!-- 地图区域 -->
        <div class="lg:col-span-3 space-y-6">
          <!-- 地图控制器 -->
          <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-up">
            <div class="flex flex-wrap items-center justify-between mb-6">
              <h2 class="text-xl font-bold text-gray-900 flex items-center space-x-2">
                <span class="text-2xl">📊</span>
                <span>项目分布地图</span>
              </h2>
              
              <!-- 搜索和筛选区域 -->
              <div class="flex flex-wrap items-center space-x-4 mt-4 lg:mt-0">
                <!-- 地区搜索 -->
                <div class="relative">
                  <input v-model="searchQuery" 
                         type="text" 
                         placeholder="搜索省份..." 
                         class="w-48 pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm 
                                focus:ring-2 focus:ring-blue-500 focus:border-transparent
                                transition-all duration-200">
                  <svg class="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                  </svg>
                </div>
                
                <!-- 年份筛选 -->
                <select v-model="selectedYear" 
                        class="border border-gray-300 rounded-lg px-4 py-2 text-sm 
                               focus:ring-2 focus:ring-blue-500 focus:border-transparent
                               transition-all duration-200">
                  <option value="all">全部年份</option>
                  <option value="2024">2024年</option>
                  <option value="2023">2023年</option>
                  <option value="2022">2022年</option>
                  <option value="2021">2021年</option>
                </select>
                
                <!-- 项目类型筛选 -->
                <select v-model="selectedCategory" 
                        class="border border-gray-300 rounded-lg px-4 py-2 text-sm 
                               focus:ring-2 focus:ring-blue-500 focus:border-transparent
                               transition-all duration-200">
                  <option value="all">全部类型</option>
                  <option value="agriculture">农业扶贫</option>
                  <option value="education">教育扶贫</option>
                  <option value="healthcare">医疗扶贫</option>
                  <option value="infrastructure">基础设施</option>
                  <option value="tourism">文旅扶贫</option>
                </select>
                
                <!-- 高级筛选按钮 -->
                <button @click="showAdvancedFilter = !showAdvancedFilter"
                        class="flex items-center space-x-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 
                               rounded-lg text-sm font-medium transition-all duration-200">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                          d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4"></path>
                  </svg>
                  <span>高级筛选</span>
                </button>
              </div>
            </div>
            
            <!-- 高级筛选面板 -->
            <div v-if="showAdvancedFilter" 
                 class="mb-6 p-4 bg-gray-50 rounded-lg border border-gray-200 transition-all duration-300">
              <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <!-- 项目数量范围 -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">项目数量范围</label>
                  <div class="flex items-center space-x-2">
                    <input v-model="filters.projectMin" 
                           type="number" 
                           placeholder="最少" 
                           class="w-20 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500">
                    <span class="text-gray-500">-</span>
                    <input v-model="filters.projectMax" 
                           type="number" 
                           placeholder="最多" 
                           class="w-20 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500">
                  </div>
                </div>
                
                <!-- 受益人数范围 -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">受益人数范围</label>
                  <div class="flex items-center space-x-2">
                    <input v-model="filters.beneficiariesMin" 
                           type="number" 
                           placeholder="最少" 
                           class="w-20 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500">
                    <span class="text-gray-500">-</span>
                    <input v-model="filters.beneficiariesMax" 
                           type="number" 
                           placeholder="最多" 
                           class="w-20 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500">
                  </div>
                </div>
                
                <!-- 地区类型 -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">地区类型</label>
                  <select v-model="filters.regionType" 
                          class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500">
                    <option value="all">全部类型</option>
                    <option value="key">重点扶贫地区</option>
                    <option value="special">特殊扶贫地区</option>
                    <option value="developing">发展中地区</option>
                    <option value="developed">发达地区</option>
                  </select>
                </div>
              </div>
              
              <div class="flex items-center justify-between mt-4">
                <div class="text-sm text-gray-600">
                  共找到 <span class="font-semibold text-blue-600">{{ filteredResults.length }}</span> 个符合条件的地区
                </div>
                <div class="flex space-x-2">
                  <button @click="resetFilters" 
                          class="px-3 py-1 text-sm text-gray-600 hover:text-gray-800 transition-colors">
                    重置
                  </button>
                  <button @click="applyFilters" 
                          class="px-4 py-1 bg-blue-500 text-white text-sm rounded hover:bg-blue-600 transition-colors">
                    应用筛选
                  </button>
                </div>
              </div>
            </div>
            
            <!-- 地图容器 -->
            <div class="bg-gray-50 rounded-xl overflow-hidden shadow-inner">
              <GeoComponent :data="filteredMapData" @region-click="handleRegionClick" @data-refresh="handleDataRefresh" />
            </div>
            
            <!-- 地图操作提示 -->
            <div class="mt-4 flex items-center justify-between text-sm text-gray-600">
              <div class="flex items-center space-x-4">
                <div class="flex items-center space-x-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.122 2.122"></path>
                  </svg>
                  <span>点击省份查看详情</span>
                </div>
                <div class="flex items-center space-x-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path>
                  </svg>
                  <span>鼠标滚轮缩放</span>
                </div>
                <div class="flex items-center space-x-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 4V2a1 1 0 011-1h8a1 1 0 011 1v2m4 0H3a1 1 0 00-1 1v14a1 1 0 001 1h18a1 1 0 001-1V5a1 1 0 00-1-1z"></path>
                  </svg>
                  <span>拖拽移动视图</span>
                </div>
              </div>
              <div class="text-blue-600 font-medium">
                最后更新：{{ lastRefreshTime }}
              </div>
            </div>
          </div>

          <!-- 地区详情 -->
          <div v-if="selectedRegion" class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-up">
            <div class="flex items-center justify-between mb-6">
              <h3 class="text-xl font-bold text-gray-900 flex items-center space-x-2">
                <span class="text-2xl">🏛️</span>
                <span>{{ selectedRegion.name }} - 扶贫详情</span>
              </h3>
              <button @click="selectedRegion = null" 
                      class="text-gray-400 hover:text-gray-600 transition-colors">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
              <div class="bg-gradient-to-r from-blue-50 to-blue-100 rounded-lg p-4 text-center transform hover:scale-105 transition-transform">
                <div class="text-3xl font-bold text-blue-600">{{ selectedRegion.projects || 0 }}</div>
                <div class="text-sm text-gray-600 mt-1">扶贫项目</div>
                <div class="text-xs text-blue-500 mt-2">📊 同比增长12%</div>
              </div>
              <div class="bg-gradient-to-r from-green-50 to-green-100 rounded-lg p-4 text-center transform hover:scale-105 transition-transform">
                <div class="text-3xl font-bold text-green-600">{{ selectedRegion.beneficiaries || 0 }}</div>
                <div class="text-sm text-gray-600 mt-1">受益人数</div>
                <div class="text-xs text-green-500 mt-2">👥 覆盖率89%</div>
              </div>
              <div class="bg-gradient-to-r from-purple-50 to-purple-100 rounded-lg p-4 text-center transform hover:scale-105 transition-transform">
                <div class="text-3xl font-bold text-purple-600">{{ selectedRegion.investment || 0 }}万</div>
                <div class="text-sm text-gray-600 mt-1">投资金额</div>
                <div class="text-xs text-purple-500 mt-2">💰 执行率94%</div>
              </div>
              <div class="bg-gradient-to-r from-orange-50 to-orange-100 rounded-lg p-4 text-center transform hover:scale-105 transition-transform">
                <div class="text-3xl font-bold text-orange-600">{{ Math.floor((selectedRegion.projects || 0) * 0.78) }}</div>
                <div class="text-sm text-gray-600 mt-1">已完成</div>
                <div class="text-xs text-orange-500 mt-2">✅ 完成率78%</div>
              </div>
            </div>
            
            <!-- 该地区项目列表 -->
            <div class="mt-6">
              <div class="flex items-center justify-between mb-4">
                <h4 class="text-lg font-semibold text-gray-900">主要项目</h4>
                <button class="text-sm text-blue-600 hover:text-blue-800 transition-colors">
                  查看全部 →
                </button>
              </div>
              <div class="space-y-3 max-h-64 overflow-y-auto">
                <div v-for="project in selectedRegion.projectList || []" :key="project.id" 
                     class="bg-gray-50 rounded-lg p-4 hover:bg-gray-100 transition-colors cursor-pointer
                            border-l-4 border-blue-500">
                  <div class="flex items-center justify-between">
                    <div class="flex-1">
                      <h5 class="font-medium text-gray-900 flex items-center space-x-2">
                        <span>{{ project.name }}</span>
                        <span v-if="project.status === 'completed'" class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">已完成</span>
                        <span v-else-if="project.status === 'in_progress'" class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">进行中</span>
                        <span v-else class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">待启动</span>
                      </h5>
                      <p class="text-sm text-gray-600 mt-1">{{ project.category }} · {{ project.startDate }} · {{ project.progress || '78' }}%进度</p>
                      <div class="flex items-center mt-2 space-x-4">
                        <span class="text-xs text-gray-500">👥 受益{{ project.beneficiaries || Math.floor(Math.random() * 500 + 100) }}人</span>
                        <span class="text-xs text-gray-500">📍 {{ project.location || '多个乡镇' }}</span>
                      </div>
                    </div>
                    <div class="text-right ml-4">
                      <div class="font-semibold text-blue-600">{{ project.investment }}万</div>
                      <div class="text-sm text-gray-500">投资额</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 侧边栏 -->
        <div class="space-y-6">
          <!-- 实时数据概览 -->
          <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-left">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center space-x-2">
              <span class="text-xl">📈</span>
              <span>实时概览</span>
            </h3>
            <div class="space-y-4">
              <div class="flex justify-between items-center p-3 bg-blue-50 rounded-lg">
                <span class="text-gray-700 font-medium">项目总数：</span>
                <span class="font-bold text-blue-600 text-lg">{{ statistics.totalProjects }}</span>
              </div>
              <div class="flex justify-between items-center p-3 bg-green-50 rounded-lg">
                <span class="text-gray-700 font-medium">覆盖省份：</span>
                <span class="font-bold text-green-600 text-lg">{{ statistics.provinces }}</span>
              </div>
              <div class="flex justify-between items-center p-3 bg-purple-50 rounded-lg">
                <span class="text-gray-700 font-medium">受益人口：</span>
                <span class="font-bold text-purple-600 text-lg">{{ statistics.totalBeneficiaries }}万</span>
              </div>
              <div class="flex justify-between items-center p-3 bg-orange-50 rounded-lg">
                <span class="text-gray-700 font-medium">投资总额：</span>
                <span class="font-bold text-orange-600 text-lg">{{ statistics.totalInvestment }}亿</span>
              </div>
            </div>
            
            <!-- 实时增长指标 -->
            <div class="mt-6 pt-4 border-t border-gray-200">
              <div class="text-sm text-gray-600 mb-3">24小时增长</div>
              <div class="grid grid-cols-2 gap-3 text-xs">
                <div class="text-center p-2 bg-gray-50 rounded">
                  <div class="font-bold text-green-600">+{{ dailyGrowth.projects }}</div>
                  <div class="text-gray-500">新增项目</div>
                </div>
                <div class="text-center p-2 bg-gray-50 rounded">
                  <div class="font-bold text-blue-600">+{{ dailyGrowth.beneficiaries }}</div>
                  <div class="text-gray-500">新增受益</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 项目类型分布 -->
          <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-left" data-aos-delay="100">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center space-x-2">
              <span class="text-xl">🎯</span>
              <span>项目类型</span>
            </h3>
            <div class="space-y-3">
              <div v-for="category in projectCategories" :key="category.name" 
                   class="flex items-center justify-between p-3 rounded-lg hover:bg-gray-50 transition-colors cursor-pointer"
                   @click="filterByCategory(category.type)">
                <div class="flex items-center space-x-3">
                  <div :class="['w-4 h-4 rounded-full', category.color]"></div>
                  <span class="text-gray-700 font-medium">{{ category.name }}</span>
                </div>
                <div class="flex items-center space-x-2">
                  <span class="font-bold text-gray-900">{{ category.count }}</span>
                  <span class="text-xs text-gray-500">{{ category.percentage }}%</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 热门地区排行 -->
          <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-left" data-aos-delay="200">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center space-x-2">
              <span class="text-xl">🏆</span>
              <span>热门地区</span>
            </h3>
            <div class="space-y-3">
              <div v-for="(region, index) in topRegions" :key="region.name" 
                   class="flex items-center justify-between cursor-pointer hover:bg-gray-50 p-3 rounded-lg transition-colors"
                   @click="selectRegion(region)">
                <div class="flex items-center space-x-3">
                  <div :class="[
                    'w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white',
                    index === 0 ? 'bg-yellow-500' : index === 1 ? 'bg-gray-400' : index === 2 ? 'bg-orange-500' : 'bg-blue-500'
                  ]">
                    {{ index + 1 }}
                  </div>
                  <div>
                    <div class="font-medium text-gray-900">{{ region.name }}</div>
                    <div class="text-xs text-gray-500">{{ getCategoryName(region.category) }}</div>
                  </div>
                </div>
                <div class="text-right">
                  <div class="font-bold text-blue-600">{{ region.projects }}</div>
                  <div class="text-xs text-gray-500">个项目</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 最新项目动态 -->
          <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-100" data-aos="fade-left" data-aos-delay="300">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center space-x-2">
              <span class="text-xl">🆕</span>
              <span>最新动态</span>
            </h3>
            <div class="space-y-4">
              <div v-for="project in recentProjects" :key="project.id" 
                   class="border-l-4 border-green-500 pl-4 hover:bg-gray-50 p-2 rounded-r transition-colors">
                <h4 class="font-medium text-gray-900 text-sm">{{ project.name }}</h4>
                <p class="text-xs text-gray-600 mt-1">{{ project.location }} · {{ project.date }}</p>
                <div class="flex items-center justify-between mt-2">
                  <p class="text-xs text-green-600 font-medium">{{ project.investment }}万投资</p>
                  <span v-if="project.isNew" class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full animate-pulse">
                    🔥 热门
                  </span>
                </div>
              </div>
            </div>
            
            <button class="w-full mt-4 py-2 text-sm text-blue-600 hover:text-blue-800 border border-blue-200 
                           hover:border-blue-300 rounded-lg transition-colors">
              查看更多动态 →
            </button>
          </div>
          
          <!-- 快速操作 -->
          <div class="bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl shadow-lg p-6 text-white" data-aos="fade-left" data-aos-delay="400">
            <h3 class="text-lg font-bold mb-4">快速操作</h3>
            <div class="space-y-3">
              <button class="w-full py-2 bg-white/20 hover:bg-white/30 rounded-lg text-sm font-medium transition-colors">
                📊 生成数据报告
              </button>
              <button class="w-full py-2 bg-white/20 hover:bg-white/30 rounded-lg text-sm font-medium transition-colors">
                📤 导出地图数据
              </button>
              <button class="w-full py-2 bg-white/20 hover:bg-white/30 rounded-lg text-sm font-medium transition-colors">
                🔗 分享地图链接
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import GeoComponent from '@/components/GeoComponent.vue'
import GlobalNav from '@/components/GlobalNav.vue'
import AOS from 'aos'

// 响应式数据
const selectedYear = ref('all')
const selectedCategory = ref('all')
const selectedRegion = ref(null)
const searchQuery = ref('')
const showAdvancedFilter = ref(false)
const onlineUsers = ref(1248)
const lastRefreshTime = ref('')

// 高级筛选器
const filters = ref({
  projectMin: '',
  projectMax: '',
  beneficiariesMin: '',
  beneficiariesMax: '',
  regionType: 'all'
})

// 日增长数据
const dailyGrowth = ref({
  projects: 5,
  beneficiaries: 892
})

// 模拟地图数据
const mapData = ref([
  {
    name: '山西省',
    code: 'SX',
    projects: 45,
    beneficiaries: 12000,
    investment: 8500,
    projectList: [
      { id: 1, name: '晋中果品产业扶贫', category: '农业扶贫', startDate: '2024-01', investment: 1200 },
      { id: 2, name: '阳泉教育基础设施', category: '教育扶贫', startDate: '2023-08', investment: 800 },
      { id: 3, name: '临汾医疗服务提升', category: '医疗扶贫', startDate: '2023-12', investment: 650 }
    ]
  },
  {
    name: '云南省',
    code: 'YN',
    projects: 38,
    beneficiaries: 9800,
    investment: 7200,
    projectList: [
      { id: 4, name: '普洱茶产业扶贫', category: '农业扶贫', startDate: '2024-02', investment: 1500 },
      { id: 5, name: '怒江交通建设', category: '基础设施', startDate: '2023-10', investment: 2000 },
      { id: 6, name: '大理旅游扶贫', category: '文旅扶贫', startDate: '2023-09', investment: 900 }
    ]
  },
  {
    name: '贵州省',
    code: 'GZ',
    projects: 42,
    beneficiaries: 11500,
    investment: 9100,
    projectList: [
      { id: 7, name: '遵义辣椒产业', category: '农业扶贫', startDate: '2024-01', investment: 1100 },
      { id: 8, name: '毕节职业培训', category: '教育扶贫', startDate: '2023-11', investment: 600 },
      { id: 9, name: '黔南生态修复', category: '环保扶贫', startDate: '2023-07', investment: 1300 }
    ]
  }
])

// 统计数据
const statistics = ref({
  totalProjects: 485,
  provinces: 31,
  totalBeneficiaries: 156.8,
  totalInvestment: 425.6
})

// 项目类型分布
const projectCategories = ref([
  { name: '农业扶贫', type: 'agriculture', count: 186, color: 'bg-green-500', percentage: 38.4 },
  { name: '教育扶贫', type: 'education', count: 124, color: 'bg-blue-500', percentage: 25.6 },
  { name: '医疗扶贫', type: 'healthcare', count: 89, color: 'bg-red-500', percentage: 18.4 },
  { name: '基础设施', type: 'infrastructure', count: 86, color: 'bg-yellow-500', percentage: 17.7 }
])

// 热门地区
const topRegions = ref([
  { name: '山西省', projects: 45, code: 'SX', category: '农业扶贫' },
  { name: '贵州省', projects: 42, code: 'GZ', category: '教育扶贫' },
  { name: '云南省', projects: 38, code: 'YN', category: '文旅扶贫' },
  { name: '甘肃省', projects: 35, code: 'GS', category: '基础设施' },
  { name: '新疆', projects: 32, code: 'XJ', category: '农业扶贫' }
])

// 最新项目
const recentProjects = ref([
  { id: 1, name: '晋中果品产业扶贫', location: '山西晋中', date: '2024-01-15', investment: 1200 },
  { id: 2, name: '普洱茶产业扶贫', location: '云南普洱', date: '2024-02-08', investment: 1500 },
  { id: 3, name: '遵义辣椒产业', location: '贵州遵义', date: '2024-01-20', investment: 1100 },
  { id: 4, name: '陇南中药材种植', location: '甘肃陇南', date: '2024-02-12', investment: 980 }
])

// 计算属性
const totalProjects = computed(() => {
  return mapData.value.reduce((sum, region) => sum + region.projects, 0)
})

const totalBeneficiaries = computed(() => {
  return mapData.value.reduce((sum, region) => sum + region.beneficiaries, 0)
})

const filteredMapData = computed(() => {
  // 根据年份和类型过滤数据
  return mapData.value
})

// 分类名称映射
const categoryMap = {
  '农业扶贫': 'agriculture',
  '教育扶贫': 'education',
  '医疗扶贫': 'healthcare',
  '基础设施': 'infrastructure',
  '文旅扶贫': 'tourism',
  '环保扶贫': 'environment'
}

// 方法
const getCategoryName = (category) => {
  if (!category) return '未分类'
  
  // 如果已经是中文，直接返回
  if (Object.keys(categoryMap).includes(category)) {
    return category
  }
  
  // 从英文转换为中文
  const categoryNames = {
    'agriculture': '农业扶贫',
    'education': '教育扶贫',
    'healthcare': '医疗扶贫',
    'infrastructure': '基础设施',
    'tourism': '文旅扶贫',
    'environment': '环保扶贫'
  }
  
  return categoryNames[category] || category
}

const handleRegionClick = (regionData) => {
  const region = mapData.value.find(r => r.code === regionData.code)
  if (region) {
    selectedRegion.value = region
  }
}

const selectRegion = (region) => {
  const fullRegion = mapData.value.find(r => r.code === region.code)
  if (fullRegion) {
    selectedRegion.value = fullRegion
  }
}

const handleDataRefresh = () => {
  lastRefreshTime.value = new Date().toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const resetFilters = () => {
  filters.value = {
    projectMin: '',
    projectMax: '',
    beneficiariesMin: '',
    beneficiariesMax: '',
    regionType: 'all'
  }
  selectedYear.value = 'all'
  selectedCategory.value = 'all'
  searchQuery.value = ''
}

const applyFilters = () => {
  // 应用筛选逻辑
  console.log('应用筛选条件:', filters.value)
}

const filterByCategory = (categoryType) => {
  if (!categoryType) return
  
  // 根据类型筛选
  const typeMapping = {
    'agriculture': 'agriculture',
    'education': 'education', 
    'healthcare': 'healthcare',
    'infrastructure': 'infrastructure',
    'tourism': 'tourism'
  }
  
  selectedCategory.value = typeMapping[categoryType] || categoryType
}

// 计算筛选结果
const filteredResults = computed(() => {
  return mapData.value.filter(region => {
    let matches = true
    
    // 搜索筛选
    if (searchQuery.value) {
      matches = matches && region.name.includes(searchQuery.value)
    }
    
    // 项目数量筛选
    if (filters.value.projectMin) {
      matches = matches && region.projects >= parseInt(filters.value.projectMin)
    }
    if (filters.value.projectMax) {
      matches = matches && region.projects <= parseInt(filters.value.projectMax)
    }
    
    // 受益人数筛选
    if (filters.value.beneficiariesMin) {
      matches = matches && region.beneficiaries >= parseInt(filters.value.beneficiariesMin)
    }
    if (filters.value.beneficiariesMax) {
      matches = matches && region.beneficiaries <= parseInt(filters.value.beneficiariesMax)
    }
    
    return matches
  })
})

onMounted(() => {
  AOS.init({
    duration: 800,
    once: true
  })
  
  // 初始化刷新时间
  handleDataRefresh()
})
</script>

<style scoped>
/* 自定义样式 */
.transition-colors {
  transition: background-color 0.2s ease-in-out;
}
</style> 