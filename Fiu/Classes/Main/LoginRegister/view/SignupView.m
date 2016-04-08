//
//  SignupView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SignupView.h"

@implementation SignupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getSignupView{
    SignupView *signupV = [[NSBundle mainBundle] loadNibNamed:@"Signup" owner:nil options:nil][0];
    signupV.sendVerificationBtn.layer.masksToBounds = YES;
    signupV.sendVerificationBtn.layer.cornerRadius = 3;
    signupV.toResendV.layer.masksToBounds = YES;
    signupV.toResendV.layer.cornerRadius = 3;
    signupV.signupBtn.layer.masksToBounds = YES;
    signupV.signupBtn.layer.cornerRadius = 3;
    return signupV;
}

@end
