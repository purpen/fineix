//
//  FBGoodsInfoModelExtra.h
//  Fiu
//
//  Created by FLYang on 2017/3/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBGoodsInfoModelExtra : NSObject

@property (nonatomic, assign) NSInteger disabledAppReduce;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
