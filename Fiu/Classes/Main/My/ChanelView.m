//
//  ChanelView.m
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChanelView.h"

@implementation ChanelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getChanelView{
    return [[NSBundle mainBundle] loadNibNamed:@"chanel" owner:nil options:nil][0];
}

@end
