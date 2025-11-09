<template>
  <div 
    ref="container" 
    class="relative w-full h-96 bg-gradient-to-br from-chinese-beige to-chinese-light rounded-xl overflow-hidden shadow-2xl"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
  >
    <!-- Loading状态 -->
    <div 
      v-if="loading" 
      class="absolute inset-0 flex items-center justify-center bg-gradient-to-br from-black/30 to-black/10 backdrop-blur-sm"
    >
      <div class="text-center">
        <div class="relative">
          <div class="animate-spin rounded-full h-16 w-16 border-4 border-chinese-red border-t-transparent mx-auto mb-4"></div>
          <div class="absolute inset-0 animate-pulse rounded-full h-16 w-16 border-4 border-chinese-green border-opacity-30 mx-auto"></div>
        </div>
        <p class="text-white font-chinese text-lg font-semibold drop-shadow-lg">加载3D模型中...</p>
        <div class="mt-2 text-white/80 text-sm">{{ loadingProgress }}%</div>
      </div>
    </div>
    
    <!-- 错误状态 -->
    <div 
      v-if="error" 
      class="absolute inset-0 flex items-center justify-center bg-gradient-to-br from-red-50 to-red-100"
    >
      <div class="text-center">
        <div class="text-red-500 text-6xl mb-4 animate-bounce">⚠️</div>
        <p class="text-red-600 font-chinese font-semibold">{{ error }}</p>
        <button 
          @click="retryLoad" 
          class="mt-4 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors"
        >
          重新加载
        </button>
      </div>
    </div>
    
    <!-- 高级控制面板 -->
    <div 
      v-if="!loading && !error" 
      class="absolute top-4 right-4 bg-white/95 backdrop-blur-md rounded-xl p-3 shadow-xl border border-white/20"
    >
      <div class="grid grid-cols-2 gap-2">
        <button 
          @click="resetView" 
          class="p-3 text-chinese-dark hover:bg-chinese-beige rounded-lg transition-all transform hover:scale-105 active:scale-95"
          title="重置视角"
        >
          <div class="text-lg">🔄</div>
        </button>
        <button 
          @click="toggleAutoRotate" 
          class="p-3 text-chinese-dark hover:bg-chinese-beige rounded-lg transition-all transform hover:scale-105 active:scale-95"
          title="自动旋转"
        >
          <div class="text-lg">{{ autoRotate ? '⏸️' : '▶️' }}</div>
        </button>
        <button 
          @click="toggleWireframe" 
          class="p-3 text-chinese-dark hover:bg-chinese-beige rounded-lg transition-all transform hover:scale-105 active:scale-95"
          title="线框模式"
        >
          <div class="text-lg">📐</div>
        </button>
        <button 
          @click="toggleEnvironment" 
          class="p-3 text-chinese-dark hover:bg-chinese-beige rounded-lg transition-all transform hover:scale-105 active:scale-95"
          title="环境效果"
        >
          <div class="text-lg">🌟</div>
        </button>
      </div>
      
      <!-- 光照控制 -->
      <div class="mt-3 pt-3 border-t border-gray-200">
        <div class="text-xs text-gray-600 mb-2 font-medium">光照强度</div>
        <input 
          type="range" 
          min="0.1" 
          max="2" 
          step="0.1" 
          v-model="lightIntensity"
          @input="updateLighting"
          class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
        >
      </div>
    </div>
    
    <!-- 信息面板 -->
    <div 
      v-if="!loading && !error && modelInfo" 
      class="absolute bottom-4 left-4 bg-white/95 backdrop-blur-md rounded-xl p-4 shadow-xl border border-white/20 max-w-xs"
    >
      <div class="flex items-start space-x-3">
        <div class="text-2xl">{{ modelInfo.icon }}</div>
        <div>
          <h3 class="font-chinese font-bold text-chinese-dark mb-1 text-lg">{{ modelInfo.name }}</h3>
          <p class="text-sm text-chinese-dark/80 leading-relaxed">{{ modelInfo.description }}</p>
          <div class="mt-2 flex items-center space-x-4 text-xs text-chinese-dark/60">
            <span>🏷️ {{ modelInfo.category }}</span>
            <span>📍 {{ modelInfo.origin }}</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 性能统计 -->
    <div 
      v-if="showStats && !loading && !error" 
      class="absolute top-4 left-4 bg-black/80 text-white text-xs p-2 rounded-lg font-mono"
    >
      <div>FPS: {{ fps }}</div>
      <div>三角形: {{ triangles }}</div>
      <div>材质: {{ materials }}</div>
    </div>
    
    <!-- 交互提示 -->
    <div 
      v-if="!loading && !error && !hasInteracted" 
      class="absolute inset-0 flex items-center justify-center pointer-events-none"
    >
      <div class="bg-black/60 text-white px-6 py-3 rounded-xl backdrop-blur-sm animate-pulse">
        <div class="text-center">
          <div class="text-2xl mb-2">🖱️</div>
          <div class="font-chinese">拖拽旋转 • 滚轮缩放</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, computed } from 'vue'
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader.js'
import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js'
import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js'
import { UnrealBloomPass } from 'three/examples/jsm/postprocessing/UnrealBloomPass.js'
import { SAOPass } from 'three/examples/jsm/postprocessing/SAOPass.js'
import { SSRPass } from 'three/examples/jsm/postprocessing/SSRPass.js'
import { SMAAPass } from 'three/examples/jsm/postprocessing/SMAAPass.js'
import * as BufferGeometryUtils from 'three/examples/jsm/utils/BufferGeometryUtils.js'

