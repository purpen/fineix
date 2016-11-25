//
//  SubOrderModel.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoModel.h"

@interface SubOrderModel : NSObject

@property (nonatomic, strong) NSString * rid;                   //订单唯一编号
@property (nonatomic, strong) NSString * expressNo;             //快递单号
@property (nonatomic, strong) NSString * expressCompany;        //快递公司
@property (nonatomic, strong) NSString * expressCaty;           //快递
@property (nonatomic, assign) NSInteger  isSended;              //是否发货
@property (nonatomic, strong) NSArray  * productInfos;          //产品列表

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
