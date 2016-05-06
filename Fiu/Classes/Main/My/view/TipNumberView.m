//
//  TipNumberView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TipNumberView.h"

@implementation TipNumberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getTipNumView{
    TipNumberView *numV = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][1];
    numV.layer.masksToBounds = YES;
    numV.layer.cornerRadius = 15*0.5;
    return numV;
}


@end
