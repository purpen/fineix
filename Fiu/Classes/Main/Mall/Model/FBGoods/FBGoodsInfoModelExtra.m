//
//  FBGoodsInfoModelExtra.m
//  Fiu
//
//  Created by FLYang on 2017/3/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "FBGoodsInfoModelExtra.h"

NSString *const kFBGoodsInfoModelExtra = @"disabled_app_reduce";

@implementation FBGoodsInfoModelExtra

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kFBGoodsInfoModelExtra] isKindOfClass:[NSNull class]]){
        self.disabledAppReduce = [dictionary[kFBGoodsInfoModelExtra] integerValue];
    }
    return self;
}
@end