// Props
const props = defineProps({
  modelName: {
    type: String,
    required: true
  },
  autoRotate: {
    type: Boolean,
    default: true
  },
  showControls: {
    type: Boolean,
    default: true
  },
  enablePostProcessing: {
    type: Boolean,
    default: true
  },
  enableParticles: {
    type: Boolean,
    default: true
  }
})

// 响应式数据
const container = ref(null)
const loading = ref(true)
const error = ref(null)
const loadingProgress = ref(0)
const autoRotate = ref(props.autoRotate)
const lightIntensity = ref(1.0)
const showStats = ref(false)
const hasInteracted = ref(false)
const fps = ref(0)
const triangles = ref(0)
const materials = ref(0)

// Three.js相关变量
let scene, camera, renderer, controls, mixer, clock
let currentModel = null
let animationId = null
let composer, bloomPass, saoPass, smaaPass
let environmentMap = null
let particleSystem = null
let lights = {}

// 模型信息
const modelInfo = ref(null)

// 高级模型配置
const modelConfigs = {
  tea: {
    name: '有机茶叶',
    description: '高山云雾茶，经传统工艺精心制作，茶香浓郁，回甘甘甜',
    category: '茶叶',
    origin: '福建武夷山',
    icon: '🍃',
    scale: 1,
    position: [0, 0, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.5
    },
    particles: {
      type: 'leaves',
      count: 50,
      color: '#8fbc8f'
    },
    lighting: {
      intensity: 1.2,
      color: '#f4f1de'
    }
  },
  apple: {
    name: '红富士苹果',
    description: '山东烟台优质红富士，果肉脆嫩多汁，甜度适中，营养丰富',
    category: '水果',
    origin: '山东烟台',
    icon: '🍎',
    scale: 1.2,
    position: [0, -0.5, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.3,
      bounce: true
    },
    particles: {
      type: 'sparkles',
      count: 30,
      color: '#ff6b6b'
    },
    lighting: {
      intensity: 1.1,
      color: '#ffe8e8'
    }
  },
  rice: {
    name: '五常大米',
    description: '黑龙江五常优质大米，颗粒饱满晶莹，米香浓郁，营养价值高',
    category: '粮食',
    origin: '黑龙江五常',
    icon: '🌾',
    scale: 0.8,
    position: [0, -0.3, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: false,
      rotationSpeed: 0.4
    },
    particles: {
      type: 'grains',
      count: 80,
      color: '#f9e79f'
    },
    lighting: {
      intensity: 1.0,
      color: '#fff8dc'
    }
  },
  corn: {
    name: '甜玉米',
    description: '东北优质甜玉米，籽粒饱满，甜度高，营养丰富',
    category: '粮食',
    origin: '东北平原',
    icon: '🌽',
    scale: 1.1,
    position: [0, -0.2, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.3,
      sway: true
    },
    particles: {
      type: 'pollen',
      count: 60,
      color: '#FFD700'
    },
    lighting: {
      intensity: 1.3,
      color: '#fff8dc'
    }
  },
  potato: {
    name: '马铃薯',
    description: '内蒙古优质马铃薯，淀粉含量高，口感绵密香甜',
    category: '蔬菜',
    origin: '内蒙古',
    icon: '🥔',
    scale: 0.9,
    position: [0, -0.4, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: false,
      rotationSpeed: 0.2
    },
    particles: {
      type: 'earth',
      count: 40,
      color: '#8B4513'
    },
    lighting: {
      intensity: 1.0,
      color: '#f5f5dc'
    }
  },
  grape: {
    name: '新疆葡萄',
    description: '新疆吐鲁番优质葡萄，果粒饱满，甜度极高，天然无污染',
    category: '水果',
    origin: '新疆吐鲁番',
    icon: '🍇',
    scale: 1.0,
    position: [0, 0.2, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.4,
      cluster: true
    },
    particles: {
      type: 'dewdrops',
      count: 25,
      color: '#9370DB'
    },
    lighting: {
      intensity: 1.2,
      color: '#e6e6fa'
    }
  },
  mushroom: {
    name: '野生菌菇',
    description: '云南深山野生菌菇，营养价值极高，味道鲜美',
    category: '菌菇',
    origin: '云南山区',
    icon: '🍄',
    scale: 0.8,
    position: [0, -0.5, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: false,
      rotationSpeed: 0.1,
      pulse: true
    },
    particles: {
      type: 'spores',
      count: 35,
      color: '#8B4513'
    },
    lighting: {
      intensity: 0.9,
      color: '#f0e68c'
    }
  },
  honey: {
    name: '天然蜂蜜',
    description: '深山野花蜂蜜，纯天然无添加，营养丰富，香甜可口',
    category: '蜂产品',
    origin: '秦岭深山',
    icon: '🍯',
    scale: 0.7,
    position: [0, -0.1, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.6,
      golden: true
    },
    particles: {
      type: 'honey',
      count: 45,
      color: '#FFD700'
    },
    lighting: {
      intensity: 1.5,
      color: '#ffd700'
    }
  },
  fish: {
    name: '野生鱼类',
    description: '清澈湖水中的野生鱼类，肉质鲜美，营养价值高',
    category: '水产',
    origin: '千岛湖',
    icon: '🐟',
    scale: 1.1,
    position: [0, 0, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.8,
      swimming: true
    },
    particles: {
      type: 'bubbles',
      count: 50,
      color: '#87CEEB'
    },
    lighting: {
      intensity: 1.1,
      color: '#e0f6ff'
    }
  },
  default: {
    name: '优质农产品',
    description: '精选优质农产品，绿色健康，品质保证',
    category: '农产品',
    origin: '全国精选',
    icon: '🌱',
    scale: 1,
    position: [0, 0, 0],
    rotation: [0, 0, 0],
    animation: {
      floating: true,
      rotationSpeed: 0.2
    },
    particles: {
      type: 'sparkles',
      count: 40,
      color: '#90EE90'
    },
    lighting: {
      intensity: 1.0,
      color: '#ffffff'
    }
  }
}

