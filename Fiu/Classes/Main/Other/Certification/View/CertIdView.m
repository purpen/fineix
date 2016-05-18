//
//  CertIdView.m
//  Fiu
//
//  Created by THN-Dong on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CertIdView.h"

@implementation CertIdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getCertView{
    CertIdView *view = [[NSBundle mainBundle] loadNibNamed:@"Empty" owner:nil options:nil][0];
    view.subBtn.layer.masksToBounds = YES;
    view.subBtn.layer.cornerRadius = 3;
    return view;
}

@end
