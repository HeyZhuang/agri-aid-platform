-- ========================================
-- 山西特色扶贫助农系统数据插入脚本
-- 突出山西地域文化特色和扶贫元素
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- 1. 管理员数据插入
-- ========================================
INSERT INTO `admin` (`username`, `password`, `name`, `avatar`, `role`, `phone`, `email`, `create_time`, `update_time`) VALUES
('admin', 'admin', '管理员', 'http://localhost:9090/files/1697438073596-avatar.png', 'ADMIN', '13677889922', 'admin@sx.gov.cn', NOW(), NOW()),
('system_admin', 'admin123', '山西省扶贫办管理员', 'http://localhost:9090/files/shanxi_admin.png', 'ADMIN', '0351-12345678', 'fpb@sx.gov.cn', NOW(), NOW());

-- ========================================
-- 2. 用户数据插入（山西特色用户）
-- ========================================
INSERT INTO `user` (`username`, `password`, `name`, `avatar`, `role`, `phone`, `email`, `level`, `account`, `status`, `create_time`, `update_time`) VALUES
('taiyuan_xiaowang', '123456', '太原小王', 'http://localhost:9090/files/user_taiyuan.jpg', 'USER', '13503511001', 'xiaowang@163.com', '贫困户', 500.00, 1, '2024-01-15 10:30:00', NOW()),
('datong_laoli', '123456', '大同老李', 'http://localhost:9090/files/user_datong.jpg', 'USER', '13503522002', 'laoli@126.com', '普通用户', 1200.50, 1, '2024-01-16 09:15:00', NOW()),
('pingyao_xiaozhang', '123456', '平遥小张', 'http://localhost:9090/files/user_pingyao.jpg', 'USER', '13503533003', 'xiaozhang@qq.com', '脱贫户', 800.00, 1, '2024-01-17 14:20:00', NOW()),
('jinzhong_dama', '123456', '晋中大妈', 'http://localhost:9090/files/user_jinzhong.jpg', 'USER', '13503544004', 'dama@sina.com', '普通用户', 300.00, 1, '2024-01-18 16:45:00', NOW()),
('lvliang_shanmin', '123456', '吕梁山民', 'http://localhost:9090/files/user_lvliang.jpg', 'USER', '13503555005', 'shanmin@outlook.com', '贫困户', 150.00, 1, '2024-01-19 08:30:00', NOW());

-- ========================================
-- 3. 系统公告插入
-- ========================================
INSERT INTO `notice` (`title`, `content`, `type`, `priority`, `status`, `is_top`, `view_count`, `create_user`, `user`, `time`, `create_time`, `update_time`) VALUES
('山西省扶贫助农平台正式上线！', '为深入贯彻落实乡村振兴战略，山西省扶贫助农电商平台正式上线运营。平台汇集全省各地优质农特产品，为广大农户提供线上销售渠道，助力脱贫攻坚成果巩固提升。', '重要公告', 3, 1, 1, 156, 'system_admin', 'system_admin', '2024-01-20', '2024-01-20 09:00:00', NOW()),
('春节期间配送安排通知', '春节期间（1月21日-1月30日），平台继续为大家服务，配送时间调整为每日上午9:00-17:00，敬请各位用户提前下单。', '服务公告', 2, 1, 0, 89, 'admin', 'admin', '2024-01-21', '2024-01-21 15:30:00', NOW()),
('山西特产推广月活动开始啦！', '2月份是山西特产推广月，平台所有山西地标农产品享受8.8折优惠，包括老陈醋、汾酒、平遥牛肉等，欢迎大家选购！', '活动公告', 2, 1, 0, 234, 'system_admin', 'system_admin', '2024-02-01', '2024-02-01 10:00:00', NOW());

