<template>
  <div></div>
</template>

<script>
import { mapGetters } from 'vuex'
import { authManager } from '@/utils/auth'

export default {
  name: 'KeyboardShortcuts',
  computed: {
    ...mapGetters(['isAuthenticated', 'isAdmin', 'isUser'])
  },
  
  mounted() {
    document.addEventListener('keydown', this.handleKeyDown)
  },
  
  beforeUnmount() {
    document.removeEventListener('keydown', this.handleKeyDown)
  },
  
  methods: {
    handleKeyDown(event) {
      if (!this.isAuthenticated) return
      
      // Ctrl/Cmd + Shift + Q: 快速退出登录
      if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key === 'Q') {
        event.preventDefault()
        this.quickLogout()
      }
      
      // Ctrl/Cmd + Shift + H: 切换到主页
      if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key === 'H') {
        event.preventDefault()
        authManager.switchToHome()
        this.showShortcutTip('已切换到展示主页')
      }
      
      // Ctrl/Cmd + Shift + M: 切换到管理后台 (仅管理员)
      if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key === 'M' && this.isAdmin) {
        event.preventDefault()
        authManager.switchToAdmin()
        this.showShortcutTip('已切换到管理后台')
      }
      
      // Ctrl/Cmd + Shift + U: 切换到用户中心 (仅用户)
      if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key === 'U' && this.isUser) {
        event.preventDefault()
        authManager.switchToUser()
        this.showShortcutTip('已切换到用户中心')
      }
      
      // F1: 显示快捷键帮助
      if (event.key === 'F1') {
        event.preventDefault()
        this.showShortcutHelp()
      }
    },
    
    async quickLogout() {
      try {
        await this.$confirm(
          '确定要快速退出登录吗？',
          '快捷键退出确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            center: true
          }
        )
        
        await authManager.logout(false) // 不显示确认对话框，因为已经确认过了
        this.showShortcutTip('已退出登录')
      } catch {
        // 用户取消了
      }
    },
    
    showShortcutTip(message) {
      this.$message({
        message: `🚀 ${message}`,
        type: 'success',
        duration: 2000,
        showClose: true
      })
    },
    
    showShortcutHelp() {
      const shortcuts = [
        'Ctrl+Shift+Q: 快速退出登录',
        'Ctrl+Shift+H: 切换到展示主页',
        this.isAdmin ? 'Ctrl+Shift+M: 切换到管理后台' : null,
        this.isUser ? 'Ctrl+Shift+U: 切换到用户中心' : null,
        'F1: 显示此帮助信息'
      ].filter(Boolean)
      
      this.$alert(
        shortcuts.join('\n'),
        '⌨️ 键盘快捷键',
        {
          confirmButtonText: '我知道了',
          type: 'info',
          center: true
        }
      )
    }
  }
}
</script>

<style scoped>
/* 这个组件没有可视元素 */
</style> 