// 高级场景初始化
const initScene = async () => {
  // 创建场景
  scene = new THREE.Scene()
  
  // 创建相机
  camera = new THREE.PerspectiveCamera(
    45,
    container.value.clientWidth / container.value.clientHeight,
    0.1,
    1000
  )
  camera.position.set(0, 0, 5)
  
  // 创建高级渲染器
  renderer = new THREE.WebGLRenderer({ 
    antialias: true, 
    alpha: true,
    powerPreference: "high-performance"
  })
  renderer.setSize(container.value.clientWidth, container.value.clientHeight)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  
  // 高级渲染设置
  renderer.shadowMap.enabled = true
  renderer.shadowMap.type = THREE.PCFSoftShadowMap
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.2
  renderer.outputColorSpace = THREE.SRGBColorSpace
  
  // 启用物理正确光照
  renderer.physicallyCorrectLights = true
  
  container.value.appendChild(renderer.domElement)
  
  // 添加高级控制器
  if (props.showControls) {
    controls = new OrbitControls(camera, renderer.domElement)
    controls.enableDamping = true
    controls.dampingFactor = 0.05
    controls.enableZoom = true
    controls.autoRotate = autoRotate.value
    controls.autoRotateSpeed = 1
    controls.minDistance = 2
    controls.maxDistance = 10
    controls.maxPolarAngle = Math.PI * 0.8
    
    // 添加交互事件
    controls.addEventListener('start', () => {
      hasInteracted.value = true
    })
  }
  
  // 加载环境贴图
  await loadEnvironmentMap()
  
  // 创建高级光照系统
  setupAdvancedLighting()
  
  // 创建后期处理
  if (props.enablePostProcessing) {
    setupPostProcessing()
  }
  
  // 创建时钟
  clock = new THREE.Clock()
  
  // 开始渲染循环
  animate()
}

// 加载环境贴图
const loadEnvironmentMap = async () => {
  try {
    const rgbeLoader = new RGBELoader()
    // 创建一个简单的环境贴图
    const pmremGenerator = new THREE.PMREMGenerator(renderer)
    
    // 创建渐变天空盒
    const skyGeometry = new THREE.SphereGeometry(500, 32, 32)
    const skyMaterial = new THREE.ShaderMaterial({
      uniforms: {
        topColor: { value: new THREE.Color(0x87CEEB) },
        bottomColor: { value: new THREE.Color(0xfff8dc) },
        offset: { value: 0.2 },
        exponent: { value: 0.6 }
      },
      vertexShader: `
        varying vec3 vWorldPosition;
        void main() {
          vec4 worldPosition = modelMatrix * vec4(position, 1.0);
          vWorldPosition = worldPosition.xyz;
          gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
        }
      `,
      fragmentShader: `
        uniform vec3 topColor;
        uniform vec3 bottomColor;
        uniform float offset;
        uniform float exponent;
        varying vec3 vWorldPosition;
        void main() {
          float h = normalize(vWorldPosition + offset).y;
          gl_FragColor = vec4(mix(bottomColor, topColor, max(pow(max(h, 0.0), exponent), 0.0)), 1.0);
        }
      `,
      side: THREE.BackSide
    })
    
    const sky = new THREE.Mesh(skyGeometry, skyMaterial)
    scene.add(sky)
    
    // 设置环境贴图
    const envMap = pmremGenerator.fromScene(scene).texture
    scene.environment = envMap
    scene.background = envMap
    
    pmremGenerator.dispose()
  } catch (error) {
    console.warn('Environment map loading failed, using fallback')
    scene.background = new THREE.Color(0xf8f3e6)
  }
}