-- ========================================
-- 4. 扶贫政策插入（山西特色）
-- ========================================
INSERT INTO `policy` (`name`, `content`, `cover_img`, `num`, `praise_count`, `comment_count`, `status`, `create_user`, `time`, `create_time`, `update_time`) VALUES
('山西省乡村振兴十条政策', 
CONCAT('<h2>山西省乡村振兴十条扶持政策</h2>',
'<p><strong>为深入实施乡村振兴战略，加快推进农业农村现代化，结合我省实际，制定以下十条扶持政策：</strong></p>',
'<ol>',
'<li><strong>产业发展扶持</strong>：对发展特色农业产业的农户给予每户最高5万元补贴</li>',
'<li><strong>电商平台建设</strong>：支持农产品线上销售，提供物流补贴和平台使用费减免</li>',
'<li><strong>技术培训支持</strong>：免费提供农业技术培训和电商运营指导</li>',
'<li><strong>金融信贷优惠</strong>：提供低息贷款支持，年利率不超过3%</li>',
'<li><strong>基础设施建设</strong>：完善农村道路、网络等基础设施</li>',
'<li><strong>品牌打造扶持</strong>：支持"山西药茶"、"山西小米"等区域品牌建设</li>',
'<li><strong>合作社发展</strong>：鼓励成立农民专业合作社，给予启动资金支持</li>',
'<li><strong>人才引进计划</strong>：吸引大学生返乡创业，提供创业补贴</li>',
'<li><strong>市场对接服务</strong>：组织农产品展销会，拓宽销售渠道</li>',
'<li><strong>长效帮扶机制</strong>：建立结对帮扶制度，确保脱贫不返贫</li>',
'</ol>',
'<p><img src="http://localhost:9090/files/shanxi_policy_banner.jpg" alt="山西乡村振兴" style="max-width:100%"></p>',
'<p><em>本政策自发布之日起执行，有效期至2025年12月31日。</em></p>'), 
'http://localhost:9090/files/shanxi_zhengce.jpg', 1580, 45, 5, 1, 'system_admin', '2024-01-22', '2024-01-22 09:30:00', NOW()),

('晋中市产业扶贫补贴政策实施细则', 
CONCAT('<h2>晋中市产业扶贫补贴政策实施细则</h2>',
'<p><strong>为进一步做好产业扶贫工作，支持贫困地区发展特色产业，特制定本实施细则：</strong></p>',
'<h3>一、补贴对象</h3>',
'<p>1. 建档立卡贫困户及脱贫监测户<br>',
'2. 带动贫困户发展的农民专业合作社<br>',
'3. 扶贫龙头企业和家庭农场</p>',
'<h3>二、补贴标准</h3>',
'<ul>',
'<li><strong>种植业</strong>：小杂粮种植每亩补贴200元，药材种植每亩补贴300元</li>',
'<li><strong>养殖业</strong>：肉牛养殖每头补贴2000元，生猪养殖每头补贴500元</li>',
'<li><strong>农产品加工</strong>：新建加工厂房每平米补贴100元</li>',
'<li><strong>电商销售</strong>：年销售额达10万元以上奖励5000元</li>',
'</ul>',
'<p><img src="http://localhost:9090/files/jinzhong_industry.jpg" alt="晋中产业扶贫" style="max-width:100%"></p>',
'<h3>三、申请流程</h3>',
'<p>1. 向当地乡镇政府提交申请材料<br>',
'2. 县级农业农村局审核<br>',
'3. 市级部门复核批准<br>',
'4. 资金直接拨付到户</p>'), 
'http://localhost:9090/files/jinzhong_policy.jpg', 892, 32, 3, 1, 'system_admin', '2024-01-23', '2024-01-23 14:15:00', NOW()),

('山西省农产品电商扶持专项政策', 
CONCAT('<h2>山西省农产品电商扶持专项政策</h2>',
'<p><strong>为推动我省农产品电商发展，助力农民增收致富，特出台以下扶持政策：</strong></p>',
'<div style="background-color:#f0f8e7; padding:15px; border-left:4px solid #4CAF50; margin:10px 0;">',
'<h3>💰 资金扶持政策</h3>',
'<p>• 电商平台建设补贴：最高50万元<br>',
'• 网店开设补贴：每个网店补贴2000元<br>',
'• 电商培训补贴：免费提供专业培训</p>',
'</div>',
'<div style="background-color:#e8f4fd; padding:15px; border-left:4px solid #2196F3; margin:10px 0;">',
'<h3>🚚 物流配送支持</h3>',
'<p>• 物流费用补贴50%<br>',
'• 建设县级物流配送中心<br>',
'• 完善农村配送网络</p>',
'</div>',
'<div style="background-color:#fff3e0; padding:15px; border-left:4px solid #FF9800; margin:10px 0;">',
'<h3>🏷️ 品牌建设扶持</h3>',
'<p>• "三品一标"认证补贴<br>',
'• 区域公用品牌推广<br>',
'• 包装设计补贴</p>',
'</div>',
'<p><img src="http://localhost:9090/files/shanxi_ecommerce.jpg" alt="山西电商扶贫" style="max-width:100%"></p>',
'<p><strong>联系方式：</strong>山西省商务厅电商处 0351-8068888</p>'), 
'http://localhost:9090/files/dianshang_zhengce.jpg', 654, 28, 2, 1, 'admin', '2024-01-24', '2024-01-24 11:20:00', NOW());

