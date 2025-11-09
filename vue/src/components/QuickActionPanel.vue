<template>
  <div class="quick-action-panel" v-if="isAuthenticated">
    <!-- 主面板 -->
    <div class="panel-main" :class="{ 'panel-expanded': isExpanded }">
      <!-- 用户信息栏 -->
      <div class="user-info-bar">
        <div class="user-avatar">
          <img :src="userAvatar" alt="用户头像">
        </div>
        <div class="user-details" v-if="isExpanded">
          <div class="user-name">{{ userName }}</div>
          <div class="user-role">{{ roleDisplayName }}</div>
        </div>
      </div>

      <!-- 快速操作按钮 -->
      <div class="action-buttons">
        <!-- 系统切换按钮 -->
        <template v-if="!isExpanded">
          <el-tooltip content="系统切换" placement="left">
            <el-button 
              class="action-btn system-switch-btn"
              :type="currentSystemType"
              circle
              @click="toggleSystemMenu"
            >
              <el-icon><Refresh /></el-icon>
            </el-button>
          </el-tooltip>
        </template>

        <!-- 展开时的系统切换按钮 -->
        <div v-if="isExpanded" class="system-buttons">
          <el-button 
            :type="isInHome ? 'primary' : ''"
            size="small"
            @click="switchToHome"
          >
            <el-icon><House /></el-icon>
            展示主页
          </el-button>
          <el-button 
            v-if="isAdmin"
            :type="isInManagerSystem ? 'primary' : ''"
            size="small"
            @click="switchToAdmin"
          >
            <el-icon><Setting /></el-icon>
            管理后台
          </el-button>
          <el-button 
            v-if="isUser"
            :type="isInUserSystem ? 'primary' : ''"
            size="small"
            @click="switchToUser"
          >
            <el-icon><User /></el-icon>
            用户中心
          </el-button>
        </div>

        <!-- 退出登录按钮 -->
        <template v-if="!isExpanded">
          <el-tooltip content="退出登录" placement="left">
            <el-button 
              class="action-btn logout-btn"
              type="danger"
              circle
              @click="handleLogout"
            >
              <el-icon><SwitchButton /></el-icon>
            </el-button>
          </el-tooltip>
        </template>

        <!-- 展开时的退出按钮 -->
        <el-button 
          v-if="isExpanded"
          type="danger"
          size="small"
          @click="handleLogout"
        >
          <el-icon><SwitchButton /></el-icon>
          退出登录
        </el-button>
      </div>

      <!-- 展开/收缩按钮 -->
      <div class="toggle-btn" @click="toggleExpanded">
        <el-icon>
          <ArrowUp v-if="isExpanded" />
          <ArrowDown v-else />
        </el-icon>
      </div>
    </div>

    <!-- 系统切换弹出菜单 -->
    <transition name="slide-left">
      <div v-if="showSystemMenu && !isExpanded" class="system-menu">
        <div class="menu-title">切换系统</div>
        <div class="menu-items">
          <div 
            class="menu-item" 
            :class="{ active: isInHome }"
            @click="switchToHome"
          >
            <el-icon><House /></el-icon>
            <span>展示主页</span>
          </div>
          <div 
            v-if="isAdmin"
            class="menu-item" 
            :class="{ active: isInManagerSystem }"
            @click="switchToAdmin"
          >
            <el-icon><Setting /></el-icon>
            <span>管理后台</span>
          </div>
          <div 
            v-if="isUser"
            class="menu-item" 
            :class="{ active: isInUserSystem }"
            @click="switchToUser"
          >
            <el-icon><User /></el-icon>
            <span>用户中心</span>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { authManager } from '@/utils/auth'
import { House, Setting, User, Refresh, SwitchButton, ArrowUp, ArrowDown } from '@element-plus/icons-vue'

