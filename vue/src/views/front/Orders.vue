<template>
  <div class="main-content">
    <div class="content-section">
      <div class="content-section-title">我的订单</div>
      
      <!-- 订单状态筛选 -->
      <div style="margin-bottom: 20px; text-align: center;">
        <el-radio-group v-model="statusFilter" @change="loadOrders">
          <el-radio-button label="">全部订单</el-radio-button>
          <el-radio-button label="待发货">待发货</el-radio-button>
          <el-radio-button label="已发货">已发货</el-radio-button>
          <el-radio-button label="已完成">已完成</el-radio-button>
        </el-radio-group>
      </div>

      <div class="front-table">
        <el-table :data="tableData" stripe style="width: 100%">
          <el-table-column prop="id" label="订单编号" width="100" align="center"></el-table-column>
          <el-table-column prop="goodsName" label="商品名称" show-overflow-tooltip>
            <template v-slot="scope">
              <div style="display: flex; align-items: center;">
                <img v-if="scope.row.goodsImg" :src="scope.row.goodsImg" 
                     style="width: 40px; height: 40px; object-fit: cover; border-radius: 6px; margin-right: 10px;">
                <span>{{ scope.row.goodsName }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="订单金额" width="120" align="center">
            <template v-slot="scope">
              <span style="color: #c3272b; font-weight: 600; font-size: 16px;">
                ￥{{ scope.row.price }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="time" label="下单时间" width="130"></el-table-column>
          <el-table-column prop="status" label="订单状态" width="100" align="center">
            <template v-slot="scope">
              <el-tag :type="getStatusType(scope.row.status)" size="small">
                <i :class="getStatusIcon(scope.row.status)" style="margin-right: 5px;"></i>
                {{ scope.row.status }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200" align="center">
            <template v-slot="scope">
              <el-button plain type="primary" size="small" 
                         v-if="scope.row.status === '已发货'" 
                         @click="changeStatus(scope.row, '已完成')">
                <i class="el-icon-check"></i>
                确认收货
              </el-button>
              <el-button plain type="danger" size="small" 
                         v-if="scope.row.status === '已完成'" 
                         @click="del(scope.row.id)">
                <i class="el-icon-delete"></i>
                删除订单
              </el-button>
              <el-button type="info" size="small" plain 
                         v-if="scope.row.status === '待发货'"
                         disabled>
                <i class="el-icon-time"></i>
                等待发货
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 空状态 -->
        <div v-if="!tableData.length" style="text-align: center; padding: 60px 0; color: #999;">
          <i class="el-icon-box" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
          <div style="font-size: 16px; margin-bottom: 10px;">暂无订单记录</div>
          <div style="font-size: 14px;">快去购买一些农产品吧！</div>
        </div>

        <!-- 分页 -->
        <div style="text-align: center; margin-top: 25px;" v-if="total > 0">
          <el-pagination
              background
              @current-change="handleCurrentChange"
              :current-page="pageNum"
              :page-sizes="[5, 10, 20]"
              :page-size="pageSize"
              layout="total, prev, pager, next"
              :total="total">
          </el-pagination>
        </div>
      </div>

      <!-- 订单统计 -->
      <div style="margin-top: 30px;">
        <el-row :gutter="20">
          <el-col :span="6">
            <div class="order-stat-card">
              <div class="stat-icon" style="background: linear-gradient(135deg, #f4d03f 0%, #f39c12 100%);">
                <i class="el-icon-time"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ statistics.pending || 0 }}</div>
                <div class="stat-label">待发货</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="order-stat-card">
              <div class="stat-icon" style="background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);">
                <i class="el-icon-truck"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ statistics.shipped || 0 }}</div>
                <div class="stat-label">已发货</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="order-stat-card">
              <div class="stat-icon" style="background: linear-gradient(135deg, #27ae60 0%, #229954 100%);">
                <i class="el-icon-check"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ statistics.completed || 0 }}</div>
                <div class="stat-label">已完成</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="order-stat-card">
              <div class="stat-icon" style="background: linear-gradient(135deg, #c3272b 0%, #a8212a 100%);">
                <i class="el-icon-money"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">￥{{ statistics.totalAmount || 0 }}</div>
                <div class="stat-label">总消费</div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      statusFilter: '', // 状态筛选
      statistics: {} // 订单统计
    }
  },

  mounted() {
    this.load(1)
    this.loadStatistics()
  },

  methods: {
    // 获取状态标签类型
    getStatusType(status) {
      const statusMap = {
        '待发货': 'warning',
        '已发货': 'primary', 
        '已完成': 'success'
      }
      return statusMap[status] || 'info'
    },

    // 获取状态图标
    getStatusIcon(status) {
      const iconMap = {
        '待发货': 'el-icon-time',
        '已发货': 'el-icon-truck',
        '已完成': 'el-icon-check'
      }
      return iconMap[status] || 'el-icon-info'
    },

    // 加载订单列表
    load(pageNum) {
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/orders/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          userId: this.user.id,
          status: this.statusFilter
        }
      }).then(res => {
        this.tableData = res.data?.list || []
        this.total = res.data?.total || 0
      })
    },

    // 加载订单统计
    loadStatistics() {
      this.$request.get('/orders/statistics', {
        params: {
          userId: this.user.id
        }
      }).then(res => {
        if (res.code === '200') {
          this.statistics = res.data || {}
        }
      }).catch(() => {
        // 如果后端没有统计接口，手动计算
        this.calculateStatistics()
      })
    },

    // 手动计算统计数据
    calculateStatistics() {
      this.$request.get('/orders/selectAll', {
        params: {
          userId: this.user.id
        }
      }).then(res => {
        const orders = res.data || []
        this.statistics = {
          pending: orders.filter(o => o.status === '待发货').length,
          shipped: orders.filter(o => o.status === '已发货').length,
          completed: orders.filter(o => o.status === '已完成').length,
          totalAmount: orders.reduce((sum, o) => sum + (parseFloat(o.price) || 0), 0).toFixed(2)
        }
      })
    },

    // 筛选订单
    loadOrders() {
      this.load(1)
    },

    // 更改订单状态
    changeStatus(row, status) {
      const actionText = status === '已完成' ? '确认收货' : '更新状态'
      this.$confirm(`确定要${actionText}吗？`, '确认操作', {
        type: 'warning'
      }).then(() => {
        this.$request.put('/orders/update', {
          ...row,
          status: status
        }).then(res => {
          if (res.code === '200') {
            this.$message.success('操作成功')
            this.load(this.pageNum)
            this.loadStatistics()
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {})
    },

    // 删除订单
    del(id) {
      this.$confirm('确定要删除这个订单吗？', '确认删除', {
        type: 'warning'
      }).then(() => {
        this.$request.delete('/orders/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功')
            this.load(this.pageNum)
            this.loadStatistics()
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {})
    },

    // 分页改变
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    }
  }
}
</script>

<style scoped>
/* 状态筛选按钮样式 */
::v-deep .el-radio-button__inner {
  border-radius: 20px !important;
  padding: 8px 20px;
  margin: 0 5px;
  font-weight: 600;
  transition: all 0.3s ease;
}

::v-deep .el-radio-button__orig-radio:checked + .el-radio-button__inner {
  background: linear-gradient(135deg, #c3272b 0%, #a8212a 100%);
  border-color: #c3272b;
  color: #fff;
  box-shadow: 0 4px 15px rgba(195, 39, 43, 0.3);
}

/* 订单统计卡片样式 */
.order-stat-card {
  background: linear-gradient(135deg, #fff 0%, #f8f3e6 100%);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(195, 39, 43, 0.1);
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}

.order-stat-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.stat-icon {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  color: #fff;
  font-size: 24px;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  line-height: 1.2;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-top: 2px;
}

/* 商品图片样式 */
::v-deep .el-table .cell img {
  border: 1px solid rgba(195, 39, 43, 0.1);
}

/* 价格样式 */
.price-cell {
  font-weight: 700;
  color: #c3272b;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .order-stat-card {
    margin-bottom: 15px;
  }
  
  .stat-number {
    font-size: 20px;
  }
  
  .stat-icon {
    width: 40px;
    height: 40px;
    font-size: 20px;
  }
}
</style>