// 高级光照系统
const setupAdvancedLighting = () => {
  // 环境光
  lights.ambient = new THREE.AmbientLight(0xffffff, 0.3)
  scene.add(lights.ambient)
  
  // 主光源 - 太阳光
  lights.main = new THREE.DirectionalLight(0xfff8dc, 1.5)
  lights.main.position.set(10, 15, 5)
  lights.main.castShadow = true
  lights.main.shadow.mapSize.width = 2048
  lights.main.shadow.mapSize.height = 2048
  lights.main.shadow.camera.near = 0.1
  lights.main.shadow.camera.far = 50
  lights.main.shadow.camera.left = -10
  lights.main.shadow.camera.right = 10
  lights.main.shadow.camera.top = 10
  lights.main.shadow.camera.bottom = -10
  lights.main.shadow.bias = -0.0001
  scene.add(lights.main)
  
  // 补光 - 天空光
  lights.sky = new THREE.HemisphereLight(0x87CEEB, 0x8B4513, 0.6)
  scene.add(lights.sky)
  
  // 边缘光
  lights.rim = new THREE.DirectionalLight(0xffffff, 0.8)
  lights.rim.position.set(-5, 2, -5)
  scene.add(lights.rim)
  
  // 动态点光源
  lights.accent = new THREE.PointLight(0xffeb3b, 0.5, 10)
  lights.accent.position.set(2, 3, 2)
  scene.add(lights.accent)
  
  // 聚光灯
  lights.spot = new THREE.SpotLight(0xffffff, 0.8, 20, Math.PI * 0.3, 0.5)
  lights.spot.position.set(0, 10, 0)
  lights.spot.target.position.set(0, 0, 0)
  lights.spot.castShadow = true
  scene.add(lights.spot)
  scene.add(lights.spot.target)
}

// 后期处理设置
const setupPostProcessing = () => {
  composer = new EffectComposer(renderer)
  
  // 基础渲染通道
  const renderPass = new RenderPass(scene, camera)
  composer.addPass(renderPass)
  
  // 屏幕空间环境光遮蔽
  saoPass = new SAOPass(scene, camera, false, true)
  saoPass.params.output = SAOPass.OUTPUT.Beauty
  saoPass.params.saoBias = 0.5
  saoPass.params.saoIntensity = 0.15
  saoPass.params.saoScale = 1
  saoPass.params.saoKernelRadius = 100
  saoPass.params.saoMinResolution = 0
  composer.addPass(saoPass)
  
  // 泛光效果
  bloomPass = new UnrealBloomPass(
    new THREE.Vector2(container.value.clientWidth, container.value.clientHeight),
    0.3,  // 强度
    0.8,  // 半径
    0.1   // 阈值
  )
  composer.addPass(bloomPass)
  
  // 抗锯齿
  smaaPass = new SMAAPass(container.value.clientWidth, container.value.clientHeight)
  composer.addPass(smaaPass)
}

// 高级模型加载
const loadModel = async (modelName) => {
  try {
    loading.value = true
    error.value = null
    loadingProgress.value = 0
    
    // 清理之前的资源
    cleanupPreviousModel()
    
    const loader = new GLTFLoader()
    const config = modelConfigs[modelName] || modelConfigs.default
    modelInfo.value = config
    
    // 更新光照
    updateLightingForModel(config)
    
    // 尝试加载模型文件
    const modelPath = `/models/${modelName}.glb`
    
    try {
      const gltf = await new Promise((resolve, reject) => {
        loader.load(
          modelPath,
          resolve,
          (progress) => {
            if (progress.lengthComputable) {
              loadingProgress.value = Math.round((progress.loaded / progress.total) * 100)
            }
          },
          reject
        )
      })
      
      currentModel = gltf.scene
      
      // 应用配置
      currentModel.scale.setScalar(config.scale)
      currentModel.position.set(...config.position)
      currentModel.rotation.set(...config.rotation)
      
      // 高级材质处理
      enhanceModelMaterials(currentModel)
      
      // 启用阴影和反射
      currentModel.traverse((child) => {
        if (child.isMesh) {
          child.castShadow = true
          child.receiveShadow = true
          
          // 更新统计数据
          triangles.value += child.geometry.attributes.position.count / 3
          materials.value++
        }
      })
      
      scene.add(currentModel)
      
      // 处理动画
      if (gltf.animations && gltf.animations.length > 0) {
        mixer = new THREE.AnimationMixer(currentModel)
        gltf.animations.forEach((clip, index) => {
          const action = mixer.clipAction(clip)
          if (index === 0) action.play()
        })
      }
      
      // 创建粒子系统
      if (props.enableParticles) {
        createParticleSystem(config)
      }
      
      // 添加自定义动画
      addCustomAnimations(config)
      
      loading.value = false
      
    } catch (loadError) {
      console.warn(`Model ${modelName} not found, using enhanced placeholder`)
      createAdvancedPlaceholder(modelName)
      loading.value = false
    }
    
  } catch (err) {
    error.value = `加载模型失败: ${err.message}`
    loading.value = false
  }
}

// 清理之前的模型资源
const cleanupPreviousModel = () => {
  if (currentModel) {
    scene.remove(currentModel)
    // 清理几何体和材质
    currentModel.traverse((child) => {
      if (child.isMesh) {
        child.geometry?.dispose()
        if (Array.isArray(child.material)) {
          child.material.forEach(mat => mat.dispose())
        } else {
          child.material?.dispose()
        }
      }
    })
  }
  
  if (particleSystem) {
    scene.remove(particleSystem)
    particleSystem.geometry.dispose()
    particleSystem.material.dispose()
    particleSystem = null
  }
  
  // 重置统计数据
  triangles.value = 0
  materials.value = 0
}

// 增强模型材质
const enhanceModelMaterials = (model) => {
  model.traverse((child) => {
    if (child.isMesh && child.material) {
      const material = child.material
      
      // 启用环境贴图
      if (scene.environment) {
        material.envMap = scene.environment
        material.envMapIntensity = 0.8
      }
      
      // 提高材质质量
      material.metalness = material.metalness || 0.1
      material.roughness = material.roughness || 0.3
      
      // 添加自发光效果
      if (material.emissive) {
        material.emissiveIntensity = 0.1
      }
      
      // 更新材质
      material.needsUpdate = true
    }
  })
}

