//
//  ProductInfoModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProductInfoModel : NSObject

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