export default {
  name: 'QuickActionPanel',
  components: {
    House,
    Setting,
    User,
    Refresh,
    SwitchButton,
    ArrowUp,
    ArrowDown
  },
  data() {
    return {
      isExpanded: false,
      showSystemMenu: false
    }
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
    
    isInHome() {
      const path = this.$route.path
      return path === '/' || (!path.startsWith('/manager') && !path.startsWith('/front'))
    },
    
    isInManagerSystem() {
      return this.$route.path.startsWith('/manager')
    },
    
    isInUserSystem() {
      return this.$route.path.startsWith('/front')
    },
    
    currentSystemType() {
      if (this.isInManagerSystem) return 'warning'
      if (this.isInUserSystem) return 'primary'
      return ''
    }
  },
  
  mounted() {
    // 点击外部关闭菜单
    document.addEventListener('click', this.handleClickOutside)
    
    // 添加调试信息
    console.log('QuickActionPanel mounted:', {
      isAuthenticated: this.isAuthenticated,
      userRole: this.userRole,
      userName: this.userName,
      isAdmin: this.isAdmin,
      isUser: this.isUser
    })
  },
  
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
  },
  
  methods: {
    toggleExpanded() {
      this.isExpanded = !this.isExpanded
      this.showSystemMenu = false
    },
    
    toggleSystemMenu() {
      this.showSystemMenu = !this.showSystemMenu
    },
    
    handleClickOutside(event) {
      if (!this.$el.contains(event.target)) {
        this.showSystemMenu = false
      }
    },
    
    switchToHome() {
      authManager.switchToHome()
      this.showSystemMenu = false
    },
    
    switchToAdmin() {
      authManager.switchToAdmin()
      this.showSystemMenu = false
    },
    
    switchToUser() {
      authManager.switchToUser()
      this.showSystemMenu = false
    },
    
    async handleLogout() {
      const success = await authManager.logout()
      if (success) {
        this.showSystemMenu = false
        this.isExpanded = false
      }
    }
  }
}
</script>

<style scoped>
.quick-action-panel {
  position: fixed;
  top: 50%;
  right: 20px;
  transform: translateY(-50%);
  z-index: 1500;
}

.panel-main {
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  border: 1px solid #e4e7ed;
  overflow: hidden;
  transition: all 0.3s ease;
  width: 60px;
  position: relative;
}

.panel-main.panel-expanded {
  width: 180px;
}

.user-info-bar {
  display: flex;
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid rgba(255, 255, 255, 0.3);
  flex-shrink: 0;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-details {
  margin-left: 12px;
  flex: 1;
  min-width: 0;
}

.user-name {
  font-size: 14px;
  font-weight: 600;
  color: #ffffff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-role {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 2px;
}

.action-buttons {
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.action-btn {
  width: 36px !important;
  height: 36px !important;
  align-self: center;
}

.system-buttons {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.logout-btn {
  margin-top: 8px;
}

.toggle-btn {
  position: absolute;
  bottom: 8px;
  right: 8px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #909399;
  font-size: 12px;
}

.toggle-btn:hover {
  background: #e6e8eb;
  color: #606266;
}

.system-menu {
  position: absolute;
  right: 70px;
  top: 60px;
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  border: 1px solid #e4e7ed;
  min-width: 140px;
  overflow: hidden;
}

.menu-title {
  padding: 12px 16px 8px;
  font-size: 12px;
  color: #909399;
  border-bottom: 1px solid #f0f0f0;
  background: #fafafa;
}

.menu-items {
  padding: 8px 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #606266;
}

.menu-item:hover {
  background: #f5f7fa;
  color: #409eff;
}

.menu-item.active {
  background: #ecf5ff;
  color: #409eff;
}

.menu-item i {
  margin-right: 8px;
  font-size: 14px;
  width: 16px;
}

.menu-item span {
  font-size: 14px;
}

/* 动画效果 */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: all 0.3s ease;
}

.slide-left-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.slide-left-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .quick-action-panel {
    right: 10px;
  }
  
  .panel-main.panel-expanded {
    width: 160px;
  }
}

/* 暗色主题支持 */
@media (prefers-color-scheme: dark) {
  .panel-main {
    background: #2d3748;
    border-color: #4a5568;
  }
  
  .user-info-bar {
    border-color: #4a5568;
  }
  
  .toggle-btn {
    background: #4a5568;
    color: #a0aec0;
  }
  
  .toggle-btn:hover {
    background: #718096;
    color: #e2e8f0;
  }
  
  .system-menu {
    background: #2d3748;
    border-color: #4a5568;
  }
  
  .menu-title {
    background: #1a202c;
    border-color: #4a5568;
    color: #a0aec0;
  }
  
  .menu-item {
    color: #e2e8f0;
  }
  
  .menu-item:hover {
    background: #4a5568;
  }
}
</style> 