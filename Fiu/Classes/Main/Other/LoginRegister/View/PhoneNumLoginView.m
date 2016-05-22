//
//  PhoneNumLoginView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PhoneNumLoginView.h"
#import "Fiu.h"

@implementation PhoneNumLoginView

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350/667.0*SCREEN_HEIGHT);
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 345/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT)];
        CGPoint center = _phoneTF.center;
        center.x = self.center.x;
        _phoneTF.center = center;
        _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
        _phoneTF.placeholder = @"手机号或邮箱";
        _phoneTF.font = [UIFont systemFontOfSize:13];
        _phoneTF.backgroundColor = [UIColor whiteColor];
        _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 113/2/667.0*SCREEN_HEIGHT, 345/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT)];
        CGPoint centerpwd = _pwdTF.center;
        centerpwd.x = self.center.x;
        _pwdTF.center = centerpwd;
        _pwdTF.borderStyle = UITextBorderStyleRoundedRect;
        _pwdTF.placeholder = @"密码";
        _pwdTF.secureTextEntry = YES;
        _pwdTF.font = [UIFont systemFontOfSize:13];
        _pwdTF.backgroundColor = [UIColor whiteColor];
        //登录按钮
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 227/2/667.0*SCREEN_HEIGHT, 345/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT)];
        CGPoint btncenter = _loginBtn.center;
        btncenter.x = self.center.x;
        _loginBtn.center = btncenter;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 3;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor whiteColor];
//        //快速注册按钮
//        _soonBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 346/2/667.0*SCREEN_HEIGHT, 120/2/667.0*SCREEN_HEIGHT, 25/667.0*SCREEN_HEIGHT)];
//        CGRect soonBtnframe = _soonBtn.frame;
//        soonBtnframe.origin.x = _phoneTF.frame.origin.x;
//        _soonBtn.frame = soonBtnframe;
//        [_soonBtn setTitle:@"快速注册" forState:UIControlStateNormal];
//        _soonBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //忘记密码按钮
        _forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 346/2/667.0*SCREEN_HEIGHT, 150/2/667.0*SCREEN_HEIGHT, 20/667.0*SCREEN_HEIGHT)];
        CGRect forgetBtnframe = _forgetBtn.frame;
        forgetBtnframe.origin.x = _phoneTF.frame.origin.x+_phoneTF.frame.size.width-_forgetBtn.frame.size.width + 12/667.0*SCREEN_HEIGHT;
        _forgetBtn.frame = forgetBtnframe;
        [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];

        //添加
        [self addSubview:_phoneTF];
        [self addSubview:_pwdTF];
        [self addSubview:_loginBtn];
        //[self addSubview:_soonBtn];
        [self addSubview:_forgetBtn];
    }
    return self;
}

@end
