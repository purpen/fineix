//
//  BotView.m
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BotView.h"

@implementation BotView

+(instancetype)getBotView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][0];
}

@end
