<template>
  <div class="container">
    <div class="login-card">
      <div class="login-header">
        <img src="@/assets/imgs/logo.png" alt="Logo" class="login-logo">
        <div class="login-title">中国助农扶贫平台</div>
        <div class="login-subtitle">欢迎回来</div>
      </div>
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="form.role" placeholder="请选择角色" style="width: 100%">
            <el-option label="管理员" value="ADMIN"></el-option>
            <el-option label="用户" value="USER"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" style="width: 100%; margin-bottom: 10px" @click="login" :loading="load">
            登录
          </el-button>
        </el-form-item>
        
        <!-- 添加测试按钮区域 -->
        <div style="margin-top: 20px; text-align: center; border-top: 1px solid #eee; padding-top: 15px;">
          <div style="margin-bottom: 10px; color: #999; font-size: 12px;">快速测试功能</div>
          <el-button size="small" type="warning" @click="testAdminLogin" style="margin-right: 10px;">
            测试管理员登录
          </el-button>
          <el-button size="small" type="primary" @click="testUserLogin">
            测试用户登录
          </el-button>
          <br>
          <el-button size="small" type="info" @click="testPersonPage" style="margin-top: 10px;">
            测试个人中心功能按钮
          </el-button>
          <br>
          <el-button size="small" type="success" @click="testAdminFunctions" style="margin-top: 10px; margin-right: 10px;">
            测试管理员功能按钮
          </el-button>
          <el-button size="small" type="danger" @click="testUserFunctions" style="margin-top: 10px;">
            测试用户申请功能
          </el-button>
        </div>
        
        <p style="margin-top: 20px; text-align: center">
          还没有账号？请先 <a style="color: #409EFF; text-decoration: none" href="/register">注册</a>
        </p>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      form: { role: 'ADMIN' },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ]
      }
    }
  },
  created() {

  },
  methods: {
    login() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.$request.post('/login', this.form).then(res => {
            if (res.code === '200') {
              localStorage.setItem("xm-user", JSON.stringify(res.data))  // 存储用户数据
              if (res.data.role === 'ADMIN') {
                this.$router.push('/manager/home')  // 跳转管理后台
              } else {
                this.$router.push('/front/home')  // 跳转用户中心
              }
              this.$message.success('登录成功')
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    // 添加测试方法
    testAdminLogin() {
      const testAdmin = {
        id: 1,
        name: '测试管理员',
        username: 'admin',
        role: 'ADMIN',
        avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      }
      this.$store.dispatch('login', testAdmin)
      this.$message.success('管理员测试登录成功')
      this.$router.push('/manager/home')
    },
    
    testUserLogin() {
      const testUser = {
        id: 2,
        name: '测试用户',
        username: 'user',
        role: 'USER',
        avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      }
      this.$store.dispatch('login', testUser)
      this.$message.success('用户测试登录成功')
      this.$router.push('/front/home')
    },
    
    // 添加直接测试个人中心的方法
    testPersonPage() {
      const testUser = {
        id: 2,
        name: '测试用户',
        username: 'user',
        role: 'USER',
        account: '1000.00',
        phone: '13800138000',
        email: 'test@example.com',
        level: '普通用户',
        avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      }
      this.$store.dispatch('login', testUser)
      this.$message.success('跳转到个人中心测试功能')
      this.$router.push('/front/person')
    },
    
    // 测试管理员功能按钮
    testAdminFunctions() {
      const testAdmin = {
        id: 1,
        name: '测试管理员',
        username: 'admin',
        role: 'ADMIN',
        token: 'test-token',
        avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      }
      this.$store.dispatch('login', testAdmin)
      this.$message.success('跳转到管理员后台测试功能')
      this.$router.push('/manager/admin')
    },
    
    // 测试用户申请功能
    testUserFunctions() {
      const testUser = {
        id: 2,
        name: '测试用户',
        username: 'user',
        role: 'USER',
        token: 'test-token',
        account: '1000.00',
        phone: '13800138000',
        email: 'test@example.com',
        level: '普通用户',
        avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      }
      this.$store.dispatch('login', testUser)
      this.$message.success('跳转到用户申请页面测试功能')
      this.$router.push('/front/apply')
    }
  }
}
</script>

<style scoped>
.container {
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #c3272b 0%, rgba(195, 39, 43, 0.8) 100%), url("@/assets/imgs/bg.jpg");
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><circle cx="10" cy="10" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="30" cy="10" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="70" cy="10" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="10" r="2" fill="rgba(255,255,255,0.1)"/></svg>') repeat;
  opacity: 0.6;
}

.login-card {
  width: 450px;
  padding: 40px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(248, 243, 230, 0.95) 100%);
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;
}

.login-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #c3272b, #f4d03f, #789262);
  border-radius: 20px 20px 0 0;
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-logo {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  margin-bottom: 15px;
  border: 3px solid #c3272b;
}

.login-title {
  font-size: 24px;
  font-weight: 700;
  color: #c3272b;
  margin-bottom: 8px;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.login-subtitle {
  font-size: 16px;
  color: #789262;
  font-weight: 500;
}

.login-button {
  width: 100%;
  height: 50px;
  background: linear-gradient(135deg, #c3272b 0%, #a8212a 100%);
  border: none;
  color: white;
  font-size: 16px;
  font-weight: 600;
  border-radius: 25px;
  transition: all 0.3s ease;
}

.login-button:hover {
  background: linear-gradient(135deg, #789262 0%, #6b8056 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(195, 39, 43, 0.4);
}

.login-footer {
  text-align: center;
  margin-top: 20px;
}

.register-link {
  color: #666;
}

.register-link a {
  color: #c3272b;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
}

.register-link a:hover {
  color: #789262;
  text-decoration: underline;
}

/* Element UI 覆盖样式 */
:deep(.el-input__inner) {
  height: 45px;
  border-radius: 25px;
  border: 2px solid rgba(195, 39, 43, 0.2);
  transition: all 0.3s ease;
}

:deep(.el-input__inner:focus) {
  border-color: #c3272b;
  box-shadow: 0 0 0 2px rgba(195, 39, 43, 0.2);
}

:deep(.el-select .el-input__inner) {
  height: 45px;
  border-radius: 25px;
}

:deep(.el-form-item__label) {
  color: #333;
  font-weight: 600;
}
</style>