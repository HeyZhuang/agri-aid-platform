<template>
  <div class="main-content">
    <div class="front-card" style="width: 60%; margin: 30px auto; padding: 30px;">
      <div style="text-align: right; margin-bottom: 25px">
        <el-button type="warning" @click="rechargeInit">账户充值</el-button>
        <el-button type="primary" @click="updatePassword">修改密码</el-button>
      </div>
      
      <el-form :model="user" label-width="100px" style="padding: 0 20px;">
        <!-- 头像上传区域 -->
        <div style="margin: 20px 0; text-align: center">
          <el-upload
              class="avatar-uploader"
              :action="$baseUrl + '/files/upload'"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
          >
            <img v-if="user.avatar" :src="user.avatar" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div style="margin-top: 10px; color: #666; font-size: 14px;">
            点击上传头像
          </div>
        </div>

        <!-- 用户信息表单 -->
        <div style="max-width: 500px; margin: 0 auto;">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="user.username" placeholder="用户名" disabled>
              <template #prefix><el-icon><User /></el-icon></template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="姓名" prop="name">
            <el-input v-model="user.name" placeholder="请输入真实姓名">
              <template #prefix><el-icon><Avatar /></el-icon></template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="电话" prop="phone">
            <el-input v-model="user.phone" placeholder="请输入手机号码">
              <template #prefix><el-icon><Phone /></el-icon></template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="user.email" placeholder="请输入邮箱地址">
              <template #prefix><el-icon><Message /></el-icon></template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="身份等级" prop="level">
            <el-input v-model="user.level" disabled placeholder="身份等级">
              <template #prefix><el-icon><Medal /></el-icon></template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="账户余额" prop="account">
            <el-input v-model="user.account" disabled placeholder="账户余额">
              <template #prefix><el-icon><Wallet /></el-icon></template>
              <template #suffix><span style="color: #c3272b; font-weight: 600;">元</span></template>
            </el-input>
          </el-form-item>
        </div>

        <!-- 操作按钮 -->
        <div style="text-align: center; margin-top: 30px">
          <el-button type="primary" size="medium" @click="update">
            <el-icon><Check /></el-icon>
            保存信息
          </el-button>
        </div>
      </el-form>
    </div>

    <!-- 修改密码对话框 -->
    <el-dialog title="修改密码" v-model="dialogVisible" width="35%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="user" label-width="100px" style="padding: 0 20px;" :rules="rules" ref="formRef">
        <el-form-item label="原始密码" prop="password">
          <el-input show-password v-model="user.password" placeholder="请输入原始密码">
            <template #prefix><el-icon><Lock /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input show-password v-model="user.newPassword" placeholder="请输入新密码">
            <template #prefix><el-icon><Key /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input show-password v-model="user.confirmPassword" placeholder="请再次输入新密码">
            <template #prefix><el-icon><Key /></el-icon></template>
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="save">确 定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 充值对话框 -->
    <el-dialog title="账户充值" v-model="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form label-width="100px" style="padding: 0 30px;">
        <el-form-item prop="account" label="充值金额">
          <el-input v-model="account" autocomplete="off" placeholder="请输入充值金额">
            <template #prefix><el-icon><Coin /></el-icon></template>
            <template #suffix><span style="color: #c3272b; font-weight: 600;">元</span></template>
          </el-input>
        </el-form-item>
        <el-form-item prop="type" label="支付方式">
          <el-radio-group v-model="type">
            <el-radio label="支付宝" style="margin-right: 30px;">
              <el-icon style="color: #1677ff;"><Wallet /></el-icon> 支付宝
            </el-radio>
            <el-radio label="微信">
              <el-icon style="color: #07c160;"><ChatDotRound /></el-icon> 微信支付
            </el-radio>
          </el-radio-group>
        </el-form-item>
        
        <!-- 快捷充值金额 -->
        <el-form-item label="快捷选择">
          <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <el-button size="small" @click="account = 100" type="info" plain>100元</el-button>
            <el-button size="small" @click="account = 200" type="info" plain>200元</el-button>
            <el-button size="small" @click="account = 500" type="info" plain>500元</el-button>
            <el-button size="small" @click="account = 1000" type="info" plain>1000元</el-button>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="fromVisible = false">取 消</el-button>
          <el-button type="primary" @click="recharge">确认充值</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { 
  User, 
  Avatar, 
  Phone, 
  Message, 
  Medal, 
  Wallet, 
  Lock, 
  Key, 
  Check, 
  Plus, 
  Coin, 
  ChatDotRound 
} from '@element-plus/icons-vue'

