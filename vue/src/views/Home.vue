<template>
  <div class="min-h-screen bg-chinese-light-gradient">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 主导航栏 -->
    <nav class="bg-white shadow-lg sticky top-0 z-40">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <!-- Logo -->
          <div class="flex items-center space-x-3">
            <div class="text-2xl">🌾</div>
            <h1 class="text-2xl font-bold text-chinese-gradient">中国助农扶贫平台</h1>
          </div>
          
          <!-- 导航链接 -->
          <div class="hidden md:flex space-x-8">
            <router-link to="/" class="nav-link nav-link-active">首页</router-link>
            <router-link to="/products" class="nav-link">产品展厅</router-link>
            <router-link to="/stories" class="nav-link">扶贫故事</router-link>
            <router-link to="/dashboard" class="nav-link">数据看板</router-link>
            <router-link to="/about" class="nav-link">助农计划</router-link>
          </div>
          
          <!-- 移动端菜单按钮 -->
          <button 
            @click="showMobileMenu = !showMobileMenu"
            class="md:hidden p-2 rounded-lg hover:bg-chinese-beige transition-colors"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
          </button>
        </div>
        
        <!-- 移动端菜单 -->
        <div v-if="showMobileMenu" class="md:hidden py-4 border-t">
          <div class="flex flex-col space-y-4">
            <router-link to="/" class="nav-link">首页</router-link>
            <router-link to="/products" class="nav-link">产品展厅</router-link>
            <router-link to="/stories" class="nav-link">扶贫故事</router-link>
            <router-link to="/dashboard" class="nav-link">数据看板</router-link>
            <router-link to="/about" class="nav-link">助农计划</router-link>
          </div>
        </div>
      </div>
    </nav>

    <!-- 英雄区域 -->
    <section class="relative overflow-hidden py-20">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <!-- 文本内容 -->
          <div class="animate-fade-in-left">
            <h2 class="text-5xl font-bold text-chinese-dark mb-6">
              助力乡村振兴
              <span class="block text-chinese-gradient">共创美好未来</span>
            </h2>
            <p class="text-xl text-gray-600 mb-8 leading-relaxed">
              通过数字化平台连接优质农产品与消费者，让每一份购买都成为对脱贫攻坚成果的有力支持。
            </p>
            <div class="flex flex-col sm:flex-row gap-4">
              <button 
                @click="scrollToProducts"
                class="btn-chinese text-lg px-8 py-3"
              >
                浏览产品
              </button>
              <button 
                @click="scrollToStories"
                class="btn-chinese-outline text-lg px-8 py-3"
              >
                了解故事
              </button>
            </div>
          </div>
          
          <!-- 3D展示区域 -->
          <div class="animate-fade-in-right">
            <ProductModel 
              :model-name="currentModel" 
              :auto-rotate="true"
              class="w-full h-96 rounded-xl shadow-2xl"
            />
            <div class="flex justify-center mt-4 space-x-4">
              <button 
                v-for="model in models" 
                :key="model.name"
                @click="currentModel = model.name"
                class="px-4 py-2 rounded-lg text-sm transition-all duration-200"
                :class="currentModel === model.name ? 'bg-chinese-red text-white' : 'bg-white text-chinese-dark hover:bg-chinese-beige'"
              >
                {{ model.label }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 数据概览 -->
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h3 class="text-3xl font-bold text-chinese-dark mb-4">扶贫成果展示</h3>
          <p class="text-gray-600 text-lg">数据见证脱贫攻坚的伟大成就</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <StatCard 
            icon="👨‍🌾" 
            :value="dashboardData.totalStats.farmers"
            label="帮扶农户"
            :trend="`+${dashboardData.totalStats.farmersGrowth}%`"
            color="chinese-red"
            :animated="true"
            class="animate-fade-in-up"
            style="animation-delay: 0.1s"
          />
          <StatCard 
            icon="📦" 
            :value="dashboardData.totalStats.sales"
            label="农产品销售额"
            :trend="`+${dashboardData.totalStats.salesGrowth}%`"
            color="chinese-green"
            unit="元"
            :animated="true"
            class="animate-fade-in-up"
            style="animation-delay: 0.2s"
          />
          <StatCard 
            icon="🏪" 
            :value="dashboardData.totalStats.products"
            label="农产品种类"
            :trend="`+${dashboardData.totalStats.productsGrowth}%`"
            color="chinese-gold"
            :animated="true"
            class="animate-fade-in-up"
            style="animation-delay: 0.3s"
          />
          <StatCard 
            icon="🏘️" 
            :value="dashboardData.totalStats.counties"
            label="脱贫县数量"
            :trend="`+${dashboardData.totalStats.countiesGrowth}%`"
            color="chinese-dark"
            :animated="true"
            class="animate-fade-in-up"
            style="animation-delay: 0.4s"
          />
        </div>
      </div>
    </section>

    <!-- 产品展示 -->
    <section ref="productsSection" class="py-16 bg-chinese-light-gradient">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h3 class="text-3xl font-bold text-chinese-dark mb-4">精选农产品</h3>
          <p class="text-gray-600 text-lg">来自全国各地的优质农产品</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
          <div 
            v-for="product in featuredProducts" 
            :key="product.id"
            class="product-card p-6 group cursor-pointer"
            @click="goToProduct(product.id)"
          >
            <!-- 产品图片 -->
            <div class="relative mb-4">
              <div class="w-full h-48 bg-gradient-to-br from-chinese-beige to-chinese-light rounded-lg flex items-center justify-center">
                <span class="text-4xl">{{ getProductIcon(product.category) }}</span>
              </div>
              <div class="absolute top-2 right-2 bg-chinese-red text-white px-2 py-1 rounded-full text-xs">
                {{ Math.round(product.discount * 100) }}折
              </div>
            </div>
            
            <!-- 产品信息 -->
            <div>
              <h4 class="font-bold text-chinese-dark mb-2 group-hover:text-chinese-red transition-colors">
                {{ product.name }}
              </h4>
              <p class="text-sm text-gray-600 mb-2">{{ product.origin }}</p>
              <p class="text-sm text-gray-500 mb-3 text-ellipsis-2">{{ product.story }}</p>
              
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-2">
                  <span class="text-lg font-bold text-chinese-red">¥{{ product.price }}</span>
                  <span class="text-sm text-gray-400 line-through">¥{{ product.originalPrice }}</span>
                </div>
                <div class="flex items-center space-x-1 text-sm text-gray-500">
                  <span>⭐</span>
                  <span>{{ product.rating }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="text-center mt-12">
          <router-link to="/products" class="btn-chinese text-lg px-8 py-3">
            查看更多产品
          </router-link>
        </div>
      </div>
    </section>

    <!-- 扶贫故事 -->
    <section ref="storiesSection" class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h3 class="text-3xl font-bold text-chinese-dark mb-4">扶贫故事</h3>
          <p class="text-gray-600 text-lg">真实的脱贫故事，感人的奋斗历程</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div 
            v-for="story in featuredStories" 
            :key="story.id"
            class="story-card p-6 cursor-pointer"
            @click="goToStory(story.id)"
          >
            <div class="mb-4">
              <span class="inline-block bg-chinese-green text-white px-3 py-1 rounded-full text-sm mb-2">
                {{ story.category }}
              </span>
              <h4 class="font-bold text-chinese-dark mb-2">{{ story.title }}</h4>
              <p class="text-sm text-gray-600 mb-2">{{ story.location }}</p>
            </div>
            
            <p class="text-gray-700 text-ellipsis-3 mb-4">{{ story.content }}</p>
            
            <div class="flex items-center justify-between text-sm">
              <span class="text-chinese-green font-medium">{{ story.impact }}</span>
              <span class="text-gray-500">{{ formatDate(story.date) }}</span>
            </div>
          </div>
        </div>
        
        <div class="text-center mt-12">
          <router-link to="/stories" class="btn-chinese text-lg px-8 py-3">
            更多故事
          </router-link>
        </div>
      </div>
    </section>

    <!-- 系统入口 -->
    <section class="py-16 bg-gradient-to-r from-chinese-dark via-chinese-red to-chinese-dark">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h3 class="text-3xl font-bold text-white mb-4">系统入口</h3>
          <p class="text-chinese-beige text-lg">根据您的身份选择合适的系统入口</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- 访客入口 -->
          <div class="system-entry-card group">
            <div class="text-center">
              <div class="w-20 h-20 bg-white rounded-full flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                <span class="text-3xl">🌟</span>
              </div>
              <h4 class="text-xl font-bold text-white mb-4">展示平台</h4>
              <p class="text-chinese-beige mb-6 text-sm">
                浏览农产品、了解扶贫故事、查看数据看板，无需登录即可访问
              </p>
              <div class="space-y-3">
                <router-link to="/products" class="btn-white-outline w-full block text-center">产品展厅</router-link>
                <router-link to="/stories" class="btn-white-outline w-full block text-center">扶贫故事</router-link>
                <router-link to="/dashboard" class="btn-white-outline w-full block text-center">数据看板</router-link>
              </div>
            </div>
          </div>

          <!-- 用户入口 -->
          <div class="system-entry-card group">
            <div class="text-center">
              <div class="w-20 h-20 bg-white rounded-full flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                <span class="text-3xl">👤</span>
              </div>
              <h4 class="text-xl font-bold text-white mb-4">用户中心</h4>
              <p class="text-chinese-beige mb-6 text-sm">
                个人信息管理、订单管理、扶贫申请等用户专属功能
              </p>
              <div class="space-y-3">
                <button v-if="!user.id" @click="$router.push('/login')" class="btn-white w-full">
                  登录使用
                </button>
                <button v-else-if="user.role === 'USER'" @click="goToUserCenter" class="btn-white w-full">
                  进入用户中心
                </button>
                <button v-else @click="showUserTip" class="btn-white-outline w-full">
                  需要用户权限
                </button>
              </div>
            </div>
          </div>

          <!-- 管理员入口 -->
          <div class="system-entry-card group">
            <div class="text-center">
              <div class="w-20 h-20 bg-white rounded-full flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                <span class="text-3xl">⚙️</span>
              </div>
              <h4 class="text-xl font-bold text-white mb-4">管理后台</h4>
              <p class="text-chinese-beige mb-6 text-sm">
                信息管理、用户管理、审核管理等管理员专属功能
              </p>
              <div class="space-y-3">
                <button v-if="!user.id" @click="$router.push('/login')" class="btn-white w-full">
                  登录使用
                </button>
                <button v-else-if="user.role === 'ADMIN'" @click="goToAdmin" class="btn-white w-full">
                  进入管理后台
                </button>
                <button v-else @click="showAdminTip" class="btn-white-outline w-full">
                  需要管理员权限
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- 快速导航 -->
        <div class="mt-12 text-center">
          <div class="inline-flex items-center space-x-4 bg-white bg-opacity-10 rounded-full px-6 py-3">
            <span class="text-chinese-beige text-sm">快速导航：</span>
            <router-link to="/map" class="text-white hover:text-chinese-beige transition-colors text-sm">扶贫地图</router-link>
            <span class="text-chinese-beige">|</span>
            <router-link to="/about" class="text-white hover:text-chinese-beige transition-colors text-sm">助农计划</router-link>
            <span class="text-chinese-beige">|</span>
            <a href="#" @click="scrollToTop" class="text-white hover:text-chinese-beige transition-colors text-sm">返回顶部</a>
          </div>
        </div>
      </div>
    </section>

   
    
    <!-- 调试功能区域 -->
    <div v-if="$store.getters.isAuthenticated" style="position: fixed; bottom: 20px; left: 20px; z-index: 1000;">
      <el-button size="small" type="info" @click="testAllComponents">
        测试功能按钮
      </el-button>
      <el-button size="small" type="warning" @click="resetComponentStates">
        重置组件状态
      </el-button>
    </div>

    <!-- 页脚 -->
    <footer class="bg-chinese-dark text-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h5 class="font-bold mb-4">中国助农扶贫平台</h5>
            <p class="text-gray-300 text-sm">
              致力于连接优质农产品与消费者，助力乡村振兴发展。
            </p>
          </div>
          <div>
            <h5 class="font-bold mb-4">产品分类</h5>
            <ul class="space-y-2 text-sm">
              <li><a href="#" class="text-gray-300 hover:text-white">茶叶</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">水果</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">粮食</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">调料</a></li>
            </ul>
          </div>
          <div>
            <h5 class="font-bold mb-4">扶贫故事</h5>
            <ul class="space-y-2 text-sm">
              <li><a href="#" class="text-gray-300 hover:text-white">产业扶贫</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">教育扶贫</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">健康扶贫</a></li>
              <li><a href="#" class="text-gray-300 hover:text-white">电商扶贫</a></li>
            </ul>
          </div>
          <div>
            <h5 class="font-bold mb-4">联系我们</h5>
            <ul class="space-y-2 text-sm">
              <li class="text-gray-300">📞 400-000-0000</li>
              <li class="text-gray-300">📧 info@nongmin.gov.cn</li>
              <li class="text-gray-300">📍 北京市朝阳区</li>
            </ul>
          </div>
        </div>
        
        <div class="border-t border-gray-600 mt-8 pt-8 text-center text-sm text-gray-400">
          <p>&copy; 2024 中国助农扶贫平台. 版权所有.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import ProductModel from '@/components/ProductModel.vue'
import StatCard from '@/components/StatCard.vue'
import GlobalNav from '@/components/GlobalNav.vue'
import { products } from '@/data/products'
import { stories } from '@/data/stories'
import { dashboardData } from '@/data/dashboard'
import { ElMessage } from 'element-plus'

const router = useRouter()

// 响应式数据
const showMobileMenu = ref(false)
const currentModel = ref('tea')
const productsSection = ref(null)
const storiesSection = ref(null)
const user = ref({})

// 加载用户信息
const loadUser = () => {
  user.value = JSON.parse(localStorage.getItem('xm-user') || '{}')
}

// 3D模型配置
const models = ref([
  { name: 'tea', label: '茶叶' },
  { name: 'apple', label: '苹果' },
  { name: 'rice', label: '大米' }
])

// 计算属性
const featuredProducts = computed(() => {
  return products.slice(0, 8)
})

const featuredStories = computed(() => {
  return stories.slice(0, 6)
})

// 方法
const scrollToProducts = () => {
  productsSection.value?.scrollIntoView({ behavior: 'smooth' })
}

const scrollToStories = () => {
  storiesSection.value?.scrollIntoView({ behavior: 'smooth' })
}

const goToProduct = (id) => {
  router.push(`/product/${id}`)
}

const goToStory = (id) => {
  router.push(`/story/${id}`)
}

const getProductIcon = (category) => {
  const icons = {
    '茶叶': '🍵',
    '水果': '🍎',
    '粮食': '🌾',
    '干果': '🥜',
    '调料': '🧄',
    '肉类': '🥩',
    '酒类': '🍺',
    '食用油': '🫒'
  }
  return icons[category] || '🌾'
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

// 系统入口方法
const goToUserCenter = () => {
  router.push('/front/home')
}

const goToAdmin = () => {
  router.push('/manager/home')
}

const showUserTip = () => {
  ElMessage.warning('此功能需要用户身份登录')
}

const showAdminTip = () => {
  ElMessage.warning('此功能需要管理员身份登录')
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// 添加测试功能
const testAllComponents = () => {
  console.log('=== 功能按钮测试 ===')
  console.log('认证状态:', localStorage.getItem('isAuthenticated'))
  console.log('用户角色:', localStorage.getItem('userRole'))
  console.log('用户名:', localStorage.getItem('userName'))
  console.log('当前路由:', router.currentRoute.value.path)
  
  // 检查各个组件是否存在
  const topStatusBar = document.querySelector('.top-status-bar')
  const quickActionPanel = document.querySelector('.quick-action-panel')
  
  console.log('顶部状态栏存在:', !!topStatusBar)
  console.log('快速操作面板存在:', !!quickActionPanel)
  
  if (topStatusBar) {
    console.log('顶部状态栏可见:', topStatusBar.style.display !== 'none')
  }
  
  if (quickActionPanel) {
    console.log('快速操作面板可见:', quickActionPanel.style.display !== 'none')
  }
  
  ElMessage.success('功能测试完成，请查看控制台输出')
}

// 重置组件状态
const resetComponentStates = () => {
  localStorage.removeItem('topStatusBarHidden')
  localStorage.removeItem('quickGuideShown')
  ElMessage.success('组件状态已重置，刷新页面生效')
}

// 生命周期
onMounted(() => {
  // 加载用户信息
  loadUser()
  
  // 自动切换3D模型
  setInterval(() => {
    const currentIndex = models.value.findIndex(m => m.name === currentModel.value)
    const nextIndex = (currentIndex + 1) % models.value.length
    currentModel.value = models.value[nextIndex].name
  }, 5000)
})
</script>

<style scoped>
/* 动画延迟 */
.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 产品卡片悬停效果 */
.product-card:hover {
  transform: translateY(-8px) rotate(1deg);
}

/* 故事卡片悬停效果 */
.story-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* 系统入口卡片样式 */
.system-entry-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  padding: 2rem;
  transition: all 0.3s ease;
}

.system-entry-card:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

/* 白色按钮样式 */
.btn-white {
  background: white;
  color: #8b1a1a;
  border: 2px solid white;
  padding: 10px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
}

.btn-white:hover {
  background: transparent;
  color: white;
  transform: translateY(-2px);
}

.btn-white-outline {
  background: transparent;
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.5);
  padding: 10px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
}

.btn-white-outline:hover {
  background: white;
  color: #8b1a1a;
  border-color: white;
  transform: translateY(-2px);
}
</style> 