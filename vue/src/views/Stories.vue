<template>
  <div class="min-h-screen bg-chinese-light-gradient">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 页面头部 -->
    <div class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-chinese-dark mb-4">扶贫故事</h1>
          <p class="text-lg text-gray-600">真实的脱贫故事，感人的奋斗历程</p>
        </div>
      </div>
    </div>

    <!-- 筛选和搜索 -->
    <div class="bg-white border-b">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <!-- 搜索框 -->
          <div>
            <div class="relative">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="搜索故事..."
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
            <select v-model="selectedLocation" class="input-chinese">
              <option value="">所有地区</option>
              <option v-for="location in locations" :key="location" :value="location">
                {{ location }}
              </option>
            </select>
          </div>
        </div>
        
        <!-- 统计信息 -->
        <div class="flex justify-between items-center mt-4">
          <div class="text-sm text-gray-600">共 {{ filteredStories.length }} 个故事</div>
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">排序:</span>
            <select v-model="sortBy" class="text-sm border rounded px-2 py-1">
              <option value="date_desc">最新发布</option>
              <option value="date_asc">最早发布</option>
              <option value="title">标题排序</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- 故事时间轴视图 -->
      <div v-if="viewMode === 'timeline'" class="relative">
        <!-- 时间轴线 -->
        <div class="absolute left-8 top-0 bottom-0 w-0.5 bg-chinese-red hidden md:block"></div>
        
        <div class="space-y-8">
          <div
            v-for="(story, index) in paginatedStories"
            :key="story.id"
            class="relative"
            data-aos="fade-up"
            :data-aos-delay="index * 100"
          >
            <!-- 时间点 -->
            <div class="absolute left-6 w-4 h-4 bg-chinese-red rounded-full border-4 border-white shadow-lg hidden md:block"></div>
            
            <!-- 故事卡片 -->
            <div 
              class="ml-0 md:ml-16 story-card p-6 cursor-pointer"
              @click="goToStory(story.id)"
            >
              <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <!-- 左侧内容 -->
                <div class="lg:col-span-3">
                  <div class="flex flex-wrap items-center gap-2 mb-3">
                    <span class="bg-chinese-green text-white px-3 py-1 rounded-full text-sm">
                      {{ story.category }}
                    </span>
                    <span class="text-sm text-gray-500">{{ story.location }}</span>
                    <span class="text-sm text-gray-400">{{ formatDate(story.date) }}</span>
                  </div>
                  
                  <h3 class="text-xl font-bold text-chinese-dark mb-3 hover:text-chinese-red transition-colors">
                    {{ story.title }}
                  </h3>
                  
                  <p class="text-gray-700 mb-4 text-ellipsis-3">{{ story.content }}</p>
                  
                  <!-- 关键措施 -->
                  <div class="mb-4">
                    <h4 class="font-medium text-chinese-dark mb-2">关键措施:</h4>
                    <div class="flex flex-wrap gap-2">
                      <span
                        v-for="measure in story.keyMeasures.slice(0, 3)"
                        :key="measure"
                        class="bg-chinese-beige text-chinese-dark text-sm px-3 py-1 rounded"
                      >
                        {{ measure }}
                      </span>
                    </div>
                  </div>
                </div>
                
                <!-- 右侧效果展示 -->
                <div class="bg-chinese-light-gradient p-4 rounded-lg">
                  <div class="text-center mb-3">
                    <div class="text-2xl mb-2">📈</div>
                    <div class="font-bold text-chinese-red text-lg">{{ story.impact }}</div>
                  </div>
                  
                  <div class="space-y-2 text-sm">
                    <div class="flex justify-between">
                      <span class="text-gray-600">扶贫前:</span>
                      <span class="text-gray-700">{{ story.before }}</span>
                    </div>
                    <div class="flex justify-between">
                      <span class="text-gray-600">扶贫后:</span>
                      <span class="text-chinese-green font-medium">{{ story.after }}</span>
                    </div>
                  </div>
                  
                  <div class="mt-3 pt-3 border-t text-center">
                    <span class="text-sm text-gray-600">主要负责人</span>
                    <div class="font-medium text-chinese-dark">{{ story.protagonist }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 网格视图 -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div
          v-for="story in paginatedStories"
          :key="story.id"
          class="story-card p-6 cursor-pointer"
          @click="goToStory(story.id)"
          data-aos="fade-up"
        >
          <div class="mb-4">
            <div class="flex items-center justify-between mb-2">
              <span class="bg-chinese-green text-white px-3 py-1 rounded-full text-sm">
                {{ story.category }}
              </span>
              <span class="text-sm text-gray-500">{{ formatDate(story.date) }}</span>
            </div>
            
            <h3 class="font-bold text-chinese-dark mb-2 hover:text-chinese-red transition-colors">
              {{ story.title }}
            </h3>
            <p class="text-sm text-gray-600 mb-2">{{ story.location }}</p>
          </div>
          
          <p class="text-gray-700 text-ellipsis-3 mb-4">{{ story.content }}</p>
          
          <!-- 成效对比 -->
          <div class="bg-chinese-light-gradient p-3 rounded-lg mb-4">
            <div class="text-sm space-y-1">
              <div class="text-gray-600">扶贫前: {{ story.before }}</div>
              <div class="text-chinese-green font-medium">扶贫后: {{ story.after }}</div>
            </div>
          </div>
          
          <div class="flex items-center justify-between text-sm">
            <span class="text-chinese-green font-medium">{{ story.impact }}</span>
            <span class="text-gray-500">负责人: {{ story.protagonist }}</span>
          </div>
        </div>
      </div>
      
      <!-- 视图切换 -->
      <div class="flex justify-center mt-8 mb-4">
        <div class="bg-white rounded-lg p-1 shadow-md">
          <button
            @click="viewMode = 'timeline'"
            class="px-4 py-2 rounded-md transition-all duration-200"
            :class="viewMode === 'timeline' ? 'bg-chinese-red text-white' : 'text-chinese-dark hover:bg-chinese-beige'"
          >
            时间轴视图
          </button>
          <button
            @click="viewMode = 'grid'"
            class="px-4 py-2 rounded-md transition-all duration-200"
            :class="viewMode === 'grid' ? 'bg-chinese-red text-white' : 'text-chinese-dark hover:bg-chinese-beige'"
          >
            网格视图
          </button>
        </div>
      </div>
      
      <!-- 分页 -->
      <div v-if="totalPages > 1" class="flex justify-center mt-8">
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
import { stories } from '@/data/stories'
import AOS from 'aos'
import GlobalNav from '@/components/GlobalNav.vue'

const router = useRouter()

// 响应式数据
const searchQuery = ref('')
const selectedCategory = ref('')
const selectedLocation = ref('')
const sortBy = ref('date_desc')
const currentPage = ref(1)
const itemsPerPage = 6
const viewMode = ref('timeline')

// 计算属性
const categories = computed(() => {
  return [...new Set(stories.map(s => s.category))]
})

const locations = computed(() => {
  return [...new Set(stories.map(s => s.location.split(' ')[0]))]
})

const filteredStories = computed(() => {
  let filtered = stories.filter(story => {
    const matchesSearch = story.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         story.content.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         story.location.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    const matchesCategory = !selectedCategory.value || story.category === selectedCategory.value
    const matchesLocation = !selectedLocation.value || story.location.includes(selectedLocation.value)
    
    return matchesSearch && matchesCategory && matchesLocation
  })
  
  // 排序
  switch (sortBy.value) {
    case 'date_asc':
      filtered.sort((a, b) => new Date(a.date) - new Date(b.date))
      break
    case 'date_desc':
      filtered.sort((a, b) => new Date(b.date) - new Date(a.date))
      break
    case 'title':
      filtered.sort((a, b) => a.title.localeCompare(b.title))
      break
  }
  
  return filtered
})

const totalPages = computed(() => {
  return Math.ceil(filteredStories.value.length / itemsPerPage)
})

const paginatedStories = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredStories.value.slice(start, end)
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
const goToStory = (id) => {
  router.push(`/story/${id}`)
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

// 监听筛选条件变化，重置页码
watch([searchQuery, selectedCategory, selectedLocation, sortBy], () => {
  currentPage.value = 1
})

// 生命周期
onMounted(() => {
  AOS.init({
    duration: 600,
    offset: 100,
    once: true
  })
  
  // 设置页面标题
  document.title = '扶贫故事 - 中国助农扶贫平台'
})
</script>

<style scoped>
.story-card {
  transition: all 0.3s ease;
}

.story-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* 时间轴样式 */
.timeline-item {
  position: relative;
}

.timeline-item::before {
  content: '';
  position: absolute;
  left: -0.5rem;
  top: 0;
  width: 1rem;
  height: 1rem;
  background-color: #c3272b;
  border-radius: 50%;
  border: 4px solid white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style> 