<template>
  <div class="min-h-screen bg-chinese-light-gradient">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 页面头部 -->
    <div class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-chinese-dark mb-4">扶贫数据看板</h1>
          <p class="text-lg text-gray-600">实时监控扶贫成效，数据见证脱贫攻坚成就</p>
        </div>
      </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- 核心指标 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard 
          icon="👨‍🌾" 
          :value="dashboardData.totalStats.farmers"
          label="帮扶农户总数"
          :trend="`+${dashboardData.totalStats.farmersGrowth}%`"
          color="chinese-red"
          :animated="true"
          :show-progress="true"
          :progress-value="dashboardData.totalStats.farmers"
          :progress-max="15000"
          description="较去年同期增长"
        />
        
        <StatCard 
          icon="📦" 
          :value="dashboardData.totalStats.sales"
          label="农产品销售额"
          :trend="`+${dashboardData.totalStats.salesGrowth}%`"
          color="chinese-green"
          unit="元"
          :animated="true"
          :show-progress="true"
          :progress-value="dashboardData.totalStats.sales"
          :progress-max="300000000"
          description="累计销售额突破新高"
        />
        
        <StatCard 
          icon="🏪" 
          :value="dashboardData.totalStats.products"
          label="上架产品数量"
          :trend="`+${dashboardData.totalStats.productsGrowth}%`"
          color="chinese-gold"
          :animated="true"
          :show-progress="true"
          :progress-value="dashboardData.totalStats.products"
          :progress-max="1500"
          description="覆盖全国各地特色产品"
        />
        
        <StatCard 
          icon="🏘️" 
          :value="dashboardData.totalStats.counties"
          label="受益脱贫县数量"
          :trend="`+${dashboardData.totalStats.countiesGrowth}%`"
          color="chinese-dark"
          :animated="true"
          :show-progress="true"
          :progress-value="dashboardData.totalStats.counties"
          :progress-max="832"
          description="全国832个脱贫县"
        />
      </div>

      <!-- 扶贫成效概览 -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
        <!-- 脱贫成效 -->
        <div class="lg:col-span-2 dashboard-panel p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-bold text-chinese-dark">脱贫攻坚成效</h3>
            <div class="text-sm text-gray-600">
              脱贫率: {{ dashboardData.povertyAlleviationData.liftedPercentage }}%
            </div>
          </div>
          
          <div class="grid grid-cols-2 gap-6 mb-6">
            <div class="text-center">
              <div class="text-3xl font-bold text-chinese-red mb-2">
                {{ dashboardData.povertyAlleviationData.totalHouseholds.toLocaleString() }}
              </div>
              <div class="text-sm text-gray-600">总建档立卡户</div>
            </div>
            
            <div class="text-center">
              <div class="text-3xl font-bold text-chinese-green mb-2">
                {{ dashboardData.povertyAlleviationData.liftedHouseholds.toLocaleString() }}
              </div>
              <div class="text-sm text-gray-600">已脱贫户数</div>
            </div>
          </div>
          
          <!-- 进度条 -->
          <div class="mb-6">
            <div class="flex justify-between text-sm text-gray-600 mb-2">
              <span>脱贫进度</span>
              <span>{{ dashboardData.povertyAlleviationData.liftedPercentage }}%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3">
              <div 
                class="bg-gradient-to-r from-chinese-red to-chinese-green h-3 rounded-full transition-all duration-1000 ease-out"
                :style="{ width: `${dashboardData.povertyAlleviationData.liftedPercentage}%` }"
              ></div>
            </div>
          </div>
          
          <div class="grid grid-cols-2 gap-4 text-sm">
            <div class="bg-chinese-beige bg-opacity-50 p-4 rounded-lg">
              <div class="text-lg font-bold text-chinese-dark">{{ dashboardData.povertyAlleviationData.averageIncome.toLocaleString() }}元</div>
              <div class="text-gray-600">人均年收入</div>
              <div class="text-chinese-green text-xs mt-1">较基准年增长{{ dashboardData.povertyAlleviationData.incomeGrowth }}%</div>
            </div>
            
            <div class="bg-chinese-beige bg-opacity-50 p-4 rounded-lg">
              <div class="text-lg font-bold text-chinese-dark">{{ dashboardData.povertyAlleviationData.jobsCreated.toLocaleString() }}个</div>
              <div class="text-gray-600">新增就业岗位</div>
              <div class="text-chinese-green text-xs mt-1">覆盖{{ dashboardData.povertyAlleviationData.beneficiaries.toLocaleString() }}受益人群</div>
            </div>
          </div>
        </div>
        
        <!-- 实时数据 -->
        <div class="dashboard-panel p-6">
          <h3 class="text-xl font-bold text-chinese-dark mb-6">实时数据</h3>
          
          <div class="space-y-6">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <div class="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
                <span class="text-sm text-gray-600">在线用户</span>
              </div>
              <span class="font-bold text-chinese-dark">{{ dashboardData.realtimeData.onlineUsers.toLocaleString() }}</span>
            </div>
            
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <div class="text-lg">📦</div>
                <span class="text-sm text-gray-600">今日订单</span>
              </div>
              <span class="font-bold text-chinese-dark">{{ dashboardData.realtimeData.todayOrders }}</span>
            </div>
            
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <div class="text-lg">💰</div>
                <span class="text-sm text-gray-600">今日销售额</span>
              </div>
              <span class="font-bold text-chinese-green">¥{{ dashboardData.realtimeData.todaySales.toLocaleString() }}</span>
            </div>
            
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <div class="text-lg">🛍️</div>
                <span class="text-sm text-gray-600">活跃商品</span>
              </div>
              <span class="font-bold text-chinese-dark">{{ dashboardData.realtimeData.activeProducts }}</span>
            </div>
          </div>
          
          <div class="mt-6 pt-4 border-t text-xs text-gray-500">
            最后更新: {{ new Date().toLocaleTimeString('zh-CN') }}
          </div>
        </div>
      </div>

      <!-- 数据可视化图表 -->
      <DataVisualization />

      <!-- 热门产品和成功案例 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-8">
        <!-- 热门产品排行 -->
        <div class="dashboard-panel p-6">
          <h3 class="text-xl font-bold text-chinese-dark mb-6">热门产品排行</h3>
          
          <div class="space-y-4">
            <div 
              v-for="(product, index) in dashboardData.topProducts" 
              :key="product.name"
              class="flex items-center space-x-4 p-3 rounded-lg hover:bg-chinese-beige hover:bg-opacity-30 transition-colors cursor-pointer"
            >
              <div 
                class="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm"
                :class="index === 0 ? 'bg-yellow-500' : index === 1 ? 'bg-gray-400' : index === 2 ? 'bg-yellow-600' : 'bg-chinese-red'"
              >
                {{ index + 1 }}
              </div>
              
              <div class="flex-1">
                <div class="font-medium text-chinese-dark">{{ product.name }}</div>
                <div class="text-sm text-gray-600">销量: {{ product.sales.toLocaleString() }}</div>
              </div>
              
              <div class="text-right">
                <div class="text-sm font-medium text-chinese-green">+{{ product.growth }}%</div>
                <div class="text-xs text-gray-500">较上月</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 成功案例统计 -->
        <div class="dashboard-panel p-6">
          <h3 class="text-xl font-bold text-chinese-dark mb-6">扶贫故事分类</h3>
          
          <div class="space-y-4">
            <div class="flex items-center justify-between p-3 rounded-lg bg-chinese-beige bg-opacity-30">
              <div class="flex items-center space-x-3">
                <div class="text-2xl">🏭</div>
                <div>
                  <div class="font-medium text-chinese-dark">产业扶贫</div>
                  <div class="text-sm text-gray-600">发展特色产业带动脱贫</div>
                </div>
              </div>
              <div class="text-xl font-bold text-chinese-red">
                {{ dashboardData.successStories.industrialPoverty }}
              </div>
            </div>
            
            <div class="flex items-center justify-between p-3 rounded-lg bg-chinese-beige bg-opacity-30">
              <div class="flex items-center space-x-3">
                <div class="text-2xl">🎓</div>
                <div>
                  <div class="font-medium text-chinese-dark">教育扶贫</div>
                  <div class="text-sm text-gray-600">教育改变命运阻断贫困</div>
                </div>
              </div>
              <div class="text-xl font-bold text-chinese-green">
                {{ dashboardData.successStories.educationPoverty }}
              </div>
            </div>
            
            <div class="flex items-center justify-between p-3 rounded-lg bg-chinese-beige bg-opacity-30">
              <div class="flex items-center space-x-3">
                <div class="text-2xl">🏥</div>
                <div>
                  <div class="font-medium text-chinese-dark">健康扶贫</div>
                  <div class="text-sm text-gray-600">医疗保障守护健康</div>
                </div>
              </div>
              <div class="text-xl font-bold text-chinese-gold">
                {{ dashboardData.successStories.healthPoverty }}
              </div>
            </div>
            
            <div class="flex items-center justify-between p-3 rounded-lg bg-chinese-beige bg-opacity-30">
              <div class="flex items-center space-x-3">
                <div class="text-2xl">🗾</div>
                <div>
                  <div class="font-medium text-chinese-dark">旅游扶贫</div>
                  <div class="text-sm text-gray-600">美丽乡村带动经济发展</div>
                </div>
              </div>
              <div class="text-xl font-bold text-chinese-dark">
                {{ dashboardData.successStories.tourismPoverty }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StatCard from '@/components/StatCard.vue'
import DataVisualization from '@/components/DataVisualization.vue'
import { dashboardData } from '@/data/dashboard'
import GlobalNav from '@/components/GlobalNav.vue'

// 生命周期
onMounted(() => {
  // 设置页面标题
  document.title = '数据看板 - 中国助农扶贫平台'
})
</script>

<style scoped>
.dashboard-panel {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(248, 243, 230, 0.3);
  border-radius: 0.75rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}
</style> 