<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-light via-white to-secondary-light">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 加载状态 -->
    <div v-if="loading" class="flex justify-center items-center min-h-screen">
      <div class="animate-spin rounded-full h-32 w-32 border-b-2 border-primary"></div>
    </div>
    
    <!-- 产品详情 -->
    <div v-else-if="product" class="container mx-auto px-4 py-8">
      <!-- 面包屑导航 -->
      <nav class="flex items-center space-x-2 text-sm mb-8" data-aos="fade-down">
        <router-link to="/" class="text-gray-600 hover:text-primary transition-colors">首页</router-link>
        <span class="text-gray-400">/</span>
        <router-link to="/products" class="text-gray-600 hover:text-primary transition-colors">产品展厅</router-link>
        <span class="text-gray-400">/</span>
        <span class="text-primary font-medium">{{ product.name }}</span>
      </nav>

      <!-- 产品主要信息 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-12">
        <!-- 3D模型展示 -->
        <div class="space-y-6" data-aos="fade-right">
          <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <ProductModel :model-name="getModelName(product.category)" class="h-96" />
          </div>
          
          <!-- 产品图片 -->
          <div class="grid grid-cols-4 gap-4">
            <div v-for="(image, index) in product.images" :key="index" 
                 class="aspect-square bg-white rounded-lg shadow-md overflow-hidden cursor-pointer hover:scale-105 transition-transform">
              <img :src="image" :alt="product.name" class="w-full h-full object-cover">
            </div>
          </div>
        </div>

        <!-- 产品信息 -->
        <div class="space-y-6" data-aos="fade-left">
          <div>
            <h1 class="text-3xl font-bold text-gray-900 mb-4">{{ product.name }}</h1>
            <div class="flex items-center space-x-4 mb-4">
              <span class="bg-primary text-white px-3 py-1 rounded-full text-sm">{{ product.category }}</span>
              <span class="bg-secondary text-white px-3 py-1 rounded-full text-sm">{{ product.region }}</span>
            </div>
            <p class="text-gray-600 leading-relaxed">{{ product.description }}</p>
          </div>

          <!-- 价格信息 -->
          <div class="bg-gradient-to-r from-primary-light to-secondary-light rounded-xl p-6">
            <div class="flex items-center justify-between mb-4">
              <div>
                <span class="text-3xl font-bold text-primary">¥{{ product.price }}</span>
                <span v-if="product.originalPrice" class="text-lg text-gray-500 line-through ml-2">¥{{ product.originalPrice }}</span>
              </div>
              <div v-if="product.discount" class="bg-red-500 text-white px-3 py-1 rounded-full text-sm">
                {{ product.discount }}折
              </div>
            </div>
            
            <div class="grid grid-cols-2 gap-4 text-sm">
              <div>
                <span class="text-gray-600">库存：</span>
                <span class="font-medium">{{ product.stock }}件</span>
              </div>
              <div>
                <span class="text-gray-600">销量：</span>
                <span class="font-medium">{{ product.sales }}+</span>
              </div>
              <div>
                <span class="text-gray-600">评分：</span>
                <div class="flex items-center">
                  <div class="flex text-yellow-400">
                    <span v-for="i in 5" :key="i" :class="i <= product.rating ? 'text-yellow-400' : 'text-gray-300'">★</span>
                  </div>
                  <span class="ml-2 text-gray-600">({{ product.rating }})</span>
                </div>
              </div>
              <div>
                <span class="text-gray-600">产地：</span>
                <span class="font-medium">{{ product.origin }}</span>
              </div>
            </div>
          </div>

          <!-- 认证标识 -->
          <div v-if="product.certifications && product.certifications.length" class="space-y-3">
            <h3 class="text-lg font-semibold text-gray-900">产品认证</h3>
            <div class="flex flex-wrap gap-2">
              <span v-for="cert in product.certifications" :key="cert" 
                    class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">
                {{ cert }}
              </span>
            </div>
          </div>

          <!-- 购买按钮 -->
          <div class="flex space-x-4">
            <button class="flex-1 bg-primary text-white py-3 px-6 rounded-lg hover:bg-primary-dark transition-colors font-medium">
              立即购买
            </button>
            <button class="flex-1 bg-gray-200 text-gray-800 py-3 px-6 rounded-lg hover:bg-gray-300 transition-colors font-medium">
              加入购物车
            </button>
          </div>
        </div>
      </div>

      <!-- 详细信息标签页 -->
      <div class="bg-white rounded-xl shadow-lg overflow-hidden" data-aos="fade-up">
        <div class="border-b border-gray-200">
          <nav class="flex space-x-8 px-6">
            <button v-for="tab in tabs" :key="tab.key"
                    :class="['py-4 border-b-2 font-medium text-sm transition-colors',
                             activeTab === tab.key 
                               ? 'border-primary text-primary' 
                               : 'border-transparent text-gray-500 hover:text-gray-700']"
                    @click="activeTab = tab.key">
              {{ tab.label }}
            </button>
          </nav>
        </div>

        <div class="p-6">
          <!-- 农户故事 -->
          <div v-if="activeTab === 'story'" class="space-y-6">
            <div class="flex items-center space-x-4 mb-6">
              <div class="w-16 h-16 bg-gray-300 rounded-full"></div>
              <div>
                <h3 class="text-xl font-semibold text-gray-900">{{ product.farmer }}</h3>
                <p class="text-gray-600">种植农户</p>
              </div>
            </div>
            <div class="prose max-w-none">
              <p class="text-gray-700 leading-relaxed">{{ product.story }}</p>
            </div>
          </div>

          <!-- 产品详情 -->
          <div v-if="activeTab === 'details'" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">基本信息</h3>
                <dl class="space-y-3">
                  <div class="flex justify-between">
                    <dt class="text-gray-600">产品名称：</dt>
                    <dd class="font-medium">{{ product.name }}</dd>
                  </div>
                  <div class="flex justify-between">
                    <dt class="text-gray-600">产品类别：</dt>
                    <dd class="font-medium">{{ product.category }}</dd>
                  </div>
                  <div class="flex justify-between">
                    <dt class="text-gray-600">产地：</dt>
                    <dd class="font-medium">{{ product.origin }}</dd>
                  </div>
                  <div class="flex justify-between">
                    <dt class="text-gray-600">种植农户：</dt>
                    <dd class="font-medium">{{ product.farmer }}</dd>
                  </div>
                </dl>
              </div>
              
              <div v-if="product.benefits">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">营养价值</h3>
                <ul class="space-y-2">
                  <li v-for="benefit in product.benefits" :key="benefit" 
                      class="flex items-center text-gray-700">
                    <span class="w-2 h-2 bg-green-500 rounded-full mr-3"></span>
                    {{ benefit }}
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- 评价 -->
          <div v-if="activeTab === 'reviews'" class="space-y-6">
            <div class="text-center py-12">
              <div class="text-gray-400 text-lg mb-4">暂无评价</div>
              <p class="text-gray-500">成为第一个评价此产品的用户</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 相关产品推荐 -->
      <div class="mt-12" data-aos="fade-up">
        <h2 class="text-2xl font-bold text-gray-900 mb-8">相关产品推荐</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="relatedProduct in relatedProducts" :key="relatedProduct.id" 
               class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow cursor-pointer"
               @click="$router.push(`/product/${relatedProduct.id}`)">
            <div class="aspect-square bg-gray-100"></div>
            <div class="p-4">
              <h3 class="font-semibold text-gray-900 mb-2">{{ relatedProduct.name }}</h3>
              <p class="text-primary font-bold">¥{{ relatedProduct.price }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 产品未找到 -->
    <div v-else class="flex flex-col items-center justify-center min-h-screen">
      <div class="text-6xl mb-4">🔍</div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">产品未找到</h2>
      <p class="text-gray-600 mb-8">您访问的产品可能已下架或不存在</p>
      <router-link to="/products" 
                   class="bg-primary text-white px-6 py-3 rounded-lg hover:bg-primary-dark transition-colors">
        返回产品列表
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { products } from '@/data/products'
import ProductModel from '@/components/ProductModel.vue'
import GlobalNav from '@/components/GlobalNav.vue'
import AOS from 'aos'

const route = useRoute()
const loading = ref(true)
const activeTab = ref('story')

// 标签页配置
const tabs = [
  { key: 'story', label: '农户故事' },
  { key: 'details', label: '产品详情' },
  { key: 'reviews', label: '用户评价' }
]

// 当前产品
const product = ref(null)

// 相关产品
const relatedProducts = computed(() => {
  if (!product.value) return []
  return products
    .filter(p => p.id !== product.value.id && p.category === product.value.category)
    .slice(0, 4)
})

// 获取3D模型名称
const getModelName = (category) => {
  const modelMap = {
    '茶叶': 'tea',
    '水果': 'apple',
    '粮食': 'rice',
    '粮食玉米': 'corn',
    '蔬菜': 'potato',
    '葡萄': 'grape',
    '新疆葡萄': 'grape',
    '菌菇': 'mushroom',
    '蜂产品': 'honey',
    '水产': 'fish',
    '野生鱼类': 'fish'
  }
  
  // 根据产品名称进行更精确的匹配
  if (product.value?.name) {
    const name = product.value.name
    if (name.includes('玉米') || name.includes('甜玉米')) return 'corn'
    if (name.includes('马铃薯') || name.includes('土豆')) return 'potato'
    if (name.includes('葡萄')) return 'grape'
    if (name.includes('菌') || name.includes('蘑菇')) return 'mushroom'
    if (name.includes('蜂蜜') || name.includes('蜂')) return 'honey'
    if (name.includes('鱼') || name.includes('水产')) return 'fish'
    if (name.includes('苹果')) return 'apple'
    if (name.includes('茶') || name.includes('茶叶')) return 'tea'
    if (name.includes('米') || name.includes('大米')) return 'rice'
  }
  
  return modelMap[category] || 'default'
}

// 加载产品数据
const loadProduct = async () => {
  try {
    loading.value = true
    const productId = parseInt(route.params.id)
    product.value = products.find(p => p.id === productId)
    
    // 模拟加载时间
    await new Promise(resolve => setTimeout(resolve, 500))
  } catch (error) {
    console.error('加载产品失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadProduct()
  AOS.init({
    duration: 800,
    once: true
  })
})
</script>

<style scoped>
.prose {
  line-height: 1.8;
}
</style> 