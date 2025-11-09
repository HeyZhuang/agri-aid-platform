export const dashboardData = {
  // 总体统计数据
  totalStats: {
    farmers: 12845,
    farmersGrowth: 12,
    sales: 2.3e8,
    salesGrowth: 25,
    products: 1250,
    productsGrowth: 8,
    counties: 832,
    countiesGrowth: 15
  },
  
  // 热门产品
  topProducts: [
    { name: "普洱茶", sales: 25680, growth: 18 },
    { name: "赣南脐橙", sales: 18950, growth: 32 },
    { name: "五常大米", sales: 15620, growth: 12 },
    { name: "宁夏枸杞", sales: 12340, growth: 28 },
    { name: "新疆和田枣", sales: 9850, growth: 15 }
  ],
  
  // 地区分布数据
  regionData: {
    "云南": { farmers: 1560, sales: 3200, growth: 18 },
    "四川": { farmers: 1280, sales: 2800, growth: 22 },
    "甘肃": { farmers: 980, sales: 1900, growth: 15 },
    "贵州": { farmers: 1120, sales: 2400, growth: 20 },
    "新疆": { farmers: 850, sales: 1800, growth: 25 },
    "广西": { farmers: 760, sales: 1600, growth: 12 },
    "江西": { farmers: 920, sales: 2100, growth: 28 },
    "湖南": { farmers: 680, sales: 1400, growth: 16 },
    "西藏": { farmers: 320, sales: 800, growth: 35 },
    "内蒙古": { farmers: 540, sales: 1300, growth: 18 }
  },
  
  // 月度销售趋势
  monthlyTrend: [
    { month: "1月", sales: 1500, orders: 520 },
    { month: "2月", sales: 1200, orders: 480 },
    { month: "3月", sales: 1800, orders: 650 },
    { month: "4月", sales: 2100, orders: 720 },
    { month: "5月", sales: 2500, orders: 850 },
    { month: "6月", sales: 2800, orders: 920 },
    { month: "7月", sales: 3200, orders: 1050 },
    { month: "8月", sales: 3600, orders: 1180 },
    { month: "9月", sales: 3400, orders: 1120 },
    { month: "10月", sales: 3800, orders: 1250 },
    { month: "11月", sales: 4200, orders: 1380 },
    { month: "12月", sales: 4500, orders: 1450 }
  ],
  
  // 产品分类数据
  categoryData: [
    { name: "茶叶", value: 285, percentage: 22.8 },
    { name: "水果", value: 320, percentage: 25.6 },
    { name: "粮食", value: 180, percentage: 14.4 },
    { name: "干果", value: 150, percentage: 12.0 },
    { name: "调料", value: 125, percentage: 10.0 },
    { name: "肉类", value: 95, percentage: 7.6 },
    { name: "其他", value: 95, percentage: 7.6 }
  ],
  
  // 扶贫成效数据
  povertyAlleviationData: {
    totalHouseholds: 48520,
    liftedHouseholds: 46380,
    liftedPercentage: 95.6,
    averageIncome: 8650,
    incomeGrowth: 185,
    jobsCreated: 15680,
    cooperatives: 1250,
    beneficiaries: 125000
  },
  
  // 实时数据
  realtimeData: {
    onlineUsers: 2580,
    todayOrders: 156,
    todaySales: 28500,
    activeProducts: 1180,
    lastUpdated: new Date().toISOString()
  },
  
  // 成功案例统计
  successStories: {
    totalStories: 1250,
    industrialPoverty: 680,
    educationPoverty: 280,
    healthPoverty: 180,
    tourismPoverty: 110
  }
}

export default dashboardData 