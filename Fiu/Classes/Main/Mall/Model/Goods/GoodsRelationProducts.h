//
//  GoodsRelationProducts.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsRelationProducts : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) CGFloat salePrice;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
