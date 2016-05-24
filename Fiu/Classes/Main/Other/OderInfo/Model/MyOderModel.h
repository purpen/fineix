//
//  MyOderModel.h
//  Fiu
//
//  Created by THN-Dong on 16/5/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOderModel : NSObject

@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,strong) NSNumber *status;
@property(nonatomic,copy) NSString *cover_url;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *sku_name;
@property(nonatomic,strong) NSNumber *quantity;
@property(nonatomic,strong) NSNumber *sale_price;
@property(nonatomic,strong) NSNumber *total_money;

@end
