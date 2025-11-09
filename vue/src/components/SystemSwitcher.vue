<template>
  <div class="system-switcher" v-if="isAuthenticated">
    <el-button-group>
      <el-tooltip content="展示主页" placement="top">
        <el-button 
          :type="isInHome ? 'primary' : ''" 
          @click="switchToHome"
        >
          <el-icon><House /></el-icon>
          主页
        </el-button>
      </el-tooltip>
      
      <el-tooltip content="管理后台" placement="top" v-if="isAdmin">
        <el-button 
          :type="isInManager ? 'primary' : ''" 
          @click="switchToAdmin"
        >
          <el-icon><Setting /></el-icon>
          管理
        </el-button>
      </el-tooltip>
      
      <el-tooltip content="用户中心" placement="top" v-if="isUser">
        <el-button 
          :type="isInUser ? 'primary' : ''" 
          @click="switchToUser"
        >
          <el-icon><User /></el-icon>
          用户
        </el-button>
      </el-tooltip>
      
      <el-tooltip content="退出登录" placement="top">
        <el-button 
          type="danger" 
          @click="logout"
        >
          <el-icon><SwitchButton /></el-icon>
          退出
        </el-button>
      </el-tooltip>
    </el-button-group>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { authManager } from '@/utils/auth'
import { House, Setting, User, SwitchButton } from '@element-plus/icons-vue'

export default {
  name: 'SystemSwitcher',
  components: {
    House,
    Setting,
    User,
    SwitchButton
  },
  computed: {
    ...mapGetters(['isAuthenticated', 'isAdmin', 'isUser']),
    
    isInHome() {
      const path = this.$route.path
      return path === '/' || (!path.startsWith('/manager') && !path.startsWith('/front'))
    },
    
    isInManager() {
      return this.$route.path.startsWith('/manager')
    },
    
    isInUser() {
      return this.$route.path.startsWith('/front')
    }
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
    
    logout() {
      authManager.logout()
    }
  }
}
</script>

<style scoped>
.system-switcher {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-radius: 6px;
  overflow: hidden;
}

.system-switcher .el-button-group .el-button {
  border-radius: 0;
}

.system-switcher .el-button-group .el-button:first-child {
  border-top-left-radius: 6px;
  border-bottom-left-radius: 6px;
}

.system-switcher .el-button-group .el-button:last-child {
  border-top-right-radius: 6px;
  border-bottom-right-radius: 6px;
}
</style> 