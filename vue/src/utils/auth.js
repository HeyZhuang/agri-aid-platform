import { ElMessage, ElMessageBox } from 'element-plus'
import router from '@/router'
import store from '@/store'

class AuthManager {
  constructor() {
    this.initAuth()
  }

  // 初始化认证状态
  initAuth() {
    store.dispatch('initAuth')
  }

  // 检查是否已登录
  isAuthenticated() {
    return store.getters.isAuthenticated
  }

  // 检查用户角色
  hasRole(role) {
    return store.getters.userRole === role
  }

  // 检查是否为管理员
  isAdmin() {
    return store.getters.isAdmin
  }

  // 检查是否为普通用户
  isUser() {
    return store.getters.isUser
  }

  // 获取用户信息
  getUserInfo() {
    return store.getters.userInfo
  }

  // 登录
  async login(userInfo) {
    try {
      await store.dispatch('login', userInfo)
      ElMessage.success('登录成功')
      
      // 根据角色跳转到对应页面
      this.redirectAfterLogin(userInfo.role)
      
      return true
    } catch (error) {
      ElMessage.error('登录失败')
      return false
    }
  }

  // 退出登录
  async logout(showConfirm = true) {
    const performLogout = async () => {
      try {
        await store.dispatch('logout')
        
        // 跳转到登录页
        router.push('/login')
        
        ElMessage.success('退出成功')
        return true
      } catch (error) {
        ElMessage.error('退出失败')
        return false
      }
    }

    if (showConfirm) {
      try {
        await ElMessageBox.confirm(
          '确定要退出登录吗？退出后需要重新登录才能访问相关功能。',
          '退出确认',
          {
            confirmButtonText: '确定退出',
            cancelButtonText: '取消',
            type: 'warning',
            center: true
          }
        )
        return await performLogout()
      } catch {
        return false
      }
    } else {
      return await performLogout()
    }
  }

  // 根据角色跳转
  redirectAfterLogin(role) {
    const currentPath = router.currentRoute.value.path
    
    // 如果当前在登录页，则根据角色跳转
    if (currentPath === '/login' || currentPath === '/register') {
      if (role === 'ADMIN') {
        router.push('/manager/home')
      } else if (role === 'USER') {
        router.push('/front/home')
      } else {
        router.push('/')
      }
    }
  }

  // 切换到管理后台
  switchToAdmin() {
    if (this.isAdmin()) {
      router.push('/manager/home')
    } else {
      ElMessage.warning('需要管理员权限才能访问后台管理')
    }
  }

  // 切换到用户中心
  switchToUser() {
    if (this.isUser()) {
      router.push('/front/home')
    } else {
      ElMessage.warning('需要用户权限才能访问用户中心')
    }
  }

  // 切换到展示主页
  switchToHome() {
    router.push('/')
  }

  // 权限检查中间件
  requireAuth() {
    if (!this.isAuthenticated()) {
      ElMessage.warning('请先登录')
      router.push('/login')
      return false
    }
    return true
  }

  // 管理员权限检查
  requireAdmin() {
    if (!this.requireAuth()) return false
    
    if (!this.isAdmin()) {
      ElMessage.error('需要管理员权限')
      router.push('/')
      return false
    }
    return true
  }

  // 用户权限检查
  requireUser() {
    if (!this.requireAuth()) return false
    
    if (!this.isUser()) {
      ElMessage.error('需要用户权限')
      router.push('/')
      return false
    }
    return true
  }

  // 更新用户信息
  updateUser(userInfo) {
    store.dispatch('updateUser', userInfo)
  }

  // 更新用户头像
  updateAvatar(avatar) {
    store.commit('UPDATE_USER_AVATAR', avatar)
  }
}

// 创建全局实例
export const authManager = new AuthManager()

// 导出类供测试使用
export default AuthManager

// Vue 插件安装
export const AuthPlugin = {
  install(app) {
    app.config.globalProperties.$auth = authManager
    app.provide('auth', authManager)
  }
} 