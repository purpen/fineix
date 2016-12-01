//
//  ProductInfoModel.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/24.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoModel : NSObject

@property (nonatomic, strong) NSString * coverUrl;      //封面图
@property (nonatomic, strong) NSString * name;          //名称
@property (nonatomic, strong) NSString * skuName;       //sku名称
@property (nonatomic, strong) NSString * refundLabel;   //sku名称
@property (nonatomic, strong) NSNumber *price;          //价格
@property (nonatomic, assign) NSString *productId;      //产品ID
@property (nonatomic, assign) NSInteger quantity;       //数量
@property (nonatomic, assign) NSInteger refundStatus;   //退货状态
@property (nonatomic, assign) NSInteger refundType;     //退货类型
@property (nonatomic, assign) NSInteger refundButton;   //退货按钮类型
@property (nonatomic, strong) NSNumber *salePrice;      //实际支付价格
@property (nonatomic, assign) NSInteger sku;            //具体型号产品ID
@property (nonatomic, assign) NSInteger vopId;          //京东商品id

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
