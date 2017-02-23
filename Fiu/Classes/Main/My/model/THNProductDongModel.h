//
//  THNProductDongModel.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNProductDongModel : NSObject

@property(nonatomic,copy) NSString *_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *short_title;
@property(nonatomic,copy) NSString *sale_price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *cover_url;
@property(nonatomic,strong) NSArray *category_ids;

@end