export default {
  name: 'Person',
  components: {
    User,
    Avatar, 
    Phone,
    Message,
    Medal,
    Wallet,
    Lock,
    Key,
    Check,
    Plus,
    Coin,
    ChatDotRound
  },
  data() {
    const validatePassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请确认密码'))
      } else if (value !== this.user.newPassword) {
        callback(new Error('确认密码错误'))
      } else {
        callback()
      }
    }
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      dialogVisible: false,
      fromVisible: false,
      type:'支付宝',
      account: 100,

      rules: {
        password: [
          { required: true, message: '请输入原始密码', trigger: 'blur' },
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { validator: validatePassword, required: true, trigger: 'blur' },
        ],
      }
    }
  },
  created() {
   this.getPerson()
  },

  methods: {
    getPerson() {
      this.$request.get('/user/selectById/' + this.user.id).then(res => {
        if (res.code === '200') {
          this.user = res.data
          localStorage.setItem("xm-user", JSON.stringify(this.user))
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    rechargeInit() {
      console.log('rechargeInit clicked') // 添加调试信息
      this.account = 100
      this.fromVisible = true
      console.log('fromVisible set to:', this.fromVisible) // 调试信息
    },
    recharge() {
      if (!this.account || this.account <= 0) {
        this.$message.warning('请输入正确的充值金额')
        return
      }
      this.user.account = parseFloat(this.user.account) + parseFloat(this.account)
      this.$request.put('/user/update', this.user).then(res => {
        if (res.code === '200') {
          this.$message.success('充值成功')
          localStorage.setItem("xm-user", JSON.stringify(this.user))
          this.fromVisible = false
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    update() {
      // 保存当前的用户信息到数据库
      this.$request.put('/user/update', this.user).then(res => {
        if (res.code === '200') {
          // 成功更新
          this.$message.success('保存成功')
          // 更新浏览器缓存里的用户信息
          localStorage.setItem('xm-user', JSON.stringify(this.user))

          // 触发父级的数据更新
          this.$emit('update:user')
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleAvatarSuccess(response, file, fileList) {
      // 把user的头像属性换成上传的图片的链接
      this.user.avatar = response.data
    },
    // 修改密码
    updatePassword() {
      console.log('updatePassword clicked') // 添加调试信息
      this.user.password = ''
      this.user.newPassword = ''
      this.user.confirmPassword = ''
      this.dialogVisible = true
      console.log('dialogVisible set to:', this.dialogVisible) // 调试信息
    },
    save() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request.put('/updatePassword', this.user).then(res => {
            if (res.code === '200') {
              // 成功更新
              this.$message.success('修改密码成功')
              this.dialogVisible = false
              this.$router.push('/login')
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    }
  }
}
</script>

<style scoped>
/* 表单样式优化 */
::v-deep .el-form-item__label {
  font-weight: 600;
  color: #333;
}

::v-deep .el-upload {
  border-radius: 50%;
}

/* 输入框前缀图标样式 */
::v-deep .el-input__prefix {
  color: #c3272b;
}

/* 单选按钮样式 */
::v-deep .el-radio {
  margin-right: 20px;
  margin-bottom: 10px;
}

::v-deep .el-radio__input.is-checked .el-radio__inner {
  background-color: #c3272b;
  border-color: #c3272b;
}

::v-deep .el-radio__input.is-checked + .el-radio__label {
  color: #c3272b;
}
</style>