//
//  OrderItems.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItems : NSObject

@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, assign) NSInteger sku;
@property (nonatomic, assign) CGFloat subtotal;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * viewUrl;
@property (nonatomic, strong) NSString * skuMode;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
