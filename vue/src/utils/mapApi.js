import request from './request.js'

/**
 * 地图相关API接口
 */
export const mapApi = {
  /**
   * 获取扶贫项目地理分布数据
   * @param {Object} params - 筛选参数
   * @param {string} params.year - 年份筛选
   * @param {string} params.category - 项目类型筛选
   * @param {string} params.search - 搜索关键词
   */
  getRegionsData(params = {}) {
    return request.get('/map/regions', {
      params: {
        year: params.year || 'all',
        category: params.category || 'all',
        search: params.search || ''
      }
    })
  },

  /**
   * 获取扶贫统计概览数据
   */
  getStatistics() {
    return request.get('/map/statistics')
  },

  /**
   * 获取项目类型分布数据
   */
  getProjectCategories() {
    return request.get('/map/categories')
  },

  /**
   * 获取热门地区排行
   */
  getHotRegions() {
    return request.get('/map/hot-regions')
  },

  /**
   * 获取最新项目动态
   */
  getRecentProjects() {
    return request.get('/map/recent-projects')
  },

  /**
   * 高级筛选API
   * @param {Object} filters - 高级筛选条件
   */
  filterRegions(filters) {
    return request.post('/map/filter', filters)
  }
}

export default mapApi 