-- ========================================
-- 5. 扶贫资讯插入
-- ========================================
INSERT INTO `information` (`name`, `content`, `cover_img`, `num`, `status`, `create_user`, `time`, `create_time`, `update_time`) VALUES
('山西小米走向全国，助农增收显成效', 
CONCAT('<h2>山西小米品牌化发展，带动农民致富</h2>',
'<p>近年来，山西省大力推进小米产业发展，通过品牌化运营、标准化生产，让传统农产品焕发新活力。</p>',
'<p><img src="http://localhost:9090/files/shanxi_xiaomi_news.jpg" alt="山西小米丰收" style="max-width:100%"></p>',
'<p><strong>产业发展亮点：</strong></p>',
'<ul><li>建成小米种植基地50万亩</li><li>年产优质小米15万吨</li><li>带动农户3万余户增收</li><li>年人均增收2000余元</li></ul>'), 
'http://localhost:9090/files/xiaomi_news.jpg', 425, 1, 'admin', '2024-01-25', '2024-01-25 16:30:00', NOW()),

('平遥古城旅游带动农家乐发展', 
CONCAT('<h2>平遥古城文旅融合，乡村旅游蓬勃发展</h2>',
'<p>依托平遥古城世界文化遗产品牌，当地农家乐产业快速发展，成为农民增收新途径。</p>',
'<p><img src="http://localhost:9090/files/pingyao_tourism.jpg" alt="平遥古城农家乐" style="max-width:100%"></p>',
'<p>目前平遥县已发展农家乐200余家，年接待游客超过50万人次，为当地农民提供就业岗位1000余个。</p>'), 
'http://localhost:9090/files/pingyao_news.jpg', 312, 1, 'admin', '2024-01-26', '2024-01-26 10:45:00', NOW());

-- ========================================
-- 6. 农家乐信息插入（山西景点关联）
-- ========================================
INSERT INTO `agritainment` (`name`, `content`, `img`, `address`, `contact_phone`, `contact_person`, `price_range`, `features`, `num`, `comment_count`, `rating`, `status`, `create_user`, `time`, `create_time`, `update_time`) VALUES
('云冈石窟农家院', 
CONCAT('<h2>🏮 云冈石窟农家院 - 体验千年文化魅力</h2>',
'<p><strong>位置优势：</strong>距离云冈石窟景区仅500米，交通便利，环境优美。</p>',
'<div style="background-color:#f9f9f9; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🏡 住宿环境</h3>',
'<p>• 传统四合院建筑，古朴典雅<br>',
'• 正宗北方大炕体验<br>',
'• 现代化卫浴设施<br>',
'• 24小时热水供应</p>',
'</div>',
'<div style="background-color:#e8f5e8; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🍜 特色美食</h3>',
'<p>• 大同火锅：铜锅涮肉，汤鲜味美<br>',
'• 刀削面：现场制作，劲道爽滑<br>',
'• 黄糕：传统小吃，香甜可口<br>',
'• 农家菜：绿色有机，健康美味</p>',
'</div>',
'<p><img src="http://localhost:9090/files/yungang_farm.jpg" alt="云冈农家院" style="max-width:100%"></p>',
'<p><strong>预订电话：</strong>0352-7992888</p>'), 
'http://localhost:9090/files/yungang_farmhouse.jpg', '山西省大同市云冈区云冈镇石窟村', '0352-7992888', '李大叔', '100-200元/人', '云冈石窟观光,传统炕头体验,农家美食,文化讲解', 267, 12, 4.8, 1, 'admin', '2024-01-20', '2024-01-20 09:00:00', NOW()),

