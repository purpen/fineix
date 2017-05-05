//
//  THNAddChildUserViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAddChildUserViewController.h"
#import "NSString+Helper.h"

static NSInteger const textFieldTag = 1646;
static NSString *const URLCheckAccount = @"/auth/check_account";
static NSString *const URLCheckAuth = @"/auth/check_verify_code";
static NSString *const URLVerifyCode = @"/auth/verify_code";
static NSString *const URLSaveUser = @"/storage_manage/save";
static NSInteger const MAX_SCALE = 100;

@interface THNAddChildUserViewController () {
    NSString *_phoneNumDone;
    NSString *_name;
    NSString *_auth;
    NSString *_setPassword;
    NSString *_password;
    NSString *_scale;
    BOOL _isNewUser;
}

@end

@implementation THNAddChildUserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

#pragma mark - 网络
/**
 该账号是否注册过
 */
- (void)thn_networkIsRegisterUser:(NSString *)phoneNum {
    [self thn_checkPhoneIsRegister];
    self.isRegisterRequest = [FBAPI postWithUrlString:URLCheckAccount requestDictionary:@{@"account":phoneNum} delegate:nil];
    [self.isRegisterRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            self.passView.hidden = NO;
            _isNewUser = YES;
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

/**
 发送验证码
 */
- (void)thn_networkSendAuthCode:(NSString *)phoneNum {
    self.authRequest = [FBAPI postWithUrlString:URLVerifyCode requestDictionary:@{@"mobile":phoneNum} delegate:nil];
    [self.authRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"-------- 验证码 %@", result);
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

/**
 验证手机验证码

 @param phoneNum 手机号
 @param auth 验证码
 */
- (void)thn_networkCheckAuth:(NSString *)phoneNum authCode:(NSString *)auth addition:(NSString *)addition {
    self.checkAuthRequest = [FBAPI postWithUrlString:URLCheckAuth requestDictionary:@{@"phone":phoneNum, @"code":auth} delegate:nil];
    [self.checkAuthRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"--------- 验证码是否正确 %@", result);
        if (!_isNewUser) {
            [self thn_networkSaveUserInfo:_phoneNumDone userName:_name authCode:_auth addition:addition];
        } else {
            [self thn_checkPassword];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

/**
 保存新用户

 @param phoneNum 手机号
 @param name 姓名
 @param auth 验证码
 @param password 密码
 */
- (void)thn_networkNewSaveUserInfo:(NSString *)phoneNum name:(NSString *)name authCode:(NSString *)auth password:(NSString *)password  addition:(NSString *)addition {
    self.saveRequest = [FBAPI postWithUrlString:URLSaveUser requestDictionary:@{@"account"    :phoneNum,
                                                                                @"username"   :name,
                                                                                @"verify_code":auth,
                                                                                @"password"   :password,
                                                                                @"addition"   :addition} delegate:nil];
    [self.saveRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"====== 添加子账号%@", result);
        if ([[result valueForKey:@"success"] integerValue] ==1) {
            [SVProgressHUD showSuccessWithStatus:@"子账号添加成功" maskType:(SVProgressHUDMaskTypeBlack)];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

/**
 保存老用户
 
 @param phoneNum 手机号
 @param name 姓名
 @param auth 验证码
 */
- (void)thn_networkSaveUserInfo:(NSString *)phoneNum userName:(NSString *)name authCode:(NSString *)auth addition:(NSString *)addition {
    self.saveRequest = [FBAPI postWithUrlString:URLSaveUser requestDictionary:@{@"account"    :phoneNum,
                                                                                @"username"   :name,
                                                                                @"verify_code":auth,
                                                                                @"addition"   :addition} delegate:nil];
    [self.saveRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"====== 添加子账号%@", result);
        if ([[result valueForKey:@"success"] integerValue] ==1) {
            [SVProgressHUD showSuccessWithStatus:@"子账号添加成功" maskType:(SVProgressHUDMaskTypeBlack)];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

#pragma mark - UI
- (void)thn_setViewUI {
    NSArray *titleArr = @[@"    手机号", @"    验证码", @"    姓名"];
    [self thn_creatTextFieldView:titleArr];
    [self.view addSubview:self.scaleField];
    [self.view addSubview:self.passView];
}

- (void)thn_creatTextFieldView:(NSArray *)titleArr {
    for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + (44 * idx), SCREEN_WIDTH, 44)];
        textField.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        leftLabel.text = titleArr[idx];
        leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        textField.leftView = leftLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = textFieldTag + idx;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:textField];
        
        if (textField.tag == textFieldTag + 1) {
            textField.rightView = self.sendButtonView;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if (textField.tag == textFieldTag) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [textField addSubview:line];
        [self.view addSubview:textField];
    }
}

- (void)textFiledEditChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position || !selectedRange) {
        if (textField == self.phoneField) {
            _phoneNumDone = textField.text;
        }
        switch (textField.tag) {
            case textFieldTag +0:
                _phoneNumDone = textField.text;
                break;
                
            case textFieldTag +1:
                _auth = textField.text;
                break;
                
            case textFieldTag +2:
                _name = textField.text;
                break;
                
            case textFieldTag +3:
                if ([textField.text integerValue] > MAX_SCALE) {
                    [SVProgressHUD showInfoWithStatus:@"比例不能大于100%"];
                    textField.text = @"100";
                    return;
                }
                _scale = textField.text;
                break;
                
            case textFieldTag +4:
                _setPassword = textField.text;
                break;
                
            case textFieldTag +5:
                _password = textField.text;
                break;
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UIButton *)sendAuthButton {
    if (!_sendAuthButton) {
        _sendAuthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 83, 34)];
        _sendAuthButton.layer.cornerRadius = 3;
        _sendAuthButton.layer.borderWidth = 0.5;
        _sendAuthButton.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
        [_sendAuthButton setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendAuthButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _sendAuthButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendAuthButton addTarget:self action:@selector(sendAuthButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendAuthButton;
}

- (UIView *)sendButtonView {
    if (!_sendButtonView) {
        _sendButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 105, 42)];
        _sendButtonView.backgroundColor = [UIColor whiteColor];

        [_sendButtonView addSubview:self.sendAuthButton];
    }
    return _sendButtonView;
}

- (void)sendAuthButtonClick:(UIButton *)button {
    if (_phoneNumDone.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号"];
        return;
        
    } else  {
        if (![_phoneNumDone checkTel]) {
            [SVProgressHUD showInfoWithStatus:@"手机号格式不正确"];
            return;
        }
        [self thn_startCountdown:button];
        [self thn_networkIsRegisterUser:_phoneNumDone];
        [self thn_networkSendAuthCode:_phoneNumDone];
    }
}

- (void)thn_startCountdown:(UIButton *)button {
    __block int timeout = 30; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"发送验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
            
        } else {
            int seconds = timeout % 59;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 分成比例
- (UITextField *)scaleField {
    if (!_scaleField) {
        _scaleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 196, SCREEN_WIDTH, 44)];
        _scaleField.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 44)];
        leftLabel.text = @"    分成比例（％）";
        leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        _scaleField.leftView = leftLabel;
        _scaleField.leftViewMode = UITextFieldViewModeAlways;
        _scaleField.returnKeyType = UIReturnKeyDone;
        _scaleField.delegate = self;
        _scaleField.tag = textFieldTag + 3;
        _scaleField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFiledEditChanged:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:_scaleField];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [_scaleField addSubview:line];
    }
    return _scaleField;
}

#pragma mark - 设置密码视图
- (void)thn_creatPasswordTextFieldView {
    NSArray *titleArr = @[@"    设置密码", @"    确认密码"];
    for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 44 * idx, SCREEN_WIDTH, 44)];
        textField.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        leftLabel.text = titleArr[idx];
        leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        textField.leftView = leftLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = textFieldTag +idx +4;
        textField.secureTextEntry = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:textField];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [textField addSubview:line];
        [_passView addSubview:textField];
    }
}

