//
//  CarGoodsModelItem.h
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarGoodsModelItem : NSObject

@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString * skuMode;
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger vopId;
@property (nonatomic, strong) NSString *referralCode;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