('平遥古城晋韵小院', 
CONCAT('<h2>🏛️ 平遥古城晋韵小院 - 穿越时空的文化之旅</h2>',
'<p><strong>地理位置：</strong>坐落于平遥古城核心区域，步行可达古城墙、县衙等景点。</p>',
'<div style="background-color:#f0f0f0; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🏮 古韵住宿</h3>',
'<p>• 明清古建筑改造<br>',
'• 传统木雕装饰<br>',
'• 古色古香的家具<br>',
'• 现代舒适设施</p>',
'</div>',
'<div style="background-color:#fff8e1; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🎭 文化体验</h3>',
'<p>• 古城历史讲解<br>',
'• 传统手工艺制作<br>',
'• 晋商文化体验<br>',
'• 古装摄影服务</p>',
'</div>',
'<p><img src="http://localhost:9090/files/pingyao_yard.jpg" alt="平遥晋韵小院" style="max-width:100%"></p>',
'<p><em>在这里，您可以感受到最authentic的晋商文化氛围！</em></p>'), 
'http://localhost:9090/files/pingyao_jinyun.jpg', '山西省晋中市平遥县古城内衙门街18号', '0354-5868999', '王大姐', '150-300元/人', '古城文化,晋商体验,传统手工,古装摄影', 189, 8, 4.9, 1, 'admin', '2024-01-21', '2024-01-21 14:30:00', NOW()),

('五台山汾河人家', 
CONCAT('<h2>⛰️ 五台山汾河人家 - 佛教圣地的宁静之所</h2>',
'<p><strong>环境介绍：</strong>位于五台山风景区内，依山傍水，空气清新，是修身养性的理想之地。</p>',
'<div style="background-color:#e3f2fd; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🏔️ 自然环境</h3>',
'<p>• 海拔1000米高山气候<br>',
'• 负氧离子含量丰富<br>',
'• 四季景色各异<br>',
'• 清澈山泉水源</p>',
'</div>',
'<div style="background-color:#f3e5f5; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🙏 佛教文化</h3>',
'<p>• 距离台怀镇核心区2公里<br>',
'• 可参与晨钟暮鼓<br>',
'• 素食文化体验<br>',
'• 禅修静心活动</p>',
'</div>',
'<p><img src="http://localhost:9090/files/wutaishan_home.jpg" alt="五台山汾河人家" style="max-width:100%"></p>',
'<p><strong>特别提醒：</strong>五台山气温较低，请提前准备保暖衣物。</p>'), 
'http://localhost:9090/files/wutaishan_fenhe.jpg', '山西省忻州市五台县台怀镇汾河村', '0350-6543210', '赵师傅', '120-250元/人', '佛教文化,高山气候,素食体验,禅修静心', 156, 6, 4.7, 1, 'admin', '2024-01-22', '2024-01-22 11:15:00', NOW()),

('壶口瀑布黄河农庄', 
CONCAT('<h2>🌊 壶口瀑布黄河农庄 - 感受母亲河的磅礴气势</h2>',
'<p><strong>独特位置：</strong>紧邻壶口瀑布景区，可近距离感受黄河奔腾的壮观景象。</p>',
'<div style="background-color:#fff3e0; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🌊 壮观景色</h3>',
'<p>• 黄河壶口瀑布近在咫尺<br>',
'• 一年四季景色不同<br>',
'• 日出日落最美时刻<br>',
'• 摄影爱好者天堂</p>',
'</div>',
'<div style="background-color:#e8f5e8; padding:15px; margin:10px 0; border-radius:8px;">',
'<h3>🥘 黄河美食</h3>',
'<p>• 黄河鲤鱼：鲜美无比<br>',
'• 陕北羊肉：肉质鲜嫩<br>',
'• 农家小菜：绿色健康<br>',
'• 黄河滩枣：甘甜可口</p>',
'</div>',
'<p><img src="http://localhost:9090/files/hukou_farm.jpg" alt="壶口黄河农庄" style="max-width:100%"></p>',
'<p><em>"黄河之水天上来，奔流到海不复回" - 在这里感受诗人的豪迈情怀！</em></p>'), 
'http://localhost:9090/files/hukou_nongzhuang.jpg', '山西省临汾市吉县壶口镇黄河边', '0357-7877666', '张老板', '80-180元/人', '壶口瀑布,黄河文化,摄影观光,农家美食', 134, 4, 4.6, 1, 'admin', '2024-01-23', '2024-01-23 16:45:00', NOW());

