<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-light via-white to-secondary-light">
    <!-- 加载状态 -->
    <div v-if="loading" class="flex justify-center items-center min-h-screen">
      <div class="animate-spin rounded-full h-32 w-32 border-b-2 border-primary"></div>
    </div>
    
    <!-- 故事详情 -->
    <div v-else-if="story" class="container mx-auto px-4 py-8">
      <!-- 面包屑导航 -->
      <nav class="flex items-center space-x-2 text-sm mb-8" data-aos="fade-down">
        <router-link to="/" class="text-gray-600 hover:text-primary transition-colors">首页</router-link>
        <span class="text-gray-400">/</span>
        <router-link to="/stories" class="text-gray-600 hover:text-primary transition-colors">扶贫故事</router-link>
        <span class="text-gray-400">/</span>
        <span class="text-primary font-medium">{{ story.title }}</span>
      </nav>

      <!-- 故事头部 -->
      <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8" data-aos="fade-up">
        <div class="relative h-64 md:h-96">
          <img v-if="story.images && story.images.length" 
               :src="story.images[0]" 
               :alt="story.title" 
               class="w-full h-full object-cover">
          <div v-else class="w-full h-full bg-gradient-to-r from-primary to-secondary flex items-center justify-center">
            <div class="text-white text-6xl">📖</div>
          </div>
          <div class="absolute inset-0 bg-black bg-opacity-40 flex items-end">
            <div class="p-8 text-white">
              <div class="flex items-center space-x-4 mb-4">
                <span class="bg-white bg-opacity-20 px-3 py-1 rounded-full text-sm">{{ story.category }}</span>
                <span class="bg-white bg-opacity-20 px-3 py-1 rounded-full text-sm">{{ story.location }}</span>
              </div>
              <h1 class="text-3xl md:text-4xl font-bold mb-2">{{ story.title }}</h1>
              <p class="text-lg opacity-90">{{ formatDate(story.date) }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 主要内容 -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- 故事内容 -->
        <div class="lg:col-span-2 space-y-8">
          <!-- 故事摘要 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right">
            <h2 class="text-xl font-bold text-gray-900 mb-4">故事摘要</h2>
            <p class="text-gray-700 leading-relaxed">{{ story.summary || story.content.substring(0, 200) + '...' }}</p>
          </div>

          <!-- 主人公信息 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right" data-aos-delay="100">
            <h2 class="text-xl font-bold text-gray-900 mb-4">主人公</h2>
            <div class="flex items-center space-x-4">
              <div class="w-16 h-16 bg-gray-300 rounded-full flex items-center justify-center">
                <span class="text-2xl">👤</span>
              </div>
              <div>
                <h3 class="text-lg font-semibold text-gray-900">{{ story.protagonist }}</h3>
                <p class="text-gray-600">{{ story.location }}</p>
              </div>
            </div>
          </div>

          <!-- 故事正文 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right" data-aos-delay="200">
            <h2 class="text-xl font-bold text-gray-900 mb-6">详细内容</h2>
            <div class="prose max-w-none">
              <div class="text-gray-700 leading-relaxed whitespace-pre-line">{{ story.content }}</div>
            </div>
          </div>

          <!-- 前后对比 -->
          <div v-if="story.beforeAfter" class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right" data-aos-delay="300">
            <h2 class="text-xl font-bold text-gray-900 mb-6">前后对比</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="text-center">
                <h3 class="text-lg font-semibold text-red-600 mb-4">扶贫前</h3>
                <div class="bg-red-50 rounded-lg p-4">
                  <ul class="space-y-2 text-sm">
                    <li v-for="item in story.beforeAfter.before" :key="item" 
                        class="flex items-center text-red-700">
                      <span class="w-2 h-2 bg-red-500 rounded-full mr-3"></span>
                      {{ item }}
                    </li>
                  </ul>
                </div>
              </div>
              <div class="text-center">
                <h3 class="text-lg font-semibold text-green-600 mb-4">扶贫后</h3>
                <div class="bg-green-50 rounded-lg p-4">
                  <ul class="space-y-2 text-sm">
                    <li v-for="item in story.beforeAfter.after" :key="item" 
                        class="flex items-center text-green-700">
                      <span class="w-2 h-2 bg-green-500 rounded-full mr-3"></span>
                      {{ item }}
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- 关键措施 -->
          <div v-if="story.keyMeasures && story.keyMeasures.length" 
               class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right" data-aos-delay="400">
            <h2 class="text-xl font-bold text-gray-900 mb-6">关键措施</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div v-for="(measure, index) in story.keyMeasures" :key="index" 
                   class="bg-primary-light rounded-lg p-4">
                <div class="flex items-center space-x-3">
                  <div class="w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center text-sm font-bold">
                    {{ index + 1 }}
                  </div>
                  <span class="text-gray-800 font-medium">{{ measure }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 图片展示 -->
          <div v-if="story.images && story.images.length > 1" 
               class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-right" data-aos-delay="500">
            <h2 class="text-xl font-bold text-gray-900 mb-6">相关图片</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <div v-for="(image, index) in story.images.slice(1)" :key="index" 
                   class="aspect-square rounded-lg overflow-hidden cursor-pointer hover:scale-105 transition-transform">
                <img :src="image" :alt="`${story.title} - 图片 ${index + 2}`" 
                     class="w-full h-full object-cover">
              </div>
            </div>
          </div>
        </div>

        <!-- 侧边栏 -->
        <div class="space-y-8">
          <!-- 扶贫成效 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-left">
            <h2 class="text-xl font-bold text-gray-900 mb-6">扶贫成效</h2>
            <div class="space-y-4">
              <div v-for="(metric, key) in story.impact" :key="key" 
                   class="flex justify-between items-center py-2 border-b border-gray-100 last:border-b-0">
                <span class="text-gray-600">{{ getMetricLabel(key) }}：</span>
                <span class="font-semibold text-primary">{{ metric }}</span>
              </div>
            </div>
          </div>

          <!-- 故事标签 -->
          <div v-if="story.tags && story.tags.length" 
               class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-left" data-aos-delay="100">
            <h2 class="text-xl font-bold text-gray-900 mb-4">相关标签</h2>
            <div class="flex flex-wrap gap-2">
              <span v-for="tag in story.tags" :key="tag" 
                    class="bg-primary-light text-primary px-3 py-1 rounded-full text-sm">
                {{ tag }}
              </span>
            </div>
          </div>

          <!-- 分享功能 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-left" data-aos-delay="200">
            <h2 class="text-xl font-bold text-gray-900 mb-4">分享故事</h2>
            <div class="flex space-x-3">
              <button class="flex-1 bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 transition-colors text-sm">
                微信
              </button>
              <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg hover:bg-green-600 transition-colors text-sm">
                微博
              </button>
              <button class="flex-1 bg-gray-500 text-white py-2 px-4 rounded-lg hover:bg-gray-600 transition-colors text-sm">
                复制
              </button>
            </div>
          </div>

          <!-- 相关故事 -->
          <div class="bg-white rounded-xl shadow-lg p-6" data-aos="fade-left" data-aos-delay="300">
            <h2 class="text-xl font-bold text-gray-900 mb-4">相关故事</h2>
            <div class="space-y-4">
              <div v-for="relatedStory in relatedStories" :key="relatedStory.id" 
                   class="cursor-pointer hover:bg-gray-50 p-3 rounded-lg transition-colors"
                   @click="$router.push(`/story/${relatedStory.id}`)">
                <h3 class="font-medium text-gray-900 mb-1 text-sm line-clamp-2">{{ relatedStory.title }}</h3>
                <p class="text-xs text-gray-500">{{ relatedStory.location }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 故事未找到 -->
    <div v-else class="flex flex-col items-center justify-center min-h-screen">
      <div class="text-6xl mb-4">📖</div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">故事未找到</h2>
      <p class="text-gray-600 mb-8">您访问的故事可能不存在或已被移除</p>
      <router-link to="/stories" 
                   class="bg-primary text-white px-6 py-3 rounded-lg hover:bg-primary-dark transition-colors">
        返回故事列表
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { stories } from '@/data/stories'
import AOS from 'aos'

const route = useRoute()
const loading = ref(true)

// 当前故事
const story = ref(null)

// 相关故事
const relatedStories = computed(() => {
  if (!story.value) return []
  return stories
    .filter(s => s.id !== story.value.id && s.category === story.value.category)
    .slice(0, 5)
})

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// 获取指标标签
const getMetricLabel = (key) => {
  const labels = {
    householdsBenefited: '受益户数',
    incomeBefore: '扶贫前收入',
    incomeAfter: '扶贫后收入',
    jobsCreated: '创造就业',
    investmentAmount: '投资金额',
    peopleHelped: '帮扶人数',
    incomeIncrease: '收入增长',
    projectCount: '项目数量'
  }
  return labels[key] || key
}

// 加载故事数据
const loadStory = async () => {
  try {
    loading.value = true
    const storyId = parseInt(route.params.id)
    story.value = stories.find(s => s.id === storyId)
    
    // 模拟加载时间
    await new Promise(resolve => setTimeout(resolve, 500))
  } catch (error) {
    console.error('加载故事失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadStory()
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

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 