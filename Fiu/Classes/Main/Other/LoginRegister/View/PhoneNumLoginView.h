//
//  PhoneNumLoginView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumLoginView : UIView

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *soonBtn;
@property (nonatomic, strong) UIButton *forgetBtn;

-(instancetype)init;

@end
