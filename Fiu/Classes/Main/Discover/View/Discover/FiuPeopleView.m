//
//  FiuPeopleView.m
//  Fiu
//
//  Created by THN-Dong on 16/5/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleView.h"
#import "Fiu.h"

@implementation FiuPeopleView

+(instancetype)getFiuPeopleView{
    FiuPeopleView *view;
    if (SCREEN_WIDTH == 414) {
       view = [[NSBundle mainBundle] loadNibNamed:@"FiuPeople" owner:nil options:nil][1];
    }else if (SCREEN_WIDTH == 375){
        view = [[NSBundle mainBundle] loadNibNamed:@"FiuPeople" owner:nil options:nil][0];
    }else if (SCREEN_WIDTH == 320){
        view = [[NSBundle mainBundle] loadNibNamed:@"FiuPeople" owner:nil options:nil][2];
    }
    
    for (UIButton *sender in view.subviews) {
        [view getRound:sender];
        CGRect frame = sender.frame;
        frame.size = CGSizeMake(frame.size.width/667.0*SCREEN_HEIGHT, frame.size.height/667.0*SCREEN_HEIGHT);
        sender.frame = frame;
    }
    return view;
}

-(void)getRound:(UIButton*)btn{
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 0)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = btn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    btn.layer.mask = maskLayer;
//    btn.layer.cornerRadius = btn.frame.size.width*0.5;
//    btn.layer.masksToBounds = YES;
    
    btn.layer.cornerRadius = btn.frame.size.width*0.5;
    btn.layer.masksToBounds = YES;
    btn.layer.shouldRasterize = YES;
    btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
