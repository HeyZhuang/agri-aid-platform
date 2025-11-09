import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue'),
    meta: { title: '中国助农扶贫平台' }
  },
  {
    path: '/products',
    name: 'Products',
    component: () => import('../views/Products.vue'),
    meta: { title: '产品展厅' }
  },
  {
    path: '/product/:id',
    name: 'ProductDetail',
    component: () => import('../views/ProductDetail.vue'),
    meta: { title: '产品详情' }
  },
  {
    path: '/stories',
    name: 'Stories',
    component: () => import('../views/Stories.vue'),
    meta: { title: '扶贫故事' }
  },
  {
    path: '/story/:id',
    name: 'StoryDetail',
    component: () => import('../views/StoryDetail.vue'),
    meta: { title: '故事详情' }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue'),
    meta: { title: '数据看板' }
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/About.vue'),
    meta: { title: '助农计划' }
  },
  {
    path: '/map',
    name: 'Map',
    component: () => import('../views/Map.vue'),
    meta: { title: '扶贫地图' }
  },
  // 原有的管理端路由
  {
    path: '/manager',
    name: 'Manager',
    component: () => import('../views/Manager.vue'),
    redirect: '/manager/home',
    children: [
      { path: '403', name: 'NoAuth', meta: { name: '无权限' }, component: () => import('../views/manager/403') },
      { path: 'home', name: 'ManagerHome', meta: { name: '系统首页' }, component: () => import('../views/manager/Home') },
      { path: 'admin', name: 'Admin', meta: { name: '管理员信息' }, component: () => import('../views/manager/Admin') },
      { path: 'adminPerson', name: 'AdminPerson', meta: { name: '个人信息' }, component: () => import('../views/manager/AdminPerson') },
      { path: 'password', name: 'Password', meta: { name: '修改密码' }, component: () => import('../views/manager/Password') },
      { path: 'notice', name: 'Notice', meta: { name: '公告信息' }, component: () => import('../views/manager/Notice') },
      { path: 'information', name: 'Information', meta: { name: '扶贫资讯' }, component: () => import('../views/manager/Information') },
      { path: 'user', name: 'User', meta: { name: '用户信息' }, component: () => import('../views/manager/User') },
      { path: 'policy', name: 'Policy', meta: { name: '扶贫政策' }, component: () => import('../views/manager/Policy') },
      { path: 'agritainment', name: 'Agritainment', meta: { name: '农家乐信息' }, component: () => import('../views/manager/Agritainment') },
      { path: 'goods', name: 'Goods', meta: { name: '商品信息' }, component: () => import('../views/manager/Goods') },
      { path: 'orders', name: 'Orders', meta: { name: '订单信息' }, component: () => import('../views/manager/Orders.vue') },
      { path: 'poorapply', name: 'Poorapply', meta: { name: '扶贫申请' }, component: () => import('../views/manager/PoorApply.vue') },
      { path: 'projectapply', name: 'Projectapply', meta: { name: '扶贫项目' }, component: () => import('../views/manager/ProjectApply.vue') },
      { path: 'comment', name: 'Comment', meta: { name: '政策管理' }, component: () => import('../views/manager/Comment.vue') }
    ]
  },
  // 原有的前台路由
  {
    path: '/front',
    name: 'Front',
    component: () => import('../views/Front.vue'),
    children: [
      { path: 'home', name: 'FrontHome', meta: { name: '系统首页' }, component: () => import('../views/front/Home') },
      { path: 'person', name: 'Person', meta: { name: '个人信息' }, component: () => import('../views/front/Person') },
      { path: 'informationDetail', name: 'InformationDetail', meta: { name: '资讯详情' }, component: () => import('../views/front/InformationDetail') },
      { path: 'policyDetail', name: 'PolicyDetail', meta: { name: '政策详情' }, component: () => import('../views/front/PolicyDetail') },
      { path: 'agritainmentDetail', name: 'AgritainmentDetail', meta: { name: '农家乐信息' }, component: () => import('../views/front/AgritainmentDetail.vue') },
      { path: 'orders', name: 'FrontOrders', meta: { name: '订单信息' }, component: () => import('../views/front/Orders') },
      { path: 'apply', name: 'Apply', meta: { name: '贫困户申请' }, component: () => import('../views/front/Apply') },
      { path: 'praise', name: 'Praise', meta: { name: '点赞' }, component: () => import('../views/front/Praise') },
    ]
  },
  { path: '/login', name: 'Login', meta: { name: '登录' }, component: () => import('../views/Login.vue') },
  { path: '/register', name: 'Register', meta: { name: '注册' }, component: () => import('../views/Register.vue') },
  { path: '/404', name: 'NotFound', meta: { name: '页面未找到' }, component: () => import('../views/404.vue') },
  { path: '/:pathMatch(.*)*', redirect: '/404' }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = to.meta.title
  } else if (to.meta.name) {
    document.title = to.meta.name + ' - 扶贫助农系统'
  }
  
  // 认证逻辑
  let user = JSON.parse(localStorage.getItem("xm-user") || '{}');
  
  // 需要认证的路由
  const authRequiredRoutes = ['/manager', '/front']
  const isAuthRequired = authRequiredRoutes.some(route => to.path.startsWith(route))
  
  if (isAuthRequired && !user.id) {
    // 需要登录但未登录，跳转到登录页
    next('/login')
    return
  }
  
  // 管理员访问权限检查
  if (to.path.startsWith('/manager') && user.role !== 'ADMIN') {
    next('/front/home')
    return
  }
  
  // 普通用户访问权限检查  
  if (to.path.startsWith('/front') && user.role !== 'USER' && user.role !== 'ADMIN') {
    next('/manager/home')
    return
  }
  
  next()
})

export default router
