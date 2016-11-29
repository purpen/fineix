//
//  RefundGoodsModel.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface RefundGoodsModel : NSObject

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *createdOn;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) CGFloat refundPrice;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, strong) NSString *stageLabel;
@property (nonatomic, strong) ProductModel *product;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, assign) NSInteger type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
