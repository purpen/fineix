//
//  BonusModel.h
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonusModel : NSObject

@property (nonatomic, strong) NSNumber *amount;           //红包金额
@property (nonatomic, strong) NSString * code;          //红包码
@property (nonatomic, strong) NSString * expiredLabel;  //过期时间
@property (nonatomic, strong) NSNumber *minAmount;        //最低使用限额
/**  */
@property (nonatomic, assign) NSInteger product_id;
/**  */
@property(nonatomic,copy) NSString *product_name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
