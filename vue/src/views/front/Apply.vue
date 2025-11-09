<template>
  <div class="main-content">
    <div class="front-tabs">
      <el-tabs v-model="activeName" type="border-card">
        <!-- 贫困户申请 -->
        <el-tab-pane label="贫困户申请" name="first">
          <div style="margin: 20px 0; text-align: center;">
            <el-button type="primary" size="small" plain @click="handlePoorAdd()">
              <i class="el-icon-plus"></i>
              提交新申请
            </el-button>
          </div>
          
          <div class="front-table">
            <el-table :data="poorApplyData" stripe style="width: 100%">
              <el-table-column prop="id" label="申请编号" width="100" align="center"></el-table-column>
              <el-table-column prop="name" label="申请人姓名" show-overflow-tooltip></el-table-column>
              <el-table-column prop="reason" label="申请原因" show-overflow-tooltip></el-table-column>
              <el-table-column prop="time" label="申请时间" width="130"></el-table-column>
              <el-table-column prop="status" label="审核状态" width="100" align="center">
                <template v-slot="scope">
                  <el-tag :type="getStatusType(scope.row.status)" size="small">
                    {{ scope.row.status }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="file" label="申请资料" width="120" align="center">
                <template v-slot="scope">
                  <el-button type="warning" size="small" @click="downPoor(scope.row.file)">
                    <i class="el-icon-download"></i>
                    下载
                  </el-button>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="200" align="center">
                <template v-slot="scope">
                  <el-button plain type="primary" size="small" 
                             v-if="scope.row.status !== '审核通过'" 
                             @click="handlePoorEdit(scope.row)">
                    <i class="el-icon-edit"></i>
                    编辑
                  </el-button>
                  <el-button plain type="danger" size="small" 
                             v-if="scope.row.status !== '审核通过'" 
                             @click="delPoor(scope.row.id)">
                    <i class="el-icon-delete"></i>
                    撤销
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div style="text-align: center; margin-top: 20px;">
              <el-pagination
                  background
                  @current-change="loadPoorApply"
                  :current-page="pageNum"
                  :page-sizes="[5, 10, 20]"
                  :page-size="pageSize"
                  layout="total, prev, pager, next"
                  :total="total">
              </el-pagination>
            </div>
          </div>
        </el-tab-pane>

        <!-- 扶贫项目申请 -->
        <el-tab-pane label="扶贫项目申请" name="second">
          <div style="margin: 20px 0; text-align: center;">
            <el-button type="primary" size="small" plain @click="handleProjectAdd()">
              <i class="el-icon-plus"></i>
              提交新申请
            </el-button>
          </div>
          
          <div class="front-table">
            <el-table :data="projectApplyData" stripe style="width: 100%">
              <el-table-column prop="id" label="申请编号" width="100" align="center"></el-table-column>
              <el-table-column prop="name" label="项目名称" show-overflow-tooltip></el-table-column>
              <el-table-column prop="reason" label="申请原因" show-overflow-tooltip></el-table-column>
              <el-table-column prop="time" label="申请时间" width="130"></el-table-column>
              <el-table-column prop="status" label="审核状态" width="100" align="center">
                <template v-slot="scope">
                  <el-tag :type="getStatusType(scope.row.status)" size="small">
                    {{ scope.row.status }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="file" label="申请资料" width="120" align="center">
                <template v-slot="scope">
                  <el-button type="warning" size="small" @click="downProject(scope.row.file)">
                    <i class="el-icon-download"></i>
                    下载
                  </el-button>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="200" align="center">
                <template v-slot="scope">
                  <el-button plain type="primary" size="small" 
                             v-if="scope.row.status !== '审核通过'" 
                             @click="handleProjectEdit(scope.row)">
                    <i class="el-icon-edit"></i>
                    编辑
                  </el-button>
                  <el-button plain type="danger" size="small" 
                             v-if="scope.row.status !== '审核通过'" 
                             @click="delProject(scope.row.id)">
                    <i class="el-icon-delete"></i>
                    撤销
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div style="text-align: center; margin-top: 20px;">
              <el-pagination
                  background
                  @current-change="loadProjectApply"
                  :current-page="pageNum"
                  :page-sizes="[5, 10, 20]"
                  :page-size="pageSize"
                  layout="total, prev, pager, next"
                  :total="total">
              </el-pagination>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 贫困户申请对话框 -->
    <el-dialog title="贫困户申请" v-model="poorVisible" width="50%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="poorForm" label-width="100px" style="padding: 0 20px;" :rules="rules" ref="poorFormRef">
        <el-form-item prop="name" label="申请人姓名">
          <el-input v-model="poorForm.name" placeholder="请输入申请人姓名">
            <template #prefix><el-icon><User /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item prop="reason" label="申请原因">
          <el-input type="textarea" :rows="4" v-model="poorForm.reason" placeholder="请详细说明申请原因"></el-input>
        </el-form-item>
        <el-form-item label="申请资料">
          <el-upload
              class="upload-demo"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              :on-success="handlePoorSuccess"
              :before-upload="beforeUpload"
              :limit="1"
              accept=".pdf,.doc,.docx,.jpg,.png">
            <el-button size="small" type="primary">
              <el-icon><Upload /></el-icon>
              点击上传资料
            </el-button>
            <template #tip>
              <div class="el-upload__tip" style="color: #999; font-size: 12px;">
                支持PDF、Word文档、图片格式，文件大小不超过10MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
              <template #footer>
          <div class="dialog-footer">
            <el-button @click="poorVisible = false">取 消</el-button>
            <el-button type="primary" @click="savePoor">确 定</el-button>
          </div>
        </template>
    </el-dialog>

    <!-- 扶贫项目申请对话框 -->
    <el-dialog title="扶贫项目申请" v-model="projectVisible" width="50%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="projectForm" label-width="100px" style="padding: 0 20px;" :rules="rules" ref="projectFormRef">
        <el-form-item prop="name" label="项目名称">
          <el-input v-model="projectForm.name" placeholder="请输入项目名称">
            <template #prefix><el-icon><Grid /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item prop="reason" label="申请原因">
          <el-input type="textarea" :rows="4" v-model="projectForm.reason" placeholder="请详细说明申请原因"></el-input>
        </el-form-item>
        <el-form-item label="申请资料">
          <el-upload
              class="upload-demo"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              :on-success="handleProjectSuccess"
              :before-upload="beforeUpload"
              :limit="1"
              accept=".pdf,.doc,.docx,.jpg,.png">
            <el-button size="small" type="primary">
              <el-icon><Upload /></el-icon>
              点击上传资料
            </el-button>
            <template #tip>
              <div class="el-upload__tip" style="color: #999; font-size: 12px;">
                支持PDF、Word文档、图片格式，文件大小不超过10MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
              <template #footer>
          <div class="dialog-footer">
            <el-button @click="projectVisible = false">取 消</el-button>
            <el-button type="primary" @click="saveProject">确 定</el-button>
          </div>
        </template>
    </el-dialog>
  </div>
</template>

<script>
import { User, Grid, Upload } from '@element-plus/icons-vue'

export default {
  components: {
    User,
    Grid,
    Upload
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      activeName: 'first',
      poorApplyData: [],
      projectApplyData: [],
      poorVisible: false,
      projectVisible: false,
      poorForm: {},
      projectForm: {},
      pageNum: 1,
      pageSize: 10,
      total: 0,
      rules: {
        name: [
          { required: true, message: '请输入名称', trigger: 'blur' }
        ],
        reason: [
          { required: true, message: '请输入申请原因', trigger: 'blur' },
          { min: 10, message: '申请原因不能少于10个字符', trigger: 'blur' }
        ]
      }
    }
  },

  mounted() {
    this.loadPoorApply(1)
    this.loadProjectApply(1)
  },

  methods: {
    // 获取状态标签类型
    getStatusType(status) {
      const statusMap = {
        '待审核': 'warning',
        '审核通过': 'success',
        '审核不通过': 'danger'
      }
      return statusMap[status] || 'info'
    },

    // 文件上传前验证
    beforeUpload(file) {
      const isValidType = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/png'].includes(file.type)
      const isValidSize = file.size / 1024 / 1024 < 10

      if (!isValidType) {
        this.$message.error('上传文件只能是PDF、Word或图片格式!')
        return false
      }
      if (!isValidSize) {
        this.$message.error('上传文件大小不能超过10MB!')
        return false
      }
      return true
    },

    // 贫困户申请相关方法
    loadPoorApply(pageNum) {
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/poorapply/selectByUserId', {
        params: {
          userId: this.user.id,
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        this.poorApplyData = res.data?.list || []
        this.total = res.data?.total || 0
      })
    },

    handlePoorAdd() {
      this.poorForm = {}
      this.poorVisible = true
    },

    handlePoorEdit(row) {
      this.poorForm = JSON.parse(JSON.stringify(row))
      this.poorVisible = true
    },

    handlePoorSuccess(response) {
      this.poorForm.file = response.data
      this.$message.success('文件上传成功')
    },

    savePoor() {
      this.$refs.poorFormRef.validate((valid) => {
        if (valid) {
          this.poorForm.userId = this.user.id
          this.poorForm.status = '待审核'
          const url = this.poorForm.id ? '/poorapply/update' : '/poorapply/add'
          const method = this.poorForm.id ? 'PUT' : 'POST'
          
          this.$request({
            url,
            method,
            data: this.poorForm
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功')
              this.poorVisible = false
              this.loadPoorApply(1)
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },

    delPoor(id) {
      this.$confirm('确定要撤销这个申请吗？', '确认撤销', {
        type: 'warning'
      }).then(() => {
        this.$request.delete('/poorapply/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('撤销成功')
            this.loadPoorApply(1)
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {})
    },

    downPoor(file) {
      if (file) {
        window.open(this.$baseUrl + '/files/download/' + file)
      } else {
        this.$message.warning('暂无文件')
      }
    },

    // 扶贫项目申请相关方法
    loadProjectApply(pageNum) {
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/projectapply/selectByUserId', {
        params: {
          userId: this.user.id,
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        this.projectApplyData = res.data?.list || []
        this.total = res.data?.total || 0
      })
    },

    handleProjectAdd() {
      this.projectForm = {}
      this.projectVisible = true
    },

    handleProjectEdit(row) {
      this.projectForm = JSON.parse(JSON.stringify(row))
      this.projectVisible = true
    },

    handleProjectSuccess(response) {
      this.projectForm.file = response.data
      this.$message.success('文件上传成功')
    },

    saveProject() {
      this.$refs.projectFormRef.validate((valid) => {
        if (valid) {
          this.projectForm.userId = this.user.id
          this.projectForm.status = '待审核'
          const url = this.projectForm.id ? '/projectapply/update' : '/projectapply/add'
          const method = this.projectForm.id ? 'PUT' : 'POST'
          
          this.$request({
            url,
            method,
            data: this.projectForm
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功')
              this.projectVisible = false
              this.loadProjectApply(1)
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },

    delProject(id) {
      this.$confirm('确定要撤销这个申请吗？', '确认撤销', {
        type: 'warning'
      }).then(() => {
        this.$request.delete('/projectapply/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('撤销成功')
            this.loadProjectApply(1)
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {})
    },

    downProject(file) {
      if (file) {
        window.open(this.$baseUrl + '/files/download/' + file)
      } else {
        this.$message.warning('暂无文件')
      }
    }
  }
}
</script>

<style scoped>
/* 输入框前缀图标样式 */
::v-deep .el-input__prefix {
  color: #c3272b;
}

/* 上传组件样式 */
::v-deep .el-upload-dragger {
  border: 2px dashed rgba(195, 39, 43, 0.3);
  border-radius: 8px;
}

::v-deep .el-upload-dragger:hover {
  border-color: #c3272b;
}

/* 标签页样式 */
::v-deep .el-tabs--border-card {
  border: 1px solid rgba(195, 39, 43, 0.1);
  border-radius: 12px;
  overflow: hidden;
}

::v-deep .el-tabs--border-card .el-tabs__header {
  background: linear-gradient(135deg, #c3272b 0%, #a8212a 100%);
}

::v-deep .el-tabs--border-card .el-tabs__item {
  color: rgba(255, 255, 255, 0.8);
  font-weight: 600;
}

::v-deep .el-tabs--border-card .el-tabs__item.is-active {
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
}
</style>