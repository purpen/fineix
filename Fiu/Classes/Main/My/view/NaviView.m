//
//  NaviView.m
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NaviView.h"

@interface NaviView ()



@end

@implementation NaviView

+(instancetype)getNaviView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][1];
}

@end