- (UIView *)passView {
    if (!_passView) {
        _passView = [[UIView alloc] initWithFrame:CGRectMake(0, 255, SCREEN_WIDTH, 88)];
        _passView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self thn_creatPasswordTextFieldView];
        _passView.hidden = YES;
    }
    return _passView;
}

#pragma mark - 重新验证手机是否注册
- (void)thn_checkPhoneIsRegister {
    self.passView.hidden = YES;
    self.setPassField.text = nil;
    self.donePassField.text = nil;
    _setPassword = nil;
    _password = nil;
    _isNewUser = NO;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"添加子账号";
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"保存" image:@""];
}

#pragma mark - 保存子账号
- (void)thn_rightBarItemSelected {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    [self thn_validationSave];
}

/**
 验证资料填写
 */
- (void)thn_validationSave {
    if (_isNewUser) {
//         NSLog(@"======== 手机： %@, 姓名： %@, 验证码： %@, 密码： %@, 确认密码： %@,", _phoneNumDone, _name, _auth , _password, _setPassword);
        if (_name.length == 0 || _phoneNumDone.length == 0 || _auth.length == 0 || _setPassword.length == 0 || _password.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请将资料填写完整"];
            return;
        }
        
    } else {
//         NSLog(@"======== 手机： %@, 姓名： %@, 验证码： %@", _phoneNumDone, _name, _auth);
        if (_name.length == 0 || _phoneNumDone.length == 0 || _auth.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请将资料填写完整"];
            return;
        }
    }
   
    NSString *addition;
    if (self.scaleField.text.length == 0) {
        addition = @"1";
    } else {
        addition = [NSString stringWithFormat:@"%f", [self.scaleField.text floatValue] /100];
    }
    
    [self thn_networkCheckAuth:_phoneNumDone authCode:_auth addition:addition];
}

/**
 检查密码
 */
- (void)thn_checkPassword {
    if (![_setPassword isEqualToString:_password]) {
        [SVProgressHUD showInfoWithStatus:@"密码不一致,请重新输入"];
        return;
    }
    
    NSString *addition;
    if (self.scaleField.text.length == 0) {
        addition = @"1";
    } else {
        addition = [NSString stringWithFormat:@"%f", [self.scaleField.text floatValue] /100];
    }
    
    [self thn_networkNewSaveUserInfo:_phoneNumDone name:_name authCode:_auth password:_password addition:addition];
}

#pragma mark -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}


@end
