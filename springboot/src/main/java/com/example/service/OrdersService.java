package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.entity.Goods;
import com.example.entity.Orders;
import com.example.entity.Policy;
import com.example.entity.User;
import com.example.exception.CustomException;
import com.example.mapper.GoodsMapper;
import com.example.mapper.OrdersMapper;
import com.example.mapper.PolicyMapper;
import com.example.mapper.UserMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class OrdersService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private UserMapper userMapper;
    @Resource
    private GoodsMapper goodsMapper;

    /**
     * 新增
     */
    public void add(Orders orders) {
        // 检查商品是否存在
        Goods goods = goodsMapper.selectById(orders.getGoodsId());
        if (ObjectUtil.isEmpty(goods)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "商品不存在");
        }
        
        // 检查库存
        if (goods.getNum() <= 0) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "商品库存不足");
        }
        
        // 获取用户信息并判断余额
        User user = userMapper.selectById(orders.getUserId());
        if (ObjectUtil.isEmpty(user)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR.code, "用户不存在");
        }
        if (user.getAccount() < orders.getPrice()) {
            throw new CustomException(ResultCodeEnum.ACCOUNT_LOWER_ERROR);
        }
        
        // 设置订单信息（只设置数据库中存在的字段）
        orders.setOrderId(DateUtil.format(new Date(), "yyyyMMddHHmmss"));
        orders.setTime(DateUtil.now());
        orders.setGoodsName(goods.getName());  // 设置商品名称
        orders.setImg(goods.getImg());         // 设置商品图片
        // 注意：不设置 userName，该字段在数据库中不存在，在查询时动态获取
        
        // 插入订单
        ordersMapper.insert(orders);

        // 扣除用户余额
        user.setAccount(user.getAccount() - orders.getPrice());
        userMapper.updateById(user);

        // 减少商品库存
        goods.setNum(goods.getNum() - 1);
        goodsMapper.updateById(goods);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        ordersMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            ordersMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Orders orders) {
        ordersMapper.updateById(orders);
    }

    /**
     * 根据ID查询
     */
    public Orders selectById(Integer id) {
        return ordersMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Orders> selectAll(Orders orders) {
        return ordersMapper.selectAll(orders);
    }

    /**
     * 分页查询
     */
    public PageInfo<Orders> selectPage(Orders orders, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        
        // 为每个订单设置用户名称（userName字段不存储在数据库中，需要动态查询）
        for (Orders dbOrders : list) {
            User user = userMapper.selectById(dbOrders.getUserId());
            if (ObjectUtil.isNotEmpty(user)) {
                dbOrders.setUserName(user.getName());
            }
            
            // 对于历史数据，如果商品名称或图片为空，则补充查询
            if (ObjectUtil.isEmpty(dbOrders.getGoodsName()) || ObjectUtil.isEmpty(dbOrders.getImg())) {
                Goods goods = goodsMapper.selectById(dbOrders.getGoodsId());
                if (ObjectUtil.isNotEmpty(goods)) {
                    if (ObjectUtil.isEmpty(dbOrders.getGoodsName())) {
                        dbOrders.setGoodsName(goods.getName());
                    }
                    if (ObjectUtil.isEmpty(dbOrders.getImg())) {
                        dbOrders.setImg(goods.getImg());
                    }
                }
            }
        }
        
        return PageInfo.of(list);
    }

}