<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入标题查询" style="width: 200px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="primary" plain @click="handleAdd">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe  @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="name" label="政策标题" show-overflow-tooltip></el-table-column>
        <el-table-column prop="content" label="政策内容">
          <template v-slot="scope">
            <el-button type="primary" size="small" @click="viewData(scope.row.content)">点击查看</el-button>
          </template>
        </el-table-column>
        <el-table-column prop="time" label="发布时间"></el-table-column>

        <el-table-column label="操作" width="180" align="center">
          <template v-slot="scope">
            <el-button plain type="primary" @click="handleEdit(scope.row)" size="small">编辑</el-button>
            <el-button plain type="danger" size="small" @click=del(scope.row.id)>删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
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

    <el-dialog title="政策信息" v-model="fromVisible" width="50%" :close-on-click-modal="false" @closed="handleDialogClosed">
      <el-form :model="form" label-width="100px" style="padding-right: 30px" :rules="rules" ref="formRef">
        <el-form-item prop="name" label="标题">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="content" label="内容">
          <div v-if="fromVisible && editorReady" style="border: 1px solid #ccc">
            <Toolbar
              style="border-bottom: 1px solid #ccc"
              :editor="editorRef"
              :defaultConfig="toolbarConfig"
            />
            <Editor
              style="height: 300px; overflow-y: hidden;"
              v-model="form.content"
              :defaultConfig="editorConfig"
              @onCreated="handleCreated"
              @onDestroyed="handleDestroyed"
            />
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleCancel">取 消</el-button>
          <el-button type="primary" @click="save">确 定</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog title="扶贫资讯" v-model="editorVisible" width="50%" :close-on-click-modal="false" destroy-on-close>
      <div v-html="this.viewContent" class="w-e-text"></div>
    </el-dialog>

  </div>
</template>

<script>
import '@wangeditor/editor/dist/css/style.css'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'

export default {
  name: "Policy",
  components: {
    Editor,
    Toolbar
  },
  data() {
    return {
      editorRef: null,
      editorInitialized: false,
      editorReady: false,
      toolbarConfig: {},
      editorConfig: {
        placeholder: '请输入政策内容...',
        MENU_CONF: {
          uploadImage: {
            server: '/api/files/wang/upload',
            fieldName: 'file',
            meta: {
              token: 'xxx',
            },
            metaWithUrl: false,
            headers: {
              Accept: 'text/x-json',
              otherKey: 'xxx',
            },
            allowedFileTypes: ['image/*'],
            onBeforeUpload(file) {
              console.log('onBeforeUpload', file)
              return file
            },
            onProgress(progress) {
              console.log('onProgress', progress)
            },
            onSuccess(file, res) {
              console.log('onSuccess', file, res)
            },
            onFailed(file, res) {
              console.log('onFailed', file, res)
            },
            onError(file, err, res) {
              console.log('onError', file, err, res)
            }
          }
        }
      },
      tableData: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 10,  // 每页显示的个数
      total: 0,
      name: null,
      fromVisible: false,
      editorVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
        name: [
          {required: true, message: '请输入标题', trigger: 'blur'},
        ]
      },
      ids: [],
      viewContent: null
    }
  },
  created() {
    this.load(1)
  },
  beforeUnmount() {
    this.destroyEditor()
  },
  watch: {
    fromVisible(newVal) {
      if (newVal) {
        // 对话框打开时，延迟初始化编辑器
        this.$nextTick(() => {
          this.editorReady = true
        })
      } else {
        // 对话框关闭时，立即清理编辑器
        this.editorReady = false
        this.destroyEditor()
      }
    }
  },
  methods: {
    handleCreated(editor) {
      console.log('Editor created:', editor)
      this.editorRef = editor
      this.editorInitialized = true
    },
    
    handleDestroyed() {
      console.log('Editor destroyed')
      this.editorRef = null
      this.editorInitialized = false
    },
    
    destroyEditor() {
      if (this.editorRef && this.editorInitialized) {
        try {
          console.log('Manually destroying editor...')
          this.editorRef.destroy()
        } catch (error) {
          console.warn('Error destroying editor:', error)
        } finally {
          this.editorRef = null
          this.editorInitialized = false
        }
      }
    },
    
    handleDialogClosed() {
      // 对话框完全关闭后的清理工作
      console.log('Dialog closed, cleaning up...')
      this.editorReady = false
      this.destroyEditor()
    },
    
    handleCancel() {
      this.fromVisible = false
    },
    
    viewData(content) {
      this.viewContent = content
      this.editorVisible = true
    },
    handleAdd() {   // 新增数据
      this.form = { content: '' }  // 新增数据的时候清空数据
      this.fromVisible = true   // 打开弹窗
    },
    handleEdit(row) {   // 编辑数据
      this.form = JSON.parse(JSON.stringify(row))  // 给form对象赋值  注意要深拷贝数据
      this.form.content = this.form.content || ''  // 确保content字段存在
      this.fromVisible = true   // 打开弹窗
    },
    save() {   // 保存按钮触发的逻辑  它会触发新增或者更新
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          // 新版本wangeditor通过v-model自动绑定数据，无需手动获取
          this.$request({
            url: this.form.id ? '/policy/update' : '/policy/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {  // 表示成功保存
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)  // 弹出错误的信息
            }
          })
        }
      })
    },
    del(id) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/policy/delete/' + id).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {   // 当前选中的所有的行数据
      this.ids = rows.map(v => v.id)   //  [1,2]
    },
    delBatch() {   // 批量删除
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/policy/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/policy/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data?.list
        this.total = res.data?.total
      })
    },
    reset() {
      this.name = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    }
  }
}
</script>

<style scoped>

</style>