// 为模型更新光照
const updateLightingForModel = (config) => {
  if (lights.main) {
    lights.main.intensity = config.lighting.intensity
    lights.main.color.setHex(parseInt(config.lighting.color.replace('#', '0x')))
  }
}

// 创建粒子系统
const createParticleSystem = (config) => {
  const particleCount = config.particles.count
  const particleGeometry = new THREE.BufferGeometry()
  
  const positions = new Float32Array(particleCount * 3)
  const velocities = new Float32Array(particleCount * 3)
  const colors = new Float32Array(particleCount * 3)
  const sizes = new Float32Array(particleCount)
  
  const color = new THREE.Color(config.particles.color)
  
  for (let i = 0; i < particleCount; i++) {
    // 位置
    positions[i * 3] = (Math.random() - 0.5) * 10
    positions[i * 3 + 1] = Math.random() * 5
    positions[i * 3 + 2] = (Math.random() - 0.5) * 10
    
    // 速度
    velocities[i * 3] = (Math.random() - 0.5) * 0.02
    velocities[i * 3 + 1] = Math.random() * 0.01
    velocities[i * 3 + 2] = (Math.random() - 0.5) * 0.02
    
    // 颜色
    colors[i * 3] = color.r + (Math.random() - 0.5) * 0.2
    colors[i * 3 + 1] = color.g + (Math.random() - 0.5) * 0.2
    colors[i * 3 + 2] = color.b + (Math.random() - 0.5) * 0.2
    
    // 大小
    sizes[i] = Math.random() * 0.03 + 0.01
  }
  
  particleGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
  particleGeometry.setAttribute('velocity', new THREE.BufferAttribute(velocities, 3))
  particleGeometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))
  particleGeometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1))
  
  const particleMaterial = new THREE.ShaderMaterial({
    uniforms: {
      time: { value: 0 },
      pointTexture: { value: createParticleTexture(config.particles.type) }
    },
    vertexShader: `
      attribute float size;
      attribute vec3 velocity;
      uniform float time;
      varying vec3 vColor;
      
      void main() {
        vColor = color;
        vec3 newPosition = position + velocity * time;
        vec4 mvPosition = modelViewMatrix * vec4(newPosition, 1.0);
        gl_PointSize = size * (300.0 / -mvPosition.z);
        gl_Position = projectionMatrix * mvPosition;
      }
    `,
    fragmentShader: `
      uniform sampler2D pointTexture;
      varying vec3 vColor;
      
      void main() {
        gl_FragColor = vec4(vColor, 1.0);
        gl_FragColor = gl_FragColor * texture2D(pointTexture, gl_PointCoord);
        if (gl_FragColor.a < 0.1) discard;
      }
    `,
    blending: THREE.AdditiveBlending,
    depthTest: false,
    transparent: true,
    vertexColors: true
  })
  
  particleSystem = new THREE.Points(particleGeometry, particleMaterial)
  scene.add(particleSystem)
}

// 创建粒子纹理
const createParticleTexture = (type) => {
  const canvas = document.createElement('canvas')
  canvas.width = 64
  canvas.height = 64
  const ctx = canvas.getContext('2d')
  
  const gradient = ctx.createRadialGradient(32, 32, 0, 32, 32, 32)
  
  switch (type) {
    case 'leaves':
      gradient.addColorStop(0, 'rgba(143, 188, 143, 1)')
      gradient.addColorStop(0.5, 'rgba(143, 188, 143, 0.8)')
      gradient.addColorStop(1, 'rgba(143, 188, 143, 0)')
      break
    case 'sparkles':
      gradient.addColorStop(0, 'rgba(255, 255, 255, 1)')
      gradient.addColorStop(0.3, 'rgba(255, 235, 59, 0.8)')
      gradient.addColorStop(1, 'rgba(255, 235, 59, 0)')
      break
    case 'grains':
      gradient.addColorStop(0, 'rgba(249, 231, 159, 1)')
      gradient.addColorStop(0.7, 'rgba(249, 231, 159, 0.6)')
      gradient.addColorStop(1, 'rgba(249, 231, 159, 0)')
      break
    case 'pollen':
      gradient.addColorStop(0, 'rgba(255, 215, 0, 1)')
      gradient.addColorStop(0.4, 'rgba(255, 215, 0, 0.8)')
      gradient.addColorStop(1, 'rgba(255, 215, 0, 0)')
      break
    case 'earth':
      gradient.addColorStop(0, 'rgba(139, 69, 19, 0.8)')
      gradient.addColorStop(0.6, 'rgba(139, 69, 19, 0.4)')
      gradient.addColorStop(1, 'rgba(139, 69, 19, 0)')
      break
    case 'dewdrops':
      gradient.addColorStop(0, 'rgba(147, 112, 219, 0.9)')
      gradient.addColorStop(0.5, 'rgba(147, 112, 219, 0.6)')
      gradient.addColorStop(1, 'rgba(147, 112, 219, 0)')
      break
    case 'spores':
      gradient.addColorStop(0, 'rgba(139, 69, 19, 0.7)')
      gradient.addColorStop(0.5, 'rgba(160, 82, 45, 0.5)')
      gradient.addColorStop(1, 'rgba(139, 69, 19, 0)')
      break
    case 'honey':
      gradient.addColorStop(0, 'rgba(255, 215, 0, 1)')
      gradient.addColorStop(0.3, 'rgba(255, 193, 7, 0.9)')
      gradient.addColorStop(0.7, 'rgba(255, 165, 0, 0.5)')
      gradient.addColorStop(1, 'rgba(255, 215, 0, 0)')
      break
    case 'bubbles':
      gradient.addColorStop(0, 'rgba(135, 206, 235, 0.8)')
      gradient.addColorStop(0.5, 'rgba(173, 216, 230, 0.6)')
      gradient.addColorStop(1, 'rgba(135, 206, 235, 0)')
      break
    default:
      gradient.addColorStop(0, 'rgba(255, 255, 255, 1)')
      gradient.addColorStop(1, 'rgba(255, 255, 255, 0)')
  }
  
  ctx.fillStyle = gradient
  ctx.fillRect(0, 0, 64, 64)
  
  const texture = new THREE.CanvasTexture(canvas)
  return texture
}

