<template>
  <div class="min-h-screen bg-chinese-light-gradient">
    <!-- 全局导航栏 -->
    <GlobalNav />
    
    <!-- 英雄区域 -->
    <section class="relative overflow-hidden py-20 bg-gradient-to-br from-chinese-red to-chinese-gold">
      <div class="absolute inset-0 bg-black opacity-20"></div>
      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-white">
        <h1 class="text-5xl font-bold mb-6 animate-fade-in-up">助农计划</h1>
        <p class="text-xl mb-8 animate-fade-in-up" style="animation-delay: 0.2s">
          携手共建美好乡村，让每一份努力都开花结果
        </p>
        <div class="animate-fade-in-up" style="animation-delay: 0.4s">
          <button class="bg-white text-chinese-red px-8 py-3 rounded-lg font-bold hover:bg-chinese-beige transition-all duration-300 transform hover:scale-105">
            了解更多
          </button>
        </div>
      </div>
    </section>

    <!-- 使命愿景 -->
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-chinese-dark mb-4">使命与愿景</h2>
          <p class="text-gray-600 text-lg">致力于乡村振兴，构建农产品产销一体化平台</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center p-8 rounded-xl bg-chinese-light-gradient hover:shadow-xl transition-all duration-300 animate-fade-in-up">
            <div class="text-6xl mb-4">🎯</div>
            <h3 class="text-xl font-bold text-chinese-dark mb-4">我们的使命</h3>
            <p class="text-gray-700">
              通过数字化平台连接农民与消费者，提升农产品价值，助力农民增收致富，巩固脱贫攻坚成果。
            </p>
          </div>
          
          <div class="text-center p-8 rounded-xl bg-chinese-light-gradient hover:shadow-xl transition-all duration-300 animate-fade-in-up" style="animation-delay: 0.2s">
            <div class="text-6xl mb-4">🌟</div>
            <h3 class="text-xl font-bold text-chinese-dark mb-4">我们的愿景</h3>
            <p class="text-gray-700">
              成为中国领先的农产品电商平台，让优质农产品走向全国，让农民生活更美好。
            </p>
          </div>
          
          <div class="text-center p-8 rounded-xl bg-chinese-light-gradient hover:shadow-xl transition-all duration-300 animate-fade-in-up" style="animation-delay: 0.4s">
            <div class="text-6xl mb-4">💡</div>
            <h3 class="text-xl font-bold text-chinese-dark mb-4">我们的价值观</h3>
            <p class="text-gray-700">
              诚信经营、品质第一、服务至上、共同发展，与农民朋友携手共创美好未来。
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- 平台优势 -->
    <section class="py-16 bg-chinese-light-gradient">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-chinese-dark mb-4">平台优势</h2>
          <p class="text-gray-600 text-lg">多重保障，确保农产品品质与服务</p>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div class="space-y-8">
            <div class="flex items-start space-x-4 animate-fade-in-left">
              <div class="flex-shrink-0 w-12 h-12 bg-chinese-red text-white rounded-lg flex items-center justify-center text-xl">
                ✅
              </div>
              <div>
                <h3 class="text-xl font-bold text-chinese-dark mb-2">品质保证</h3>
                <p class="text-gray-700">严格筛选优质农产品，确保每一件商品都经过专业检测，让消费者买得放心。</p>
              </div>
            </div>
            
            <div class="flex items-start space-x-4 animate-fade-in-left" style="animation-delay: 0.2s">
              <div class="flex-shrink-0 w-12 h-12 bg-chinese-green text-white rounded-lg flex items-center justify-center text-xl">
                🚚
              </div>
              <div>
                <h3 class="text-xl font-bold text-chinese-dark mb-2">物流保障</h3>
                <p class="text-gray-700">建立完善的冷链物流体系，确保农产品从田间到餐桌的新鲜度。</p>
              </div>
            </div>
            
            <div class="flex items-start space-x-4 animate-fade-in-left" style="animation-delay: 0.4s">
              <div class="flex-shrink-0 w-12 h-12 bg-chinese-gold text-white rounded-lg flex items-center justify-center text-xl">
                🤝
              </div>
              <div>
                <h3 class="text-xl font-bold text-chinese-dark mb-2">农民帮扶</h3>
                <p class="text-gray-700">提供技术指导、品牌包装、市场推广等全方位服务，助力农民增收。</p>
              </div>
            </div>
            
            <div class="flex items-start space-x-4 animate-fade-in-left" style="animation-delay: 0.6s">
              <div class="flex-shrink-0 w-12 h-12 bg-chinese-dark text-white rounded-lg flex items-center justify-center text-xl">
                💰
              </div>
              <div>
                <h3 class="text-xl font-bold text-chinese-dark mb-2">价格透明</h3>
                <p class="text-gray-700">去除中间环节，让农民获得更多收益，消费者享受更优价格。</p>
              </div>
            </div>
          </div>
          
          <div class="animate-fade-in-right">
            <div class="relative">
              <div class="w-full h-96 bg-gradient-to-br from-chinese-beige to-chinese-light rounded-xl shadow-2xl flex items-center justify-center">
                <div class="text-center">
                  <div class="text-8xl mb-4 animate-bounce">🌾</div>
                  <h3 class="text-2xl font-bold text-chinese-dark">连接农田与餐桌</h3>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 发展历程 -->
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-chinese-dark mb-4">发展历程</h2>
          <p class="text-gray-600 text-lg">见证平台成长，共享发展成果</p>
        </div>
        
        <div class="relative">
          <!-- 时间轴线 -->
          <div class="absolute left-1/2 transform -translate-x-1/2 w-1 h-full bg-chinese-red hidden md:block"></div>
          
          <div class="space-y-12">
            <!-- 2020年 -->
            <div class="relative flex items-center">
              <div class="absolute left-1/2 transform -translate-x-1/2 w-4 h-4 bg-chinese-red rounded-full border-4 border-white shadow-lg hidden md:block"></div>
              
              <div class="w-full md:w-5/12 md:pr-8 text-right animate-fade-in-left">
                <div class="bg-chinese-light-gradient p-6 rounded-xl shadow-lg">
                  <h3 class="text-xl font-bold text-chinese-dark mb-2">2020年</h3>
                  <h4 class="font-semibold text-chinese-red mb-2">平台启动</h4>
                  <p class="text-gray-700">响应国家脱贫攻坚号召，启动农产品电商平台建设项目。</p>
                </div>
              </div>
              
              <div class="hidden md:block w-2/12"></div>
              <div class="hidden md:block w-5/12"></div>
            </div>
            
            <!-- 2021年 -->
            <div class="relative flex items-center">
              <div class="absolute left-1/2 transform -translate-x-1/2 w-4 h-4 bg-chinese-red rounded-full border-4 border-white shadow-lg hidden md:block"></div>
              
              <div class="hidden md:block w-5/12"></div>
              <div class="hidden md:block w-2/12"></div>
              
              <div class="w-full md:w-5/12 md:pl-8 animate-fade-in-right">
                <div class="bg-chinese-light-gradient p-6 rounded-xl shadow-lg">
                  <h3 class="text-xl font-bold text-chinese-dark mb-2">2021年</h3>
                  <h4 class="font-semibold text-chinese-red mb-2">正式上线</h4>
                  <p class="text-gray-700">平台正式上线运营，首批合作农户超过1000家，覆盖10个省份。</p>
                </div>
              </div>
            </div>
            
            <!-- 2022年 -->
            <div class="relative flex items-center">
              <div class="absolute left-1/2 transform -translate-x-1/2 w-4 h-4 bg-chinese-red rounded-full border-4 border-white shadow-lg hidden md:block"></div>
              
              <div class="w-full md:w-5/12 md:pr-8 text-right animate-fade-in-left">
                <div class="bg-chinese-light-gradient p-6 rounded-xl shadow-lg">
                  <h3 class="text-xl font-bold text-chinese-dark mb-2">2022年</h3>
                  <h4 class="font-semibold text-chinese-red mb-2">快速发展</h4>
                  <p class="text-gray-700">用户突破100万，农产品销售额达到1亿元，帮助5000户农民增收。</p>
                </div>
              </div>
              
              <div class="hidden md:block w-2/12"></div>
              <div class="hidden md:block w-5/12"></div>
            </div>
            
            <!-- 2023年 -->
            <div class="relative flex items-center">
              <div class="absolute left-1/2 transform -translate-x-1/2 w-4 h-4 bg-chinese-red rounded-full border-4 border-white shadow-lg hidden md:block"></div>
              
              <div class="hidden md:block w-5/12"></div>
              <div class="hidden md:block w-2/12"></div>
              
              <div class="w-full md:w-5/12 md:pl-8 animate-fade-in-right">
                <div class="bg-chinese-light-gradient p-6 rounded-xl shadow-lg">
                  <h3 class="text-xl font-bold text-chinese-dark mb-2">2023年</h3>
                  <h4 class="font-semibold text-chinese-red mb-2">成果显著</h4>
                  <p class="text-gray-700">累计帮扶农户超过12000家，销售额突破2亿元，覆盖全国832个脱贫县。</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 联系我们 -->
    <section class="py-16 bg-chinese-dark text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold mb-4">加入我们</h2>
          <p class="text-gray-300 text-lg">一起为乡村振兴贡献力量</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center p-6 bg-white bg-opacity-10 rounded-xl backdrop-blur-sm animate-fade-in-up">
            <div class="text-4xl mb-4">📞</div>
            <h3 class="text-xl font-bold mb-2">联系电话</h3>
            <p class="text-gray-300">400-000-0000</p>
            <p class="text-gray-300">服务时间：9:00-18:00</p>
          </div>
          
          <div class="text-center p-6 bg-white bg-opacity-10 rounded-xl backdrop-blur-sm animate-fade-in-up" style="animation-delay: 0.2s">
            <div class="text-4xl mb-4">📧</div>
            <h3 class="text-xl font-bold mb-2">邮箱地址</h3>
            <p class="text-gray-300">info@nongmin.gov.cn</p>
            <p class="text-gray-300">support@nongmin.gov.cn</p>
          </div>
          
          <div class="text-center p-6 bg-white bg-opacity-10 rounded-xl backdrop-blur-sm animate-fade-in-up" style="animation-delay: 0.4s">
            <div class="text-4xl mb-4">📍</div>
            <h3 class="text-xl font-bold mb-2">公司地址</h3>
            <p class="text-gray-300">北京市朝阳区</p>
            <p class="text-gray-300">农业大厦18层</p>
          </div>
        </div>
        
        <div class="text-center mt-12">
          <p class="text-gray-300 mb-4">关注我们的社交媒体，获取最新动态</p>
          <div class="flex justify-center space-x-6">
            <div class="w-12 h-12 bg-white bg-opacity-20 rounded-full flex items-center justify-center hover:bg-opacity-30 transition-all duration-300 cursor-pointer">
              📱
            </div>
            <div class="w-12 h-12 bg-white bg-opacity-20 rounded-full flex items-center justify-center hover:bg-opacity-30 transition-all duration-300 cursor-pointer">
              💬
            </div>
            <div class="w-12 h-12 bg-white bg-opacity-20 rounded-full flex items-center justify-center hover:bg-opacity-30 transition-all duration-300 cursor-pointer">
              📺
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import AOS from 'aos'
import GlobalNav from '@/components/GlobalNav.vue'

// 生命周期
onMounted(() => {
  AOS.init({
    duration: 800,
    offset: 100,
    once: true
  })
  
  // 设置页面标题
  document.title = '助农计划 - 中国助农扶贫平台'
})
</script>

<style scoped>
/* 动画效果 */
.animate-fade-in-up {
  animation: fadeInUp 0.8s ease-out both;
}

.animate-fade-in-left {
  animation: fadeInLeft 0.8s ease-out both;
}

.animate-fade-in-right {
  animation: fadeInRight 0.8s ease-out both;
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

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* 时间轴悬停效果 */
.timeline-item:hover {
  transform: scale(1.02);
}

/* 玻璃拟态效果 */
.backdrop-blur-sm {
  backdrop-filter: blur(4px);
}
</style> 