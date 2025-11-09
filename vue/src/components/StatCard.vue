<template>
  <div 
    class="relative bg-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 p-6 overflow-hidden"
    :class="cardClasses"
  >
    <!-- 背景装饰 -->
    <div class="absolute top-0 right-0 w-32 h-32 transform translate-x-16 -translate-y-16 opacity-10">
      <div class="w-full h-full bg-gradient-to-br from-chinese-red to-chinese-gold rounded-full"></div>
    </div>
    
    <!-- 主要内容 -->
    <div class="relative z-10">
      <!-- 图标和趋势 -->
      <div class="flex items-center justify-between mb-4">
        <div class="flex items-center space-x-3">
          <div 
            class="w-12 h-12 rounded-lg flex items-center justify-center text-2xl"
            :class="iconClasses"
          >
            {{ icon }}
          </div>
          <div v-if="trend" class="flex items-center space-x-1">
            <span 
              class="text-sm font-medium"
              :class="trendClasses"
            >
              {{ trend }}
            </span>
            <div 
              class="w-0 h-0 border-l-4 border-r-4 border-transparent"
              :class="trendArrowClasses"
            ></div>
          </div>
        </div>
        
        <!-- 更多操作按钮 -->
        <button 
          v-if="showMore"
          @click="$emit('more-click')"
          class="text-gray-400 hover:text-gray-600 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"></path>
          </svg>
        </button>
      </div>
      
      <!-- 数值显示 -->
      <div class="mb-2">
        <div class="text-3xl font-bold text-chinese-dark mb-1">
          <span v-if="animated" ref="countRef">{{ animatedValue }}</span>
          <span v-else>{{ formattedValue }}</span>
          <span v-if="unit" class="text-lg font-normal text-gray-500 ml-1">{{ unit }}</span>
        </div>
        <h3 class="text-sm font-medium text-gray-600 font-chinese">{{ label }}</h3>
      </div>
      
      <!-- 描述信息 -->
      <div v-if="description" class="text-sm text-gray-500 font-chinese">
        {{ description }}
      </div>
      
      <!-- 进度条 -->
      <div v-if="showProgress" class="mt-4">
        <div class="flex justify-between text-sm text-gray-600 mb-1">
          <span>进度</span>
          <span>{{ progressPercentage }}%</span>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-2">
          <div 
            class="h-2 rounded-full transition-all duration-1000 ease-out"
            :class="progressClasses"
            :style="{ width: `${progressPercentage}%` }"
          ></div>
        </div>
      </div>
    </div>
    
    <!-- 点击效果 -->
    <div 
      v-if="clickable"
      class="absolute inset-0 bg-chinese-red opacity-0 hover:opacity-5 transition-opacity duration-300 rounded-xl"
    ></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'

// Props
const props = defineProps({
  icon: {
    type: String,
    required: true
  },
  value: {
    type: [Number, String],
    required: true
  },
  label: {
    type: String,
    required: true
  },
  unit: {
    type: String,
    default: ''
  },
  trend: {
    type: String,
    default: ''
  },
  color: {
    type: String,
    default: 'chinese-red',
    validator: (value) => [
      'chinese-red', 'chinese-green', 'chinese-gold', 'chinese-dark',
      'red', 'green', 'blue', 'purple', 'orange', 'gray'
    ].includes(value)
  },
  description: {
    type: String,
    default: ''
  },
  animated: {
    type: Boolean,
    default: true
  },
  clickable: {
    type: Boolean,
    default: false
  },
  showMore: {
    type: Boolean,
    default: false
  },
  showProgress: {
    type: Boolean,
    default: false
  },
  progressValue: {
    type: Number,
    default: 0
  },
  progressMax: {
    type: Number,
    default: 100
  }
})

// Emits
const emit = defineEmits(['click', 'more-click'])

// 响应式数据
const animatedValue = ref(0)
const countRef = ref(null)

