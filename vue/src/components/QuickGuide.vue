<template>
  <el-dialog
    title="🚀 快速操作指南"
    v-model="visible"
    width="600px"
    center
    :close-on-click-modal="false"
  >
    <div class="guide-content">
      <h3>💡 多种退出登录方式</h3>
      <div class="guide-section">
        <div class="guide-item">
          <div class="guide-icon">🔝</div>
          <div class="guide-text">
            <strong>顶部状态栏</strong><br>
            页面顶部的紫色状态栏，显示当前系统状态，点击红色"退出登录"按钮
          </div>
        </div>
        
        <div class="guide-item">
          <div class="guide-icon">➡️</div>
          <div class="guide-text">
            <strong>右侧悬浮面板</strong><br>
            页面右侧中央的悬浮操作面板，点击展开按钮查看完整功能
          </div>
        </div>
        
        <div class="guide-item">
          <div class="guide-icon">🎯</div>
          <div class="guide-text">
            <strong>导航栏退出按钮</strong><br>
            页面顶部导航栏中的红色"退出"按钮，位于用户头像旁边
          </div>
        </div>
        
        <div class="guide-item">
          <div class="guide-icon">⌨️</div>
          <div class="guide-text">
            <strong>键盘快捷键</strong><br>
            按 <kbd>Ctrl+Shift+Q</kbd> (Mac用户按 <kbd>Cmd+Shift+Q</kbd>) 快速退出登录
          </div>
        </div>
      </div>

      <h3>🔄 系统切换功能</h3>
      <div class="guide-section">
        <div class="guide-item">
          <div class="guide-icon">🏠</div>
          <div class="guide-text">
            <strong>展示主页</strong><br>
            <kbd>Ctrl+Shift+H</kbd> 或点击相关按钮切换到产品展示页面
          </div>
        </div>
        
        <div class="guide-item" v-if="isAdmin">
          <div class="guide-icon">⚙️</div>
          <div class="guide-text">
            <strong>管理后台</strong><br>
            <kbd>Ctrl+Shift+M</kbd> 或点击管理按钮切换到后台管理系统
          </div>
        </div>
        
        <div class="guide-item" v-if="isUser">
          <div class="guide-icon">👤</div>
          <div class="guide-text">
            <strong>用户中心</strong><br>
            <kbd>Ctrl+Shift+U</kbd> 或点击用户按钮切换到用户中心
          </div>
        </div>
      </div>

      <h3>❓ 获取帮助</h3>
      <div class="guide-section">
        <div class="guide-item">
          <div class="guide-icon">❓</div>
          <div class="guide-text">
            <strong>快捷键帮助</strong><br>
            按 <kbd>F1</kbd> 键随时查看所有可用的键盘快捷键
          </div>
        </div>
      </div>

      <div class="guide-tips">
        <h4>💡 小贴士</h4>
        <ul>
          <li>所有退出登录操作都会要求确认，防止误操作</li>
          <li>系统会根据您的角色权限显示相应的切换选项</li>
          <li>顶部状态栏可以通过右上角的 ❌ 按钮隐藏</li>
          <li>右侧悬浮面板可以展开或收缩，适应不同使用习惯</li>
        </ul>
      </div>
    </div>

    <span slot="footer" class="dialog-footer">
      <el-checkbox v-model="dontShowAgain">不再显示此指南</el-checkbox>
      <div style="flex: 1;"></div>
      <el-button @click="close">我知道了</el-button>
    </span>
  </el-dialog>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'QuickGuide',
  data() {
    return {
      visible: false,
      dontShowAgain: false
    }
  },
  
  computed: {
    ...mapGetters(['isAuthenticated', 'isAdmin', 'isUser'])
  },
  
  mounted() {
    // 检查是否应该显示指南
    const shouldShow = !localStorage.getItem('quickGuideShown') && this.isAuthenticated
    if (shouldShow) {
      setTimeout(() => {
        this.visible = true
      }, 2000) // 延迟2秒显示，让用户先适应页面
    }
  },
  
  methods: {
    close() {
      this.visible = false
      
      if (this.dontShowAgain) {
        localStorage.setItem('quickGuideShown', 'true')
      }
    },
    
    show() {
      this.visible = true
    }
  }
}
</script>

<style scoped>
.guide-content {
  max-height: 500px;
  overflow-y: auto;
}

.guide-content h3 {
  color: #409eff;
  margin: 20px 0 15px 0;
  font-size: 16px;
  border-bottom: 2px solid #e6f7ff;
  padding-bottom: 8px;
}

.guide-content h3:first-child {
  margin-top: 0;
}

.guide-section {
  margin-bottom: 25px;
}

.guide-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 15px;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 8px;
  transition: all 0.2s ease;
}

.guide-item:hover {
  background: #e6f7ff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.1);
}

.guide-icon {
  font-size: 24px;
  margin-right: 12px;
  flex-shrink: 0;
  width: 32px;
  text-align: center;
}

.guide-text {
  flex: 1;
  line-height: 1.6;
}

.guide-text strong {
  color: #303133;
  font-size: 14px;
}

.guide-tips {
  background: #fff7e6;
  border: 1px solid #ffd591;
  border-radius: 8px;
  padding: 16px;
  margin-top: 20px;
}

.guide-tips h4 {
  margin: 0 0 12px 0;
  color: #fa8c16;
  font-size: 14px;
}

.guide-tips ul {
  margin: 0;
  padding-left: 20px;
}

.guide-tips li {
  margin-bottom: 8px;
  color: #595959;
  line-height: 1.5;
}

kbd {
  background: #f5f5f5;
  border: 1px solid #d9d9d9;
  border-radius: 3px;
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.2);
  color: #333;
  display: inline-block;
  font-family: monospace;
  font-size: 12px;
  line-height: 1.4;
  margin: 0 2px;
  padding: 2px 4px;
  white-space: nowrap;
}

.dialog-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style> 