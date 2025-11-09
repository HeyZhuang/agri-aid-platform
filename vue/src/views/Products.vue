<template>
  <div class="min-h-screen bg-chinese-light-gradient">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 页面头部 -->
    <div class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-chinese-dark mb-4">农产品展厅</h1>
          <p class="text-lg text-gray-600">精选全国各地优质农产品，助力乡村振兴</p>
        </div>
      </div>
    </div>

    <!-- 筛选和搜索 -->
    <div class="bg-white border-b">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
          <!-- 搜索框 -->
          <div class="md:col-span-2">
            <div class="relative">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="搜索农产品..."
                class="input-chinese pl-10"
              />
              <div class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                🔍
              </div>
            </div>
          </div>
          
          <!-- 分类筛选 -->
          <div>
            <select v-model="selectedCategory" class="input-chinese">
              <option value="">所有分类</option>
              <option v-for="category in categories" :key="category" :value="category">
                {{ category }}
              </option>
            </select>
          </div>
          
          <!-- 地区筛选 -->
          <div>
            <select v-model="selectedRegion" class="input-chinese">
              <option value="">所有地区</option>
              <option v-for="region in regions" :key="region" :value="region">
                {{ region }}
              </option>
            </select>
          </div>
        </div>
        
        <!-- 排序和统计 -->
        <div class="flex justify-between items-center mt-4">
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">共 {{ filteredProducts.length }} 个产品</span>
            <div class="flex space-x-2">
              <button
                v-for="tag in popularTags"
                :key="tag"
                @click="toggleTag(tag)"
                class="px-3 py-1 text-sm rounded-full transition-all duration-200"
                :class="selectedTags.includes(tag) 
                  ? 'bg-chinese-red text-white' 
                  : 'bg-gray-100 text-gray-700 hover:bg-chinese-beige'"
              >
                {{ tag }}
              </button>
            </div>
          </div>
          
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">排序:</span>
            <select v-model="sortBy" class="text-sm border rounded px-2 py-1">
              <option value="default">默认</option>
              <option value="price_asc">价格由低到高</option>
              <option value="price_desc">价格由高到低</option>
              <option value="rating">评分最高</option>
              <option value="sales">销量最高</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- 产品网格 -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
        <div
          v-for="product in paginatedProducts"
          :key="product.id"
          class="product-card p-6 group cursor-pointer"
          @click="goToProduct(product.id)"
          data-aos="fade-up"
        >
          <!-- 产品图片 -->
          <div class="relative mb-4">
            <div class="w-full h-48 bg-gradient-to-br from-chinese-beige to-chinese-light rounded-lg flex items-center justify-center overflow-hidden">
              <span class="text-5xl group-hover:animate-bounce">{{ getProductIcon(product.category) }}</span>
            </div>
            
            <!-- 标签 -->
            <div class="absolute top-2 left-2 flex flex-col space-y-1">
              <span class="bg-chinese-red text-white px-2 py-1 rounded-full text-xs">
                {{ Math.round(product.discount * 100) }}折
              </span>
              <span 
                v-if="product.tags.includes('扶贫产品')"
                class="bg-chinese-green text-white px-2 py-1 rounded-full text-xs"
              >
                扶贫
              </span>
            </div>
            
            <!-- 地区标识 -->
            <div class="absolute top-2 right-2 bg-white bg-opacity-90 px-2 py-1 rounded text-xs text-chinese-dark">
              {{ product.region }}
            </div>
          </div>
          
          <!-- 产品信息 -->
          <div>
            <h3 class="font-bold text-chinese-dark mb-2 group-hover:text-chinese-red transition-colors">
              {{ product.name }}
            </h3>
            <p class="text-sm text-gray-600 mb-1">{{ product.origin }}</p>
            <p class="text-sm text-gray-600 mb-2">{{ product.farmer }}</p>
            <p class="text-sm text-gray-500 mb-3 text-ellipsis-2">{{ product.story }}</p>
            
            <!-- 标签 -->
            <div class="flex flex-wrap gap-1 mb-3">
              <span
                v-for="tag in product.tags.slice(0, 2)"
                :key="tag"
                class="bg-chinese-beige text-chinese-dark text-xs px-2 py-1 rounded"
              >
                {{ tag }}
              </span>
            </div>
            
            <!-- 价格和评分 -->
            <div class="flex items-center justify-between mb-2">
              <div class="flex items-center space-x-2">
                <span class="text-lg font-bold text-chinese-red">¥{{ product.price }}</span>
                <span class="text-sm text-gray-400 line-through">¥{{ product.originalPrice }}</span>
              </div>
              <div class="flex items-center space-x-1 text-sm">
                <span>⭐</span>
                <span class="text-gray-600">{{ product.rating }}</span>
              </div>
            </div>
            
            <!-- 销量和库存 -->
            <div class="flex items-center justify-between text-xs text-gray-500">
              <span>已售 {{ product.sales }}</span>
              <span>库存 {{ product.stock }}</span>
            </div>
            
            <!-- 扶贫效益 -->
            <div class="mt-2 p-2 bg-chinese-green bg-opacity-10 rounded text-xs text-chinese-green">
              {{ product.benefits }}
            </div>
          </div>
        </div>
      </div>
      
      <!-- 分页 -->
      <div v-if="totalPages > 1" class="flex justify-center mt-12">
        <div class="flex space-x-2">
          <button
            @click="currentPage = Math.max(1, currentPage - 1)"
            :disabled="currentPage === 1"
            class="px-4 py-2 border rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-chinese-beige transition-colors"
          >
            上一页
          </button>
          
          <button
            v-for="page in visiblePages"
            :key="page"
            @click="currentPage = page"
            class="px-4 py-2 border rounded-lg transition-colors"
            :class="currentPage === page 
              ? 'bg-chinese-red text-white border-chinese-red' 
              : 'hover:bg-chinese-beige'"
          >
            {{ page }}
          </button>
          
          <button
            @click="currentPage = Math.min(totalPages, currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="px-4 py-2 border rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-chinese-beige transition-colors"
          >
            下一页
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { products } from '@/data/products'
import AOS from 'aos'
import GlobalNav from '@/components/GlobalNav.vue'

