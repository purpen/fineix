//
//  SignupView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *setPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;
@property (weak, nonatomic) IBOutlet UIView *toResendV;
@property (weak, nonatomic) IBOutlet UILabel *backToTheTimeL;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
+(instancetype)getSignupView;

@end