-- ========================================
-- 7. 扶贫商品插入（山西特产）
-- ========================================
INSERT INTO `goods` (`name`, `description`, `price`, `original_price`, `num`, `sales`, `img`, `category`, `origin`, `unit`, `weight`, `shelf_life`, `storage_method`, `status`, `is_recommend`, `create_user`, `create_time`, `update_time`) VALUES
('宁化府老陈醋 五年陈酿', '山西老字号品牌，采用传统固态发酵工艺，酸味纯正，回味甘甜。富含多种氨基酸和有机酸，是调味佳品和养生良品。每一滴都承载着山西醋文化的深厚底蕴。', 28.80, 36.00, 500, 89, 'http://localhost:9090/files/ninghua_vinegar.jpg', '调味品', '山西省太原市', '瓶', '500ml', '3年', '阴凉干燥处保存', 1, 1, 'admin', '2024-01-15 09:00:00', NOW()),

('沁州黄小米 农家自产', '中国国家地理标志产品，来自吕梁山区无污染环境，颗粒饱满，色泽金黄，营养丰富。富含蛋白质、维生素和矿物质，是婴幼儿和老人的理想营养食品。', 15.50, 20.00, 800, 156, 'http://localhost:9090/files/qinzhou_millet.jpg', '粮食', '山西省长治市沁县', '袋', '1kg', '12个月', '干燥通风处保存', 1, 1, 'admin', '2024-01-15 10:30:00', NOW()),

('平遥牛肉 真空包装', '平遥古城特产，选用优质牛肉，采用传统工艺腌制风干，肉质紧实，味道醇香。获得国家地理标志保护产品认证，是馈赠亲友的上佳选择。', 45.00, 58.00, 200, 67, 'http://localhost:9090/files/pingyao_beef.jpg', '肉制品', '山西省晋中市平遥县', '袋', '200g', '6个月', '冷藏保存', 1, 1, 'admin', '2024-01-16 11:15:00', NOW()),

('汾酒 53度清香型白酒', '山西汾酒集团出品，中国清香型白酒的典型代表，酒质清香纯正，口感绵甜爽净。传承千年酿造工艺，是中华酒文化的重要载体。', 128.00, 158.00, 150, 34, 'http://localhost:9090/files/fenjiu_wine.jpg', '酒类', '山西省吕梁市汾阳市', '瓶', '500ml', '长期保存', '阴凉避光处保存', 1, 0, 'admin', '2024-01-17 14:20:00', NOW()),

('绛县山楂条 无添加', '精选绛县优质山楂制作，无任何添加剂，酸甜可口，富含维生素C和有机酸。具有开胃消食、降血脂的功效，是健康零食的首选。', 12.80, 16.00, 300, 78, 'http://localhost:9090/files/jiangxian_hawthorn.jpg', '休闲食品', '山西省运城市绛县', '袋', '250g', '9个月', '干燥通风处保存', 1, 1, 'admin', '2024-01-18 15:45:00', NOW()),

('山西药茶 连翘叶茶', '山西道地药材连翘叶制成，具有清热解毒、消肿散结的功效。口感甘甜，香气清雅，是日常养生保健的理想选择。山西药茶品牌力作。', 38.00, 48.00, 180, 23, 'http://localhost:9090/files/shanxi_medicine_tea.jpg', '茶叶', '山西省运城市', '盒', '100g', '24个月', '干燥密封保存', 1, 1, 'admin', '2024-01-19 16:30:00', NOW());

-- ========================================
-- 8. 评论插入（为第1条政策生成5条评论）
-- ========================================
INSERT INTO `comment` (`user_id`, `policy_id`, `content`, `parent_id`, `status`, `time`, `create_time`, `update_time`) VALUES
(1, 1, '为山西点赞！这十条政策真的很实用，特别是产业发展扶持，对我们农户来说太有帮助了👍', 0, 1, '2024-01-22 10:30:00', '2024-01-22 10:30:00', NOW()),
(2, 1, '感谢政府的好政策👍！电商平台建设这一条对我们很有用，希望能早日落地实施，让更多农产品走出山西！', 0, 1, '2024-01-22 11:15:00', '2024-01-22 11:15:00', NOW()),
(3, 1, '技术培训支持这个太好了！我们农民最需要的就是学习新技术，希望能多举办一些培训班😊', 0, 1, '2024-01-22 14:20:00', '2024-01-22 14:20:00', NOW()),
(4, 1, '低息贷款支持解决了我们的大问题！年利率不超过3%，这对发展农业太重要了，给政府点赞👏', 0, 1, '2024-01-22 16:45:00', '2024-01-22 16:45:00', NOW()),
(5, 1, '山西的政策越来越好了！基础设施建设也很重要，路修好了，我们的农产品才能更好地运出去💪', 0, 1, '2024-01-23 09:00:00', '2024-01-23 09:00:00', NOW());

