<template>
  <div class="top-status-bar" v-if="isAuthenticated && isVisible">
    <div class="status-content">
      <!-- 当前系统状态 -->
      <div class="system-status">
        <div class="status-indicator" :class="systemStatusClass"></div>
        <span class="status-text">{{ currentSystemStatus }}</span>
      </div>
      
      <!-- 用户信息 -->
      <div class="user-status">
        <span class="welcome-text">欢迎，</span>
        <span class="user-name">{{ userName }}</span>
        <span class="user-role">({{ roleDisplayName }})</span>
      </div>
      
      <!-- 快速操作 -->
      <div class="quick-operations">
        <!-- 系统切换按钮 -->
        <div class="system-buttons">
          <el-button 
            :type="isInHome ? 'primary' : ''"
            size="small"
            @click="switchToHome"
          >
            <el-icon><House /></el-icon>
            主页
          </el-button>
          <el-button 
            v-if="isAdmin"
            :type="isInManagerSystem ? 'primary' : ''"
            size="small"
            @click="switchToAdmin"
          >
            <el-icon><Setting /></el-icon>
            管理
          </el-button>
          <el-button 
            v-if="isUser"
            :type="isInUserSystem ? 'primary' : ''"
            size="small"
            @click="switchToUser"
          >
            <el-icon><User /></el-icon>
            用户
          </el-button>
        </div>
        
        <!-- 退出登录按钮 -->
        <el-button 
          type="danger" 
          size="small"
          @click="handleLogout"
        >
          <el-icon><SwitchButton /></el-icon>
          退出登录
        </el-button>
      </div>
      
      <!-- 关闭按钮 -->
      <div class="close-btn" @click="hideStatusBar">
        <el-icon><Close /></el-icon>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { authManager } from '@/utils/auth'
import { House, Setting, User, SwitchButton, Close } from '@element-plus/icons-vue'

export default {
  name: 'TopStatusBar',
  components: {
    House,
    Setting,
    User,
    SwitchButton,
    Close
  },
  data() {
    return {
      isVisible: true
    }
  },
  computed: {
    ...mapGetters([
      'isAuthenticated',
      'userRole',
      'isAdmin',
      'isUser',
      'userName',
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
    
    currentSystemStatus() {
      if (this.isInManagerSystem) return '管理后台系统'
      if (this.isInUserSystem) return '用户中心系统'
      return '展示主页系统'
    },
    
    systemStatusClass() {
      if (this.isInManagerSystem) return 'status-admin'
      if (this.isInUserSystem) return 'status-user'
      return 'status-home'
    }
  },
  
  mounted() {
    // 检查是否已经隐藏过状态栏
    const hidden = localStorage.getItem('topStatusBarHidden')
    this.isVisible = !hidden
    
    // 添加调试信息
    console.log('TopStatusBar mounted:', {
      isAuthenticated: this.isAuthenticated,
      isVisible: this.isVisible,
      userRole: this.userRole,
      userName: this.userName
    })
  },
  
  methods: {
    switchToHome() {
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
    },
    
    hideStatusBar() {
      this.isVisible = false
      localStorage.setItem('topStatusBarHidden', 'true')
    }
  }
}
</script>

<style scoped>
.top-status-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  z-index: 2000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  animation: slideDown 0.3s ease-out;
}

.status-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.system-status {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.status-indicator.status-home {
  background-color: #67c23a;
}

.status-indicator.status-admin {
  background-color: #e6a23c;
}

.status-indicator.status-user {
  background-color: #409eff;
}

.status-text {
  font-size: 12px;
  font-weight: 500;
}

.user-status {
  display: flex;
  align-items: center;
  gap: 4px;
}

.welcome-text {
  font-size: 12px;
  opacity: 0.9;
}

.user-name {
  font-size: 14px;
  font-weight: 600;
}

.user-role {
  font-size: 11px;
  opacity: 0.8;
  background: rgba(255, 255, 255, 0.2);
  padding: 2px 6px;
  border-radius: 10px;
  margin-left: 4px;
}

.quick-operations {
  display: flex;
  align-items: center;
  gap: 12px;
}

.close-btn {
  cursor: pointer;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.2s ease;
}

.close-btn:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.close-btn i {
  font-size: 12px;
}

/* 动画效果 */
@keyframes slideDown {
  from {
    transform: translateY(-100%);
  }
  to {
    transform: translateY(0);
  }
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .status-content {
    padding: 6px 10px;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .user-status {
    order: 1;
    flex: 1;
  }
  
  .quick-operations {
    order: 2;
    gap: 8px;
  }
  
  .system-status {
    order: 3;
  }
}

/* 确保页面内容不被状态栏遮挡 */
.top-status-bar + * {
  margin-top: 40px;
}
</style>