const router = useRouter()

// 响应式数据
const searchQuery = ref('')
const selectedCategory = ref('')
const selectedRegion = ref('')
const selectedTags = ref([])
const sortBy = ref('default')
const currentPage = ref(1)
const itemsPerPage = 12

// 计算属性
const categories = computed(() => {
  return [...new Set(products.map(p => p.category))]
})

const regions = computed(() => {
  return [...new Set(products.map(p => p.region))]
})

const popularTags = computed(() => {
  const allTags = products.flatMap(p => p.tags)
  const tagCounts = {}
  allTags.forEach(tag => {
    tagCounts[tag] = (tagCounts[tag] || 0) + 1
  })
  return Object.entries(tagCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 6)
    .map(([tag]) => tag)
})

const filteredProducts = computed(() => {
  let filtered = products.filter(product => {
    const matchesSearch = product.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         product.origin.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         product.farmer.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    const matchesCategory = !selectedCategory.value || product.category === selectedCategory.value
    const matchesRegion = !selectedRegion.value || product.region === selectedRegion.value
    const matchesTags = selectedTags.value.length === 0 || 
                       selectedTags.value.some(tag => product.tags.includes(tag))
    
    return matchesSearch && matchesCategory && matchesRegion && matchesTags
  })
  
  // 排序
  switch (sortBy.value) {
    case 'price_asc':
      filtered.sort((a, b) => a.price - b.price)
      break
    case 'price_desc':
      filtered.sort((a, b) => b.price - a.price)
      break
    case 'rating':
      filtered.sort((a, b) => b.rating - a.rating)
      break
    case 'sales':
      filtered.sort((a, b) => b.sales - a.sales)
      break
    default:
      // 保持原始顺序
      break
  }
  
  return filtered
})

const totalPages = computed(() => {
  return Math.ceil(filteredProducts.value.length / itemsPerPage)
})

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredProducts.value.slice(start, end)
})

const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let end = Math.min(totalPages.value, start + maxVisible - 1)
  
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  
  return pages
})

// 方法
const toggleTag = (tag) => {
  const index = selectedTags.value.indexOf(tag)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    selectedTags.value.push(tag)
  }
}

const goToProduct = (id) => {
  router.push(`/product/${id}`)
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

// 监听筛选条件变化，重置页码
watch([searchQuery, selectedCategory, selectedRegion, selectedTags, sortBy], () => {
  currentPage.value = 1
})

// 生命周期
onMounted(() => {
  AOS.init({
    duration: 600,
    offset: 100,
    once: true
  })
})
</script>

<style scoped>
.product-card {
  transition: all 0.3s ease;
}

.product-card:hover {
  transform: translateY(-8px) rotate(1deg);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}
</style> 