-- ========================================
-- 9. 点赞插入（为前3条政策生成随机点赞）
-- ========================================
INSERT INTO `praise` (`user_id`, `policy_id`, `status`, `time`, `create_time`, `update_time`) VALUES
-- 第1条政策的点赞（45个点赞）
(1, 1, 1, '2024-01-22 10:31:00', '2024-01-22 10:31:00', NOW()),
(2, 1, 1, '2024-01-22 11:16:00', '2024-01-22 11:16:00', NOW()),
(3, 1, 1, '2024-01-22 14:21:00', '2024-01-22 14:21:00', NOW()),
(4, 1, 1, '2024-01-22 16:46:00', '2024-01-22 16:46:00', NOW()),
(5, 1, 1, '2024-01-23 09:01:00', '2024-01-23 09:01:00', NOW()),

-- 第2条政策的点赞（32个点赞）
(1, 2, 1, '2024-01-23 14:20:00', '2024-01-23 14:20:00', NOW()),
(3, 2, 1, '2024-01-23 15:30:00', '2024-01-23 15:30:00', NOW()),
(5, 2, 1, '2024-01-23 16:45:00', '2024-01-23 16:45:00', NOW()),

-- 第3条政策的点赞（28个点赞）
(2, 3, 1, '2024-01-24 11:25:00', '2024-01-24 11:25:00', NOW()),
(4, 3, 1, '2024-01-24 13:40:00', '2024-01-24 13:40:00', NOW());

-- ========================================
-- 10. 订单插入（3个已完成订单）
-- ========================================
INSERT INTO `orders` (`order_id`, `user_id`, `goods_id`, `goods_name`, `img`, `price`, `quantity`, `total_price`, `status`, `payment_status`, `shipping_address`, `shipping_phone`, `shipping_name`, `express_company`, `express_number`, `time`, `create_time`, `payment_time`, `ship_time`, `finish_time`, `update_time`) VALUES
('SX202401220001', 1, 1, '宁化府老陈醋 五年陈酿', 'http://localhost:9090/files/ninghua_vinegar.jpg', 28.80, 2, 57.60, '已完成', '已支付', '山西省太原市晋源区晋祠镇新庄村18号', '13503511001', '太原小王', '中通快递', 'ZTO2024012200001', '2024-01-22 09:30:00', '2024-01-22 09:30:00', '2024-01-22 09:35:00', '2024-01-23 10:00:00', '2024-01-25 14:30:00', NOW()),

('SX202401230002', 2, 2, '沁州黄小米 农家自产', 'http://localhost:9090/files/qinzhou_millet.jpg', 15.50, 3, 46.50, '已完成', '已支付', '山西省大同市云冈区云冈镇石窟村8号', '13503522002', '大同老李', '顺丰速运', 'SF2024012300002', '2024-01-23 11:15:00', '2024-01-23 11:15:00', '2024-01-23 11:20:00', '2024-01-24 09:30:00', '2024-01-26 16:20:00', NOW()),

('SX202401240003', 3, 1, '宁化府老陈醋 五年陈酿', 'http://localhost:9090/files/ninghua_vinegar.jpg', 28.80, 1, 28.80, '已完成', '已支付', '山西省晋中市平遥县古城内衙门街18号', '13503533003', '平遥小张', '韵达快递', 'YD2024012400003', '2024-01-24 14:20:00', '2024-01-24 14:20:00', '2024-01-24 14:25:00', '2024-01-25 08:45:00', '2024-01-27 10:15:00', NOW());

-- ========================================
-- 11. 贫困户申请插入
-- ========================================
INSERT INTO `poorapply` (`user_id`, `content`, `real_name`, `id_card`, `phone`, `address`, `family_members`, `income_source`, `annual_income`, `poverty_reason`, `file`, `status`, `descr`, `audit_user`, `audit_time`, `time`, `create_time`, `update_time`) VALUES
(1, '我是太原市晋源区的农户，由于家中老人生病医疗费用较高，导致家庭经济困难，希望能够申请贫困户认定，获得相关政策扶持。', '王建国', '140121198501231234', '13503511001', '山西省太原市晋源区晋祠镇新庄村18号', 4, '种植业、打零工', 18000.00, '家中有慢性病患者，医疗费用支出较大', 'http://localhost:9090/files/poor_apply_001.pdf', '审核通过', '经核实，申请人家庭确实存在困难，符合贫困户认定标准，予以通过。', 'system_admin', '2024-01-20 15:30:00', '2024-01-18 09:00:00', '2024-01-18 09:00:00', NOW()),

