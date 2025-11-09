<template>
  <div id="app">
    <!-- 顶部状态栏 - 显示当前用户状态和快速操作 -->
    <TopStatusBar />
    
    <router-view/>
    
    <!-- 快速操作面板 - 悬浮在页面右侧 -->
    <QuickActionPanel />
    
    <!-- 键盘快捷键支持 -->
    <KeyboardShortcuts />
    
    <!-- 快速使用指南 -->
    <QuickGuide ref="quickGuide" />
  </div>
</template>

<script>
import QuickActionPanel from '@/components/QuickActionPanel.vue'
import TopStatusBar from '@/components/TopStatusBar.vue'
import KeyboardShortcuts from '@/components/KeyboardShortcuts.vue'
import QuickGuide from '@/components/QuickGuide.vue'

export default {
  name: 'App',
  components: {
    QuickActionPanel,
    TopStatusBar,
    KeyboardShortcuts,
    QuickGuide
  },
  
  methods: {
    // 提供一个全局方法来显示使用指南
    showQuickGuide() {
      this.$refs.quickGuide.show()
    }
  }
}
</script>

<style>
#app {
  position: relative;
  min-height: 100vh;
}

/* 为顶部状态栏预留空间 */
body {
  margin: 0;
  padding: 0;
}

/* 确保页面内容不被顶部状态栏遮挡 */
.router-view-wrapper {
  margin-top: 40px;
}
</style>