// 添加自定义动画
const addCustomAnimations = (config) => {
  if (!currentModel || !config.animation) return
  
  // 浮动动画
  if (config.animation.floating) {
    const floatAnimation = () => {
      const time = clock.getElapsedTime()
      currentModel.position.y = config.position[1] + Math.sin(time * 2) * 0.1
    }
    currentModel.userData.floatAnimation = floatAnimation
  }
  
  // 弹跳动画
  if (config.animation.bounce) {
    const bounceAnimation = () => {
      const time = clock.getElapsedTime()
      const bounce = Math.abs(Math.sin(time * 3))
      currentModel.scale.setScalar(config.scale * (1 + bounce * 0.05))
    }
    currentModel.userData.bounceAnimation = bounceAnimation
  }
  
  // 摇摆动画 (适用于玉米等高杆作物)
  if (config.animation.sway) {
    const swayAnimation = () => {
      const time = clock.getElapsedTime()
      currentModel.rotation.z = Math.sin(time * 1.5) * 0.1
      currentModel.rotation.x = Math.cos(time * 0.8) * 0.05
    }
    currentModel.userData.swayAnimation = swayAnimation
  }
  
  // 脉冲动画 (适用于菌菇等)
  if (config.animation.pulse) {
    const pulseAnimation = () => {
      const time = clock.getElapsedTime()
      const pulse = Math.sin(time * 2.5) * 0.03 + 1
      currentModel.scale.setScalar(config.scale * pulse)
    }
    currentModel.userData.pulseAnimation = pulseAnimation
  }
  
  // 聚集动画 (适用于葡萄等成串水果)
  if (config.animation.cluster) {
    const clusterAnimation = () => {
      const time = clock.getElapsedTime()
      currentModel.rotation.y = Math.sin(time * 0.5) * 0.2
      currentModel.position.x = Math.sin(time * 1.2) * 0.05
    }
    currentModel.userData.clusterAnimation = clusterAnimation
  }
  
  // 黄金效果动画 (适用于蜂蜜等)
  if (config.animation.golden) {
    const goldenAnimation = () => {
      const time = clock.getElapsedTime()
      if (currentModel.material) {
        currentModel.material.emissiveIntensity = 0.1 + Math.sin(time * 3) * 0.05
      }
    }
    currentModel.userData.goldenAnimation = goldenAnimation
  }
  
  // 游泳动画 (适用于鱼类)
  if (config.animation.swimming) {
    const swimmingAnimation = () => {
      const time = clock.getElapsedTime()
      currentModel.position.x = Math.sin(time * 1.5) * 0.3
      currentModel.position.y = config.position[1] + Math.sin(time * 2.2 + Math.PI/3) * 0.15
      currentModel.rotation.y = Math.sin(time * 1.5) * 0.3
      currentModel.rotation.z = Math.sin(time * 2) * 0.1
    }
    currentModel.userData.swimmingAnimation = swimmingAnimation
  }
}

