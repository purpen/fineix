//
//  SubmitView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *toResendV;
@property (weak, nonatomic) IBOutlet UILabel *backToTheTimeL;
@property (weak, nonatomic) IBOutlet UITextField *setANewPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

+(instancetype)getSubmitView;

@end
