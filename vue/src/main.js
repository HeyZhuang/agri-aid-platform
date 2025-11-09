import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import request from '@/utils/request'
import { AuthPlugin, authManager } from '@/utils/auth'

// Element Plus 导入
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 样式导入
import '@/assets/css/tailwind.css'
import 'animate.css'
import 'aos/dist/aos.css'
import '@/assets/css/global.css'

// 工具导入
import AOS from 'aos'

// ECharts导入
import ECharts from 'vue-echarts'
import { use } from 'echarts/core'
import {
  CanvasRenderer
} from 'echarts/renderers'
import {
  BarChart,
  LineChart,
  PieChart,
  MapChart,
  ScatterChart
} from 'echarts/charts'
import {
  GridComponent,
  TooltipComponent,
  TitleComponent,
  LegendComponent,
  ToolboxComponent,
  DataZoomComponent,
  VisualMapComponent,
  GeoComponent
} from 'echarts/components'

use([
  CanvasRenderer,
  BarChart,
  LineChart,
  PieChart,
  MapChart,
  ScatterChart,
  GridComponent,
  TooltipComponent,
  TitleComponent,
  LegendComponent,
  ToolboxComponent,
  DataZoomComponent,
  VisualMapComponent,
  GeoComponent
])

const app = createApp(App)

// 全局配置
app.config.globalProperties.$request = request
app.config.globalProperties.$baseUrl = process.env.VUE_APP_BASEURL

// 注册全局组件
app.component('v-chart', ECharts)

// 使用插件
app.use(ElementPlus)
app.use(store)
app.use(router)
app.use(AuthPlugin)

// 注册图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 初始化AOS动画
AOS.init({
  duration: 800,
  once: true
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 初始化认证状态
  authManager.initAuth()
  
  // 检查需要认证的路由
  if (to.meta.requiresAuth && !authManager.isAuthenticated()) {
    next('/login')
    return
  }
  
  // 检查管理员权限
  if (to.meta.requiresAdmin && !authManager.isAdmin()) {
    next('/')
    return
  }
  
  // 检查用户权限
  if (to.meta.requiresUser && !authManager.isUser()) {
    next('/')
    return
  }
  
  next()
})

// 初始化应用认证状态
authManager.initAuth()

app.mount('#app')