(5, '我是吕梁山区的农民，因为地处偏远山区，交通不便，农产品销售困难，家庭收入微薄，申请贫困户认定。', '李山娃', '141122197803158765', '13503555005', '山西省吕梁市临县白文镇庙坪村23号', 3, '小杂粮种植', 12000.00, '地处偏远山区，交通不便，农产品销售困难', 'http://localhost:9090/files/poor_apply_002.pdf', '待审核', NULL, NULL, NULL, '2024-01-19 10:30:00', '2024-01-19 10:30:00', NOW());

-- ========================================
-- 12. 扶贫项目申请插入
-- ========================================
INSERT INTO `projectapply` (`user_id`, `project_name`, `project_type`, `content`, `business_plan`, `investment_amount`, `expected_return`, `location`, `contact_person`, `contact_phone`, `file`, `status`, `descr`, `audit_user`, `audit_time`, `time`, `create_time`, `update_time`) VALUES
(3, '平遥古城文化农家乐', '农家乐', '依托平遥古城世界文化遗产品牌，打造集住宿、餐饮、文化体验于一体的精品农家乐。项目将传统建筑与现代服务相结合，为游客提供authentic的晋商文化体验。', '项目分三期建设：一期完成古建筑修缮和基础设施建设；二期增加文化体验项目；三期扩大接待规模。预计总投资50万元，年接待游客5000人次，年营业收入80万元。', 500000.00, 200000.00, '山西省晋中市平遥县古城内', '张文化', '13503533003', 'http://localhost:9090/files/project_apply_001.pdf', '审核通过', '项目方案可行，符合当地文旅发展规划，同意立项支持。', 'system_admin', '2024-01-22 16:00:00', '2024-01-20 14:30:00', '2024-01-20 14:30:00', NOW()),

(4, '晋中有机蔬菜种植基地', '种植业', '建设50亩有机蔬菜种植基地，采用绿色种植技术，生产无公害蔬菜，通过电商平台销售到全国。项目将带动周边农户就业，推广有机种植技术。', '基地建设包括温室大棚、灌溉系统、包装车间等。与电商平台合作，建立稳定销售渠道。预计带动就业50人，年产值100万元。', 300000.00, 150000.00, '山西省晋中市榆次区', '李大妈', '13503544004', 'http://localhost:9090/files/project_apply_002.pdf', '待审核', NULL, NULL, NULL, '2024-01-21 11:20:00', '2024-01-21 11:20:00', NOW());

-- 更新政策表的统计数据
UPDATE `policy` SET `praise_count` = 45, `comment_count` = 5 WHERE `id` = 1;
UPDATE `policy` SET `praise_count` = 32, `comment_count` = 0 WHERE `id` = 2;
UPDATE `policy` SET `praise_count` = 28, `comment_count` = 0 WHERE `id` = 3;

-- 更新商品销量
UPDATE `goods` SET `num` = `num` - `sales` WHERE `id` IN (1, 2);

-- 更新用户余额（扣除订单金额）
UPDATE `user` SET `account` = `account` - 57.60 WHERE `id` = 1;
UPDATE `user` SET `account` = `account` - 46.50 WHERE `id` = 2;
UPDATE `user` SET `account` = `account` - 28.80 WHERE `id` = 3;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- 插入完成提示
-- ========================================
SELECT '🎉 山西特色扶贫助农系统数据插入完成！' AS message;
SELECT '📊 数据统计：' AS title, 
       (SELECT COUNT(*) FROM user) AS 用户数,
       (SELECT COUNT(*) FROM policy) AS 政策数,
       (SELECT COUNT(*) FROM agritainment) AS 农家乐数,
       (SELECT COUNT(*) FROM goods) AS 商品数,
       (SELECT COUNT(*) FROM orders) AS 订单数,
       (SELECT COUNT(*) FROM comment) AS 评论数,
       (SELECT COUNT(*) FROM praise) AS 点赞数; 