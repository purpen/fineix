//
//  THNAddChildUserViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNAddChildUserViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *authField;
@property (nonatomic, strong) UIButton    *sendAuthButton;
@property (nonatomic, strong) UIView      *sendButtonView;
@property (nonatomic, strong) FBRequest   *isRegisterRequest;
@property (nonatomic, strong) FBRequest   *authRequest;
@property (nonatomic, strong) FBRequest   *saveRequest;
@property (nonatomic, strong) FBRequest   *checkAuthRequest;
@property (nonatomic, strong) UIView      *passView;
@property (nonatomic, strong) UITextField *setPassField;
@property (nonatomic, strong) UITextField *donePassField;

@end
