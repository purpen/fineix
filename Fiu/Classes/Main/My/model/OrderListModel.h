//
//  OrderListModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, OrderInfoState) {
//    OrderInfoStateExpired       = -1,       //已过期（可删除订单）
//    OrderInfoStateCancled       = 0,        //已取消（可删除订单）
//    OrderInfoStateWaitPayment   = 1,        //待付款（可取消订单、立即支付）
//    OrderInfoStateWaitDelivery  = 10,       //待发货（可申请退款）
//    OrderInfoStateRefunding     = 12,       //退款中（可查看详情）
//    OrderInfoStateRefunded      = 13,       //已退款（可删除订单）
//    OrderInfoStateWaitReceive   = 15,       //待收货（可确认收货）
//    OrderInfoStateWaitComment   = 16,       //待评价（可删除订单、发表评价）
//    OrderInfoStateCompleted     = 20,       //已完成（可删除订单）
//};

@interface OrderListModel : NSObject

@property (nonatomic, strong) NSString * idField;               //ID
@property (nonatomic, strong) NSString * addbookId;             //收货地址ID
@property (nonatomic, assign) NSInteger birdCoinCount;          //鸟币数量
@property (nonatomic, assign) CGFloat birdCoinMoney;            //鸟币抵扣金额
@property (nonatomic, strong) NSString * cardCode;              //红包码
@property (nonatomic, assign) CGFloat cardMoney;                //红包抵扣金额
@property (nonatomic, assign) CGFloat coinMoney;                //优惠活动金额
@property (nonatomic, strong) NSString * createdAt;             //订单生成日期
@property (nonatomic, assign) CGFloat discount;                 //折扣
@property (nonatomic, assign) NSInteger expiredTime;            //订单过期时间
@property (nonatomic, strong) NSString * expressCaty;           //快递公司
//@property (nonatomic, strong) ExpressInfoModel * expressInfo;     //物流信息详细
@property (nonatomic, strong) NSString * expressNo;             //快递单号
@property (nonatomic, assign) CGFloat freight;                  //运费
@property (nonatomic, assign) NSInteger fromSite;               //来源站点1.web;6.wap;7.ios;8;android
@property (nonatomic, strong) NSString * giftCode;              //礼品券码
@property (nonatomic, assign) CGFloat giftMoney;                //礼品券抵扣金额
@property (nonatomic, strong) NSString * invoiceCaty;           //发票类型：1.个人；2.单位
@property (nonatomic, strong) NSString * invoiceContent;        //d:购买明细；o:办公用品;s:数码配件
@property (nonatomic, strong) NSString * invoiceTitle;          //发票抬头
@property (nonatomic, assign) NSInteger invoiceType;            //发票信息
@property (nonatomic, assign) NSInteger isPresaled;             //是否是预售订单
@property (nonatomic, strong) NSArray * productInfos;             //产品列表
@property (nonatomic, assign) NSInteger itemsCount;             //产品总数量
@property (nonatomic, assign) CGFloat payMoney;                 //实际支付金额
@property (nonatomic, strong) NSString * paymentMethod;         //支付方式
@property (nonatomic, strong) NSString * rid;                   //订单唯一编号
@property (nonatomic, assign) NSInteger sendedDate;             //发货日期
@property (nonatomic, assign) NSInteger orderStatus;            //订单状态
@property (nonatomic, strong) NSString * statusLabel;           //状态描述
@property (nonatomic, assign) CGFloat totalMoney;               //总金额
@property (nonatomic, assign) NSInteger userId;                 //购买用户ID

@property (nonatomic, strong) NSString * coverUrl;      //封面图
@property (nonatomic, strong) NSString * name;          //名称
@property (nonatomic, strong) NSString * skuName;       //sku名称
@property (nonatomic, assign) CGFloat price;            //价格
@property (nonatomic, assign) NSInteger productId;      //产品ID
@property (nonatomic, assign) NSInteger quantity;       //数量
@property (nonatomic, assign) CGFloat salePrice;        //实际支付价格
@property (nonatomic, assign) NSInteger sku;            //具体型号产品ID

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
