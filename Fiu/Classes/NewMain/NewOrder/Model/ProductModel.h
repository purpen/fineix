//
//  ProductModel.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductModel : NSObject

@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, strong) NSString *skuName;
@property (nonatomic, strong) NSString *title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
