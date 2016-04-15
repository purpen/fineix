//
//  MyHomeV.m
//  Fiu
//
//  Created by THN-Dong on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomeV.h"

@implementation MyHomeV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)geMyHomeV{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][7];
}

@end
