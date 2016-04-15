//
//  ChanelViewTwo.m
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChanelViewTwo.h"

@implementation ChanelViewTwo

+(instancetype)getChanelViewTwo{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][2];
}

@end
