//
//  ProductInfoView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ProductInfoView.h"

@implementation ProductInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getProductInfoView{
    return [[NSBundle mainBundle] loadNibNamed:@"ProductInfoView" owner:nil options:nil][0];
}

@end
