//
//  SubmitView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubmitView.h"
#import "Fiu.h"

@implementation SubmitView

+(instancetype)getSubmitView{
    SubmitView *submitV = [[NSBundle mainBundle] loadNibNamed:@"Login" owner:nil options:nil][0];
    [submitV setFrametf:submitV.phoneNumTF];
    [submitV setFrametf:submitV.verificationCodeTF];
    [submitV setFrametf:submitV.setANewPasswordTF];
    [submitV setFrametf:submitV.sendVerificationCodeBtn];
    //[submitV setFrametf:submitV.submitBtn];
    [submitV setFrametf:submitV.toResendV];
    submitV.submitBtn.layer.masksToBounds = YES;
    submitV.submitBtn.layer.cornerRadius = 3;
    CGRect sendverFram =  submitV.sendVerificationCodeBtn.frame;
    sendverFram.origin.x = 150/667.0*SCREEN_HEIGHT;
    submitV.sendVerificationCodeBtn.frame = sendverFram;
    CGRect toResendVFram =  submitV.toResendV.frame;
    toResendVFram.origin.x = 150/667.0*SCREEN_HEIGHT;
    submitV.toResendV.frame = toResendVFram;
    submitV.toResendV.layer.masksToBounds = YES;
    submitV.toResendV.layer.cornerRadius = 3;
    submitV.sendVerificationCodeBtn.layer.masksToBounds = YES;
    submitV.sendVerificationCodeBtn.layer.cornerRadius = 3;
    return submitV;
}

-(void)setFrametf:(UIView*)tf{
    CGRect verificationCodeFrame = tf.frame;
    verificationCodeFrame.size.height = 44.0/667.0*SCREEN_HEIGHT;
    tf.frame = verificationCodeFrame;
}



@end