// 计算属性
const formattedValue = computed(() => {
  if (typeof props.value === 'number') {
    if (props.value >= 1e8) {
      return (props.value / 1e8).toFixed(1) + '亿'
    } else if (props.value >= 1e4) {
      return (props.value / 1e4).toFixed(1) + '万'
    } else {
      return props.value.toLocaleString()
    }
  }
  return props.value
})

const cardClasses = computed(() => {
  const classes = []
  if (props.clickable) {
    classes.push('cursor-pointer')
  }
  return classes
})

const iconClasses = computed(() => {
  const colorMap = {
    'chinese-red': 'bg-chinese-red/10 text-chinese-red',
    'chinese-green': 'bg-chinese-green/10 text-chinese-green',
    'chinese-gold': 'bg-chinese-gold/10 text-chinese-gold',
    'chinese-dark': 'bg-chinese-dark/10 text-chinese-dark',
    'red': 'bg-red-100 text-red-600',
    'green': 'bg-green-100 text-green-600',
    'blue': 'bg-blue-100 text-blue-600',
    'purple': 'bg-purple-100 text-purple-600',
    'orange': 'bg-orange-100 text-orange-600',
    'gray': 'bg-gray-100 text-gray-600'
  }
  return colorMap[props.color] || colorMap['chinese-red']
})

const trendClasses = computed(() => {
  if (!props.trend) return ''
  
  const isPositive = props.trend.startsWith('+')
  const isNegative = props.trend.startsWith('-')
  
  if (isPositive) {
    return 'text-green-600'
  } else if (isNegative) {
    return 'text-red-600'
  }
  return 'text-gray-600'
})

const trendArrowClasses = computed(() => {
  if (!props.trend) return ''
  
  const isPositive = props.trend.startsWith('+')
  const isNegative = props.trend.startsWith('-')
  
  if (isPositive) {
    return 'border-b-4 border-green-600'
  } else if (isNegative) {
    return 'border-t-4 border-red-600'
  }
  return ''
})

const progressPercentage = computed(() => {
  if (props.progressMax === 0) return 0
  return Math.min(100, (props.progressValue / props.progressMax) * 100)
})

const progressClasses = computed(() => {
  const colorMap = {
    'chinese-red': 'bg-chinese-red',
    'chinese-green': 'bg-chinese-green',
    'chinese-gold': 'bg-chinese-gold',
    'chinese-dark': 'bg-chinese-dark',
    'red': 'bg-red-500',
    'green': 'bg-green-500',
    'blue': 'bg-blue-500',
    'purple': 'bg-purple-500',
    'orange': 'bg-orange-500',
    'gray': 'bg-gray-500'
  }
  return colorMap[props.color] || colorMap['chinese-red']
})

// 数字动画
const animateNumber = (target) => {
  const duration = 2000
  const startTime = Date.now()
  const startValue = animatedValue.value
  
  const animate = () => {
    const elapsed = Date.now() - startTime
    const progress = Math.min(elapsed / duration, 1)
    
    // 使用缓动函数
    const easeOutQuart = 1 - Math.pow(1 - progress, 4)
    
    animatedValue.value = Math.floor(startValue + (target - startValue) * easeOutQuart)
    
    if (progress < 1) {
      requestAnimationFrame(animate)
    } else {
      animatedValue.value = target
    }
  }
  
  requestAnimationFrame(animate)
}

// 监听value变化
watch(() => props.value, (newValue) => {
  if (props.animated && typeof newValue === 'number') {
    animateNumber(newValue)
  }
}, { immediate: true })

// 处理点击
const handleClick = () => {
  if (props.clickable) {
    emit('click')
  }
}

// 生命周期
onMounted(() => {
  if (props.animated && typeof props.value === 'number') {
    animateNumber(props.value)
  }
})
</script>

<style scoped>
.font-chinese {
  font-family: 'Source Han Sans CN', 'PingFang SC', 'Microsoft YaHei', sans-serif;
}
</style> 