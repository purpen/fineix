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
    FiuPeopleView *view = [[NSBundle mainBundle] loadNibNamed:@"FiuPeople" owner:nil options:nil][0];
    for (UIButton *sender in view.subviews) {
        [view getRound:sender];
        CGRect frame = sender.frame;
        frame.size = CGSizeMake(frame.size.width/667.0*SCREEN_HEIGHT, frame.size.height/667.0*SCREEN_HEIGHT);
        sender.frame = frame;
    }
    return view;
}

-(void)getRound:(UIButton*)btn{
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.width*0.5;
}

@end