// 创建高级占位符
const createAdvancedPlaceholder = (modelName) => {
  const config = modelConfigs[modelName] || modelConfigs.default
  modelInfo.value = config
  
  // 创建更精细的几何体作为占位符
  let geometry, material
  
  switch (modelName) {
    case 'tea':
      geometry = new THREE.ConeGeometry(0.8, 1.5, 16)
      material = new THREE.MeshStandardMaterial({
        color: 0x228B22,
        metalness: 0.1,
        roughness: 0.7,
        envMapIntensity: 0.8
      })
      break
    case 'apple':
      geometry = new THREE.SphereGeometry(0.8, 32, 32)
      material = new THREE.MeshStandardMaterial({
        color: 0xFF4500,
        metalness: 0.0,
        roughness: 0.4,
        envMapIntensity: 1.0
      })
      break
    case 'rice':
      geometry = new THREE.BoxGeometry(1, 0.5, 1.5, 8, 4, 8)
      material = new THREE.MeshStandardMaterial({
        color: 0xF5DEB3,
        metalness: 0.0,
        roughness: 0.8,
        envMapIntensity: 0.6
      })
      break
    case 'corn':
      geometry = new THREE.CylinderGeometry(0.4, 0.3, 1.8, 12)
      material = new THREE.MeshStandardMaterial({
        color: 0xFFD700,
        metalness: 0.0,
        roughness: 0.6,
        envMapIntensity: 0.8
      })
      break
    case 'potato':
      geometry = new THREE.SphereGeometry(0.7, 16, 12)
      geometry.scale(1.2, 0.8, 1.0) // 使其看起来更像土豆
      material = new THREE.MeshStandardMaterial({
        color: 0xD2B48C,
        metalness: 0.0,
        roughness: 0.9,
        envMapIntensity: 0.4
      })
      break
    case 'grape':
      geometry = new THREE.SphereGeometry(0.6, 16, 16)
      material = new THREE.MeshStandardMaterial({
        color: 0x9370DB,
        metalness: 0.1,
        roughness: 0.3,
        envMapIntensity: 1.2,
        transparent: true,
        opacity: 0.9
      })
      break
    case 'mushroom':
      // 创建复合蘑菇形状
      const capGeometry = new THREE.SphereGeometry(0.6, 16, 8, 0, Math.PI * 2, 0, Math.PI / 2)
      const stemGeometry = new THREE.CylinderGeometry(0.15, 0.2, 0.8, 12)
      geometry = new THREE.BufferGeometry()
      
      const capMesh = new THREE.Mesh(capGeometry)
      capMesh.position.y = 0.4
      capMesh.updateMatrix()
      
      const stemMesh = new THREE.Mesh(stemGeometry)
      stemMesh.position.y = -0.1
      stemMesh.updateMatrix()
      
      geometry = BufferGeometryUtils.mergeGeometries([
        capMesh.geometry.clone().applyMatrix4(capMesh.matrix),
        stemMesh.geometry.clone().applyMatrix4(stemMesh.matrix)
      ])
      
      material = new THREE.MeshStandardMaterial({
        color: 0x8B4513,
        metalness: 0.0,
        roughness: 0.8,
        envMapIntensity: 0.5
      })
      break
    case 'honey':
      geometry = new THREE.CylinderGeometry(0.6, 0.5, 1.2, 8)
      material = new THREE.MeshStandardMaterial({
        color: 0xFFD700,
        metalness: 0.2,
        roughness: 0.1,
        envMapIntensity: 1.5,
        transparent: true,
        opacity: 0.8,
        emissive: 0x332200,
        emissiveIntensity: 0.1
      })
      break
    case 'fish':
      // 创建鱼形
      geometry = new THREE.SphereGeometry(0.8, 16, 12)
      geometry.scale(1.5, 0.8, 0.6) // 拉长成鱼形
      material = new THREE.MeshStandardMaterial({
        color: 0x4682B4,
        metalness: 0.3,
        roughness: 0.2,
        envMapIntensity: 1.0,
        transparent: true,
        opacity: 0.9
      })
      break
    default:
      geometry = new THREE.BoxGeometry(1, 1, 1)
      material = new THREE.MeshStandardMaterial({
        color: 0x789262,
        metalness: 0.1,
        roughness: 0.6,
        envMapIntensity: 0.7
      })
  }
  
  // 添加环境贴图
  if (scene.environment) {
    material.envMap = scene.environment
  }
  
  currentModel = new THREE.Mesh(geometry, material)
  currentModel.castShadow = true
  currentModel.receiveShadow = true
  
  currentModel.scale.setScalar(config.scale)
  currentModel.position.set(...config.position)
  currentModel.rotation.set(...config.rotation)
  
  scene.add(currentModel)
  
  // 添加自定义动画
  addCustomAnimations(config)
  
  // 创建粒子系统
  if (props.enableParticles) {
    createParticleSystem(config)
  }
  
  // 更新统计数据
  triangles.value = geometry.attributes.position.count / 3
  materials.value = 1
}

// 高级动画循环
const animate = () => {
  animationId = requestAnimationFrame(animate)
  
  const deltaTime = clock.getDelta()
  const elapsedTime = clock.getElapsedTime()
  
  // 更新控制器
  if (controls) {
    controls.update()
  }
  
  // 更新模型动画
  if (mixer) {
    mixer.update(deltaTime)
  }
  
  // 更新自定义动画
  if (currentModel && currentModel.userData) {
    if (currentModel.userData.floatAnimation) {
      currentModel.userData.floatAnimation()
    }
    if (currentModel.userData.bounceAnimation) {
      currentModel.userData.bounceAnimation()
    }
    if (currentModel.userData.swayAnimation) {
      currentModel.userData.swayAnimation()
    }
    if (currentModel.userData.pulseAnimation) {
      currentModel.userData.pulseAnimation()
    }
    if (currentModel.userData.clusterAnimation) {
      currentModel.userData.clusterAnimation()
    }
    if (currentModel.userData.goldenAnimation) {
      currentModel.userData.goldenAnimation()
    }
    if (currentModel.userData.swimmingAnimation) {
      currentModel.userData.swimmingAnimation()
    }
  }
  
  // 更新粒子系统
  if (particleSystem) {
    const positions = particleSystem.geometry.attributes.position.array
    const velocities = particleSystem.geometry.attributes.velocity.array
    
    for (let i = 0; i < positions.length; i += 3) {
      // 更新粒子位置
      positions[i] += velocities[i]
      positions[i + 1] += velocities[i + 1]
      positions[i + 2] += velocities[i + 2]
      
      // 边界检查
      if (positions[i + 1] > 10) {
        positions[i + 1] = -2
        positions[i] = (Math.random() - 0.5) * 10
        positions[i + 2] = (Math.random() - 0.5) * 10
      }
    }
    
    particleSystem.geometry.attributes.position.needsUpdate = true
    particleSystem.material.uniforms.time.value = elapsedTime
  }
  
  // 更新动态光照
  if (lights.accent) {
    lights.accent.position.x = Math.sin(elapsedTime * 0.5) * 3
    lights.accent.position.z = Math.cos(elapsedTime * 0.5) * 3
    lights.accent.intensity = 0.5 + Math.sin(elapsedTime * 2) * 0.2
  }
  
  // 更新环境光
  if (lights.ambient) {
    lights.ambient.intensity = 0.3 + Math.sin(elapsedTime * 0.3) * 0.1
  }
  
  // 渲染
  if (composer && props.enablePostProcessing) {
    composer.render()
  } else {
    renderer.render(scene, camera)
  }
  
  // 更新FPS计数器
  updateFPS()
}

