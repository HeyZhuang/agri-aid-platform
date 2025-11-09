import { createStore } from 'vuex'

export default createStore({
  state: {
    // 用户信息 - 统一使用xm-user键名
    user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
    // 当前主题
    theme: localStorage.getItem('theme') || 'light',
    // 加载状态
    loading: false,
    // 语言设置
    language: localStorage.getItem('language') || 'zh-CN',
    // 登录状态 - 立即检查localStorage中的用户信息
    isAuthenticated: !!(JSON.parse(localStorage.getItem('xm-user') || '{}').id),
  },
  
  mutations: {
    SET_USER(state, user) {
      state.user = user
      state.isAuthenticated = !!(user && user.id)
      localStorage.setItem('xm-user', JSON.stringify(user))
    },
    
    SET_THEME(state, theme) {
      state.theme = theme
      localStorage.setItem('theme', theme)
    },
    
    SET_LOADING(state, loading) {
      state.loading = loading
    },
    
    SET_LANGUAGE(state, language) {
      state.language = language
      localStorage.setItem('language', language)
    },
    
    CLEAR_USER(state) {
      state.user = {}
      state.isAuthenticated = false
      localStorage.removeItem('xm-user')
      // 清理其他相关数据
      localStorage.removeItem('token')
    },
    
    UPDATE_USER_AVATAR(state, avatar) {
      if (state.user.id) {
        state.user.avatar = avatar
        localStorage.setItem('xm-user', JSON.stringify(state.user))
      }
    },
    
    INIT_AUTH_STATE(state) {
      const user = JSON.parse(localStorage.getItem('xm-user') || '{}')
      state.user = user
      state.isAuthenticated = !!(user && user.id)
    }
  },
  
  actions: {
    // 登录
    login({ commit }, userInfo) {
      commit('SET_USER', userInfo)
      return Promise.resolve(userInfo)
    },
    
    // 退出登录
    logout({ commit, state }) {
      return new Promise((resolve) => {
        // 如果有后端退出接口，可以在这里调用
        // 目前先清理本地状态
        commit('CLEAR_USER')
        
        // 可以在这里添加清理其他状态的逻辑
        // 比如清理购物车、临时数据等
        
        resolve()
      })
    },
    
    // 更新用户信息
    updateUser({ commit }, userInfo) {
      commit('SET_USER', userInfo)
    },
    
    // 初始化认证状态
    initAuth({ commit }) {
      commit('INIT_AUTH_STATE')
    },
    
    // 切换主题
    setTheme({ commit }, theme) {
      commit('SET_THEME', theme)
    },
    
    // 设置加载状态
    setLoading({ commit }, loading) {
      commit('SET_LOADING', loading)
    },
    
    // 设置语言
    setLanguage({ commit }, language) {
      commit('SET_LANGUAGE', language)
    }
  },
  
  getters: {
    // 是否已认证
    isAuthenticated: state => state.isAuthenticated,
    
    // 用户角色
    userRole: state => state.user.role || null,
    
    // 是否为管理员
    isAdmin: state => state.user.role === 'ADMIN',
    
    // 是否为普通用户
    isUser: state => state.user.role === 'USER',
    
    // 用户信息
    userInfo: state => state.user,
    
    // 用户名
    userName: state => state.user.name || state.user.username || '',
    
    // 用户头像
    userAvatar: state => state.user.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
    
    // 是否为暗色主题
    isDarkMode: state => state.theme === 'dark',
    
    // 当前语言
    currentLanguage: state => state.language,
    
    // 获取角色显示名称
    roleDisplayName: state => {
      const roleMap = {
        'ADMIN': '管理员',
        'USER': '用户'
      }
      return roleMap[state.user.role] || '访客'
    }
  }
}) 