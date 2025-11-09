-- ========================================
-- 数据库迁移脚本 - 修复 orders 表结构
-- Database Migration Script - Fix orders table structure
-- ========================================

-- 检查并添加 goods_name 字段（如果不存在）
SET @sql_add_goods_name = (
    SELECT IF(
        (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
         WHERE TABLE_SCHEMA = DATABASE() 
         AND TABLE_NAME = 'orders' 
         AND COLUMN_NAME = 'goods_name') = 0,
        'ALTER TABLE orders ADD COLUMN goods_name varchar(255) DEFAULT NULL COMMENT "商品名称" AFTER goods_id;',
        'SELECT "goods_name column already exists" as result;'
    )
);

PREPARE stmt_add_goods_name FROM @sql_add_goods_name;
EXECUTE stmt_add_goods_name;
DEALLOCATE PREPARE stmt_add_goods_name;

-- 检查并添加 img 字段（如果不存在）
SET @sql_add_img = (
    SELECT IF(
        (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
         WHERE TABLE_SCHEMA = DATABASE() 
         AND TABLE_NAME = 'orders' 
         AND COLUMN_NAME = 'img') = 0,
        'ALTER TABLE orders ADD COLUMN img varchar(500) DEFAULT NULL COMMENT "商品图片" AFTER goods_name;',
        'SELECT "img column already exists" as result;'
    )
);

PREPARE stmt_add_img FROM @sql_add_img;
EXECUTE stmt_add_img;
DEALLOCATE PREPARE stmt_add_img;

-- 为现有订单数据补充商品名称和图片信息
UPDATE orders o 
INNER JOIN goods g ON o.goods_id = g.id 
SET o.goods_name = g.name, o.img = g.img 
WHERE o.goods_name IS NULL OR o.goods_name = '' OR o.img IS NULL OR o.img = '';

-- 显示当前 orders 表结构
DESCRIBE orders;

-- 显示迁移完成信息
SELECT 'Orders table migration completed successfully!' as result; 