// FPS监控
let frameCount = 0
let lastTime = performance.now()

const updateFPS = () => {
  frameCount++
  const currentTime = performance.now()
  
  if (currentTime - lastTime >= 1000) {
    fps.value = Math.round((frameCount * 1000) / (currentTime - lastTime))
    frameCount = 0
    lastTime = currentTime
  }
}

// 重置视角
const resetView = () => {
  if (controls) {
    controls.reset()
  }
  camera.position.set(0, 0, 5)
  camera.lookAt(0, 0, 0)
}

// 切换自动旋转
const toggleAutoRotate = () => {
  autoRotate.value = !autoRotate.value
  if (controls) {
    controls.autoRotate = autoRotate.value
  }
}

// 切换线框模式
const toggleWireframe = () => {
  if (currentModel) {
    currentModel.traverse((child) => {
      if (child.isMesh && child.material) {
        child.material.wireframe = !child.material.wireframe
      }
    })
  }
}

// 切换环境效果
const toggleEnvironment = () => {
  if (scene.environment) {
    scene.environment = null
    scene.background = new THREE.Color(0xf8f3e6)
  } else {
    loadEnvironmentMap()
  }
}

// 更新光照
const updateLighting = () => {
  Object.values(lights).forEach(light => {
    if (light && light.intensity !== undefined) {
      light.intensity = parseFloat(lightIntensity.value)
    }
  })
}

// 重新加载模型
const retryLoad = () => {
  if (props.modelName) {
    loadModel(props.modelName)
  }
}

// 鼠标交互事件
const onMouseEnter = () => {
  if (controls) {
    controls.autoRotateSpeed = 0.5
  }
}

const onMouseLeave = () => {
  if (controls) {
    controls.autoRotateSpeed = 1
  }
}

// 处理窗口大小变化
const handleResize = () => {
  if (!container.value || !renderer || !camera) return
  
  const width = container.value.clientWidth
  const height = container.value.clientHeight
  
  camera.aspect = width / height
  camera.updateProjectionMatrix()
  renderer.setSize(width, height)
  
  // 更新后期处理
  if (composer) {
    composer.setSize(width, height)
    
    if (bloomPass) {
      bloomPass.setSize(width, height)
    }
    if (saoPass) {
      saoPass.setSize(width, height)
    }
    if (smaaPass) {
      smaaPass.setSize(width, height)
    }
  }
}

// 监听模型名称变化
watch(() => props.modelName, (newModelName) => {
  if (newModelName) {
    loadModel(newModelName)
  }
}, { immediate: true })

// 监听自动旋转变化
watch(() => props.autoRotate, (newValue) => {
  autoRotate.value = newValue
  if (controls) {
    controls.autoRotate = newValue
  }
})

// 显示统计信息的计算属性
const showStatsComputed = computed(() => {
  return showStats.value && !loading.value && !error.value
})

// 生命周期钩子
onMounted(async () => {
  try {
    await initScene()
    window.addEventListener('resize', handleResize)
    
    // 添加键盘快捷键
    window.addEventListener('keydown', handleKeyDown)
  } catch (err) {
    error.value = `初始化场景失败: ${err.message}`
  }
})

onUnmounted(() => {
  // 清理动画
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
  
  // 清理事件监听器
  window.removeEventListener('resize', handleResize)
  window.removeEventListener('keydown', handleKeyDown)
  
  // 清理Three.js资源
  cleanupPreviousModel()
  
  if (composer) {
    composer.dispose()
  }
  
  if (renderer) {
    renderer.dispose()
    if (container.value && renderer.domElement) {
      container.value.removeChild(renderer.domElement)
    }
  }
  
  if (controls) {
    controls.dispose()
  }
  
  // 清理光照
  Object.values(lights).forEach(light => {
    if (light && light.dispose) {
      light.dispose()
    }
  })
})

// 键盘快捷键处理
const handleKeyDown = (event) => {
  if (!container.value || loading.value || error.value) return
  
  switch (event.key.toLowerCase()) {
    case 'r':
      resetView()
      break
    case ' ':
      event.preventDefault()
      toggleAutoRotate()
      break
    case 'w':
      toggleWireframe()
      break
    case 'e':
      toggleEnvironment()
      break
    case 's':
      showStats.value = !showStats.value
      break
  }
}
</script>

<style scoped>
.font-chinese {
  font-family: 'Source Han Sans CN', 'PingFang SC', 'Microsoft YaHei', sans-serif;
}
</style> 