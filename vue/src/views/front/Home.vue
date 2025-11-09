<template>
  <div class="main-content">
    <!-- 主轮播图 -->
    <div class="carousel-container">
      <el-carousel :interval="4000" type="card" height="300px">
        <el-carousel-item v-for="item in carouselData" :key="item">
          <img :src="item" alt="" style="width: 100%; height: 300px; border-radius: 12px">
        </el-carousel-item>
      </el-carousel>
    </div>

    <!-- 主要内容区域 -->
    <div style="width: 85%; margin: 0 auto;">
      <div class="content-section">
        <div style="display: flex; gap: 25px;">
          <!-- 左侧轮播 -->
          <div style="width: 50%;">
            <div class="carousel-container">
              <el-carousel height="330px">
                <el-carousel-item v-for="item in left" :key="item">
                  <img :src="item" alt="" style="width: 100%; height: 330px; object-fit: cover;">
                </el-carousel-item>
              </el-carousel>
            </div>
          </div>
          
          <!-- 右侧标签页 -->
          <div style="width: 50%;">
            <div class="front-tabs">
              <el-tabs v-model="activeName">
                <el-tab-pane label="扶贫资讯" name="first">
                  <div v-for="item in informationData" :key="item.id" class="news-item">
                    <div class="title overflowShow" @click="navTo('/front/informationDetail?id=' + item.id)">
                      {{ item.name }}
                    </div>
                    <div class="time">{{ item.time }}</div>
                  </div>
                </el-tab-pane>
                <el-tab-pane label="扶贫政策" name="second">
                  <div v-for="item in policyData" :key="item.id" class="news-item">
                    <div class="title overflowShow" @click="navTo('/front/policyDetail?id=' + item.id)">
                      {{ item.name }}
                    </div>
                    <div class="time">{{ item.time }}</div>
                  </div>
                </el-tab-pane>
              </el-tabs>
            </div>
          </div>
        </div>
      </div>

      <!-- 农家乐板块 -->
      <div class="content-section">
        <div class="content-section-title">魅力农家乐</div>
        <el-row :gutter="25">
          <el-col :span="8" v-for="item in agritainmentData" :key="item.id" style="margin-bottom: 30px;">
            <div class="front-card">
              <img :src="item.img" alt="" 
                   style="width: 100%; height: 200px; object-fit: cover; cursor: pointer;" 
                   @click="navTo('/front/agritainmentDetail?id=' + item.id)">
              <div style="padding: 20px;">
                <div style="text-align: center; font-size: 18px; font-weight: 600; color: #333;">
                  {{ item.name }}
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 优质农产品板块 -->
      <div class="content-section">
        <div class="content-section-title">优质农产品</div>
        <el-row :gutter="20">
          <el-col :span="4" v-for="item in goodsData" :key="item.id" style="margin-bottom: 25px;">
            <div class="product-card">
              <img :src="item.img" alt="">
              <div class="product-card-content">
                <div class="product-name overflowShow">{{ item.name }}</div>
                <div class="product-price">
                  <span class="price">￥{{ item.price }}</span>
                  <span class="stock">库存 {{ item.num }}</span>
                </div>
                <div style="text-align: center;">
                  <el-button type="warning" size="small" @click="buy(item)" :disabled="item.num === 0">
                    {{ item.num === 0 ? '已售罄' : '立即购买' }}
                  </el-button>
                </div>
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
      carouselData: [
        require('@/assets/imgs/lun-1.png'),
        require('@/assets/imgs/lun-2.png'),
        require('@/assets/imgs/lun-3.png'),
      ],
      left: [
        require('@/assets/imgs/lun-1.png'),
        require('@/assets/imgs/lun-2.png'),
        require('@/assets/imgs/lun-3.png'),
      ],
      informationData: [],
      policyData: [],
      agritainmentData:[],
      goodsData: [],
      activeName: 'first'
    }
  },

  mounted() {
    this.loadInformation()
    this.loadPolicy()
    this.loadAgritainment()
    this.loadGoods()
  },

  methods: {
    buy(goods) {
      if (this.user.role === 'ADMIN') {
        this.$message.warning('您是管理员，不支持该操作')
        return
      }
      let data = {
        goodsId: goods.id,
        userId: this.user.id,
        price: goods.price,
        status: '待发货'
      }
      this.$request.post('/orders/add', data).then(res => {
        if (res.code === '200') {
          this.$message.success('购买成功')
          this.loadGoods()
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    loadPolicy() {
      this.$request.get('/policy/top6').then(res => {
        if (res.code === '200') {
          this.policyData = res.data
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    loadInformation() {
      this.$request.get('/information/top6').then(res => {
        if (res.code === '200') {
          this.informationData = res.data
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    navTo(url) {
      location.href = url
    },
    loadAgritainment() {
      this.$request.get('/agritainment/top6').then(res => {
        if (res.code === '200') {
          this.agritainmentData = res.data
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    loadGoods() {
      this.$request.get('/goods/selectAll').then(res => {
        if (res.code === '200') {
          this.goodsData = res.data
        } else {
          this.$message.error(res.msg)
        }
      })
    },
  },
}
</script>

<style scoped>
.overflowShow {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
