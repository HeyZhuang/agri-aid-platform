<template>
  <div class="global-nav">
    <div class="nav-container">
      <!-- 左侧 Logo 和导航 -->
      <div class="nav-left">
        <div class="logo-section" @click="goHome">
          <img src="@/assets/imgs/logo.png" alt="Logo" class="logo">
          <span class="title">中国助农扶贫平台</span>
        </div>
        
        <!-- 主导航菜单 -->
        <div class="main-nav" v-if="isShowPageNav">
          <div class="nav-items">
            <router-link 
              to="/products" 
              class="nav-item"
              :class="{ active: $route.path === '/products' }"
            >
              <i class="nav-icon">🛍️</i>
              <span>产品展厅</span>
            </router-link>
            <router-link 
              to="/stories" 
              class="nav-item"
              :class="{ active: $route.path === '/stories' }"
            >
              <i class="nav-icon">📖</i>
              <span>扶贫故事</span>
            </router-link>
            <router-link 
              to="/dashboard" 
              class="nav-item"
              :class="{ active: $route.path === '/dashboard' }"
            >
              <i class="nav-icon">📊</i>
              <span>数据看板</span>
            </router-link>
            <router-link 
              to="/about" 
              class="nav-item"
              :class="{ active: $route.path === '/about' }"
            >
              <i class="nav-icon">🤝</i>
              <span>助农计划</span>
            </router-link>
            <router-link 
              to="/map" 
              class="nav-item"
              :class="{ active: $route.path === '/map' }"
            >
              <i class="nav-icon">🗺️</i>
              <span>扶贫地图</span>
            </router-link>
          </div>
        </div>
        
        <!-- 系统切换菜单 -->
        <div class="system-menu" v-if="!isShowPageNav && isAuthenticated">
          <el-dropdown @command="handleSystemChange" placement="bottom-start">
            <span class="system-selector">
              {{ currentSystemName }}
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="home">
                  <el-icon><House /></el-icon>
                  展示主页
                </el-dropdown-item>
                <el-dropdown-item command="manager" :disabled="!isAdmin">
                  <el-icon><Setting /></el-icon>
                  管理后台
                  <span v-if="!isAdmin" class="permission-hint">（需要管理员权限）</span>
                </el-dropdown-item>
                <el-dropdown-item command="front" :disabled="!isUser">
                  <el-icon><User /></el-icon>
                  用户中心
                  <span v-if="!isUser" class="permission-hint">（需要用户权限）</span>
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <!-- 右侧 用户信息和操作 -->
      <div class="nav-right">
        <!-- 未登录状态 -->
        <div v-if="!isAuthenticated" class="auth-buttons">
          <el-button size="small" @click="$router.push('/login')">登录</el-button>
          <el-button size="small" type="primary" @click="$router.push('/register')">注册</el-button>
        </div>
        
        <!-- 已登录状态 -->
        <div v-else class="user-section">
          <!-- 快速切换按钮 -->
          <div class="quick-actions">
            <el-tooltip content="返回主页" placement="bottom">
              <el-button size="small" circle @click="goHome">
                <el-icon><House /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="管理后台" placement="bottom" v-if="isAdmin">
              <el-button 
                size="small" 
                circle 
                @click="switchToAdmin"
                :type="isInManagerSystem ? 'primary' : ''"
              >
                <el-icon><Setting /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="用户中心" placement="bottom" v-if="isUser">
              <el-button 
                size="small" 
                circle 
                @click="switchToUser"
                :type="isInUserSystem ? 'primary' : ''"
              >
                <el-icon><User /></el-icon>
              </el-button>
            </el-tooltip>
            <!-- 明显的退出登录按钮 -->
            <el-tooltip content="退出登录" placement="bottom">
              <el-button 
                size="small" 
                type="danger"
                @click="handleLogout"
              >
                <el-icon><SwitchButton /></el-icon>
                退出
              </el-button>
            </el-tooltip>
          </div>
          
          <!-- 用户头像和菜单 -->
          <el-dropdown @command="handleUserAction" placement="bottom-end">
            <div class="user-avatar">
              <img :src="userAvatar" alt="Avatar">
              <span class="username">{{ userName }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>
                  <div class="user-info">
                    <div class="role-badge" :class="userRole?.toLowerCase()">
                      {{ roleDisplayName }}
                    </div>
                    <div class="user-name">{{ userName }}</div>
                  </div>
                </el-dropdown-item>
                <el-dropdown-item divided command="profile">
                  <el-icon><User /></el-icon>
                  个人信息
                </el-dropdown-item>
                <el-dropdown-item v-if="isUser" command="orders">
                  <el-icon><ShoppingBag /></el-icon>
                  我的订单
                </el-dropdown-item>
                <el-dropdown-item v-if="isUser" command="apply">
                  <el-icon><Document /></el-icon>
                  我的申请
                </el-dropdown-item>
                <el-dropdown-item command="password">
                  <el-icon><Lock /></el-icon>
                  修改密码
                </el-dropdown-item>
                <el-dropdown-item divided command="switchSystem" v-if="canSwitchSystem">
                  <el-icon><Refresh /></el-icon>
                  {{ switchSystemText }}
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { authManager } from '@/utils/auth'
import { House, Setting, User, ArrowDown, Lock, Refresh, SwitchButton, Document, ShoppingBag } from '@element-plus/icons-vue'

export default {
  name: 'GlobalNav',
  components: {
    House,
    Setting,
    User,
    ArrowDown,
    Lock,
    Refresh,
    SwitchButton,
    Document,
    ShoppingBag
  },
  computed: {
    ...mapGetters([
      'isAuthenticated',
      'userRole', 
      'isAdmin',
      'isUser',
      'userName',
      'userAvatar',
      'roleDisplayName'
    ]),
    
    currentSystemName() {
      const path = this.$route.path
      if (path.startsWith('/manager')) return '管理后台'
      if (path.startsWith('/front')) return '用户中心'
      return '展示主页'
    },
    
    isShowPageNav() {
      const path = this.$route.path
      // 在展示页面显示主导航菜单
      const showNavPages = ['/', '/products', '/stories', '/dashboard', '/about', '/map']
      return showNavPages.includes(path) || path.startsWith('/product/') || path.startsWith('/story/')
    },
    
    isInManagerSystem() {
      return this.$route.path.startsWith('/manager')
    },
    
    isInUserSystem() {
      return this.$route.path.startsWith('/front')
    },
    
    canSwitchSystem() {
      // 管理员可以在管理后台和用户中心之间切换
      // 普通用户可以从用户中心切换到展示页面
      return (this.isAdmin && (this.isInManagerSystem || this.isInUserSystem)) ||
             (this.isUser && this.isInUserSystem)
    },
    
    switchSystemText() {
      if (this.isInManagerSystem) {
        return this.isUser ? '切换到用户中心' : '返回展示页面'
      } else if (this.isInUserSystem) {
        return this.isAdmin ? '切换到管理后台' : '返回展示页面'
      }
      return '系统切换'
    }
  },
  
  methods: {
    handleSystemChange(command) {
      switch (command) {
        case 'home':
          authManager.switchToHome()
          break
        case 'manager':
          authManager.switchToAdmin()
          break
        case 'front':
          authManager.switchToUser()
          break
      }
    },
    
    handleUserAction(command) {
      switch (command) {
        case 'profile':
          if (this.isAdmin) {
            this.$router.push('/manager/adminPerson')
          } else if (this.isUser) {
            this.$router.push('/front/person')
          }
          break
        case 'orders':
          this.$router.push('/front/orders')
          break
        case 'apply':
          this.$router.push('/front/apply')
          break
        case 'password':
          if (this.isAdmin) {
            this.$router.push('/manager/password')
          } else {
            this.$message.info('功能开发中')
          }
          break
        case 'switchSystem':
          this.handleQuickSwitch()
          break
        case 'logout':
          authManager.logout()
          break
      }
    },
    
    handleQuickSwitch() {
      if (this.isInManagerSystem && this.isUser) {
        authManager.switchToUser()
      } else if (this.isInUserSystem && this.isAdmin) {
        authManager.switchToAdmin()
      } else {
        authManager.switchToHome()
      }
    },
    
    goHome() {
      authManager.switchToHome()
    },
    
    switchToAdmin() {
      authManager.switchToAdmin()
    },
    
    switchToUser() {
      authManager.switchToUser()
    },
    
    handleLogout() {
      authManager.logout()
    }
  }
}
</script>

<style scoped>
.global-nav {
  background: linear-gradient(135deg, #c3272b 0%, #8b1a1a 100%);
  color: white;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 1000;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
}

.nav-left {
  display: flex;
  align-items: center;
  gap: 30px;
  flex: 1;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: opacity 0.3s ease;
}

.logo-section:hover {
  opacity: 0.8;
}

.logo {
  width: 36px;
  height: 36px;
  border-radius: 6px;
}

.title {
  font-size: 18px;
  font-weight: bold;
  white-space: nowrap;
}

.main-nav {
  flex: 1;
  max-width: 600px;
  margin-left: 40px;
}

.nav-items {
  display: flex;
  gap: 8px;
  align-items: center;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 20px;
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  border: 1px solid transparent;
  white-space: nowrap;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
  color: white;
  transform: translateY(-1px);
}

.nav-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
  border-color: rgba(255, 255, 255, 0.3);
}

.nav-icon {
  font-size: 16px;
  opacity: 0.9;
}

.system-menu {
  border-left: 1px solid rgba(255, 255, 255, 0.2);
  padding-left: 20px;
}

.system-selector {
  color: white;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 6px;
  transition: background-color 0.3s ease;
  font-size: 14px;
  white-space: nowrap;
}

.system-selector:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.auth-buttons {
  display: flex;
  gap: 8px;
}

.user-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.quick-actions {
  display: flex;
  gap: 8px;
}

.user-avatar {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 6px 12px;
  border-radius: 20px;
  transition: background-color 0.3s ease;
}

.user-avatar:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-avatar img {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.username {
  font-size: 14px;
  max-width: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.user-info {
  text-align: center;
  padding: 8px 0;
}

.role-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  margin-bottom: 4px;
}

.role-badge.admin {
  background-color: #e74c3c;
  color: white;
}

.role-badge.user {
  background-color: #3498db;
  color: white;
}

.user-name {
  font-weight: bold;
  color: #333;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .main-nav {
    margin-left: 20px;
    max-width: 400px;
  }
  
  .nav-item span {
    display: none;
  }
  
  .nav-item {
    padding: 8px 12px;
    min-width: 40px;
    justify-content: center;
  }
}

@media (max-width: 768px) {
  .nav-container {
    padding: 0 12px;
  }
  
  .title {
    display: none;
  }
  
  .username {
    display: none;
  }
  
  .quick-actions {
    display: none;
  }
  
  .main-nav {
    margin-left: 16px;
    max-width: 250px;
  }
  
  .nav-items {
    gap: 4px;
  }
  
  .nav-item {
    padding: 6px 8px;
    font-size: 12px;
  }
  
  .nav-icon {
    font-size: 14px;
  }
  
  .system-menu {
    border-left: none;
    padding-left: 0;
  }
}

@media (max-width: 480px) {
  .main-nav {
    display: none;
  }
}

.permission-hint {
  font-size: 12px;
  color: #999;
  margin-left: 4px;
}

.quick-actions .el-button.is-circle {
  transition: all 0.3s ease;
}

.quick-actions .el-button.is-circle:hover {
  transform: translateY(-1px);
}
</style> 