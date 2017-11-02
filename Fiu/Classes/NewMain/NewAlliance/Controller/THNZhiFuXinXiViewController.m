//
//  THNZhiFuXinXiViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhiFuXinXiViewController.h"
#import "Fiu.h"
#import "NSString+Helper.h"

@interface THNZhiFuXinXiViewController ()<THNNavigationBarItemsDelegate>

/**  */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIView *zhangHuView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *yanZhengView;
/**  */
@property (nonatomic, strong) UITextField *phoneTF;
/**  */
@property (nonatomic, strong) UILabel *repostLabel;
/**  */
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *zhangHuTF;
@property (nonatomic, strong) UITextField *yanZhengMaTF;
@property (nonatomic, strong) UIView *moRenView;
/**  */
@property (nonatomic, strong) UISwitch *moRenSwitch;

@end

static NSString *const URLAliance = @"/alliance/view";

@implementation THNZhiFuXinXiViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"支付宝账户信息";
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"保存" image:nil];
}

-(void)thn_rightBarItemSelected{
    if (self.nameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
    } else if (self.zhangHuTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入账户"];
    } else if (self.phoneTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
    } else if (self.yanZhengMaTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
    } else {
        __block NSString *str;
        FBRequest *alianceRequest = [FBAPI postWithUrlString:URLAliance requestDictionary:@{} delegate:self];
        [alianceRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dict = [result valueForKey:@"data"];
            str = dict[@"_id"];
            FBRequest *requestTwo = [FBAPI postWithUrlString:@"/payment_card/save" requestDictionary:@{
                                                                                                    @"alliance_id" : str,
                                                                                                        @"kind" : @"2",
                                                                                                    @"account" : self.zhangHuTF.text,
                                                                                                    @"username" : self.nameTF.text,
                                                                                                    @"phone" : self.phoneTF.text,
                                                                                                    @"verify_code" : self.yanZhengMaTF.text,
                                                                                                    @"is_default" : @(self.moRenSwitch.isOn)
                                                                                                    } delegate:self];
            [requestTwo startRequestSuccess:^(FBRequest *request, id result) {
                [SVProgressHUD showSuccessWithStatus:@"成功绑定账户"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(FBRequest *request, NSError *error) {
            }];
        } failure:^(FBRequest *request, NSError *error) {
        }];
    }
}

-(void)setModel:(THNZhangHuModel *)model{
    _model = model;
    self.nameTF.text = model.username;
    self.zhangHuTF.text = model.account;
    self.phoneTF.text = model.phone;
    [self.moRenSwitch setOn:[model.is_default integerValue]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        if (Is_iPhoneX) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(88);
        }else {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(64);
        }
        make.height.mas_equalTo(120/2*self.screenHeight/667.0);
    }];
    
    [self.view addSubview:self.nameView];
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(44*self.screenHeight/667.0);
    }];
    
    [self.view addSubview:self.zhangHuView];
    [_zhangHuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*self.screenHeight/667.0);
    }];
    
    [self.view addSubview:self.phoneView];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.zhangHuView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*self.screenHeight/667.0);
    }];

    [self.view addSubview:self.yanZhengView];
    [_yanZhengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.phoneView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*self.screenHeight/667.0);
    }];
    
    [self.view addSubview:self.moRenView];
    [_moRenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.yanZhengView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(44*self.screenHeight/667.0);
    }];
    
    [self setModel:self.model];
}

-(UIView *)moRenView{
    if (!_moRenView) {
        _moRenView = [[UIView alloc] init];
        _moRenView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"设置为默认账户";
        [_moRenView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_moRenView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_moRenView.mas_left).mas_offset(15);
            make.width.mas_equalTo(100);
        }];
        
        _moRenSwitch = [[UISwitch alloc] init];
        [_moRenView addSubview:_moRenSwitch];
        [_moRenSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_moRenView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(_moRenView.mas_right).mas_offset(-15);
        }];
    }
    return _moRenView;
}

-(UIView *)yanZhengView{
    if (!_yanZhengView) {
        _yanZhengView = [[UIView alloc] init];
        _yanZhengView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"验证码";
        [_yanZhengView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_yanZhengView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_yanZhengView.mas_left).mas_offset(15);
            make.width.mas_equalTo(65);
        }];
        
        self.yanZhengMaTF = [[UITextField alloc] init];
        _yanZhengMaTF.borderStyle = UITextBorderStyleNone;
        _yanZhengMaTF.placeholder = @"输入短信验证码";
        [_yanZhengView addSubview:_yanZhengMaTF];
        _yanZhengMaTF.font = [UIFont systemFontOfSize:14];
        [_yanZhengMaTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*self.screenHeight/667.0);
            make.top.bottom.mas_equalTo(_yanZhengView).mas_offset(0);
            make.right.mas_equalTo(_yanZhengView.mas_right).mas_offset(-(68+30+20)/2);
        }];
        
        _repostLabel = [[UILabel alloc] init];
        _repostLabel.userInteractionEnabled = YES;
        _repostLabel.text = @"发送验证码";
        _repostLabel.textAlignment = NSTextAlignmentCenter;
        _repostLabel.font = [UIFont systemFontOfSize:13];
        _repostLabel.textColor = [UIColor colorWithHexString:@"#868686"];
        _repostLabel.layer.masksToBounds = YES;
        _repostLabel.layer.cornerRadius = 3;
        _repostLabel.layer.borderColor = [UIColor colorWithHexString:@"#d3d3d3"].CGColor;
        _repostLabel.layer.borderWidth = 0.5;
        [_yanZhengView addSubview:_repostLabel];
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(postTap) forControlEvents:UIControlEventTouchUpInside];
        [_yanZhengView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_yanZhengView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(_yanZhengView.mas_right).mas_offset(-15);
            make.top.mas_equalTo(_yanZhengView.mas_top).mas_offset(5);
            make.bottom.mas_equalTo(_yanZhengView.mas_bottom).mas_offset(-5);
            make.width.mas_equalTo(88);
        }];
        [_repostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_yanZhengView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(_yanZhengView.mas_right).mas_offset(-15);
            make.top.mas_equalTo(_yanZhengView.mas_top).mas_offset(5);
            make.bottom.mas_equalTo(_yanZhengView.mas_bottom).mas_offset(-5);
            make.width.mas_equalTo(88);
        }];
    }
    return _yanZhengView;
}

//开始倒计时准备重新发送
-(void)startTime{
    __block int timeout = 30;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //时间到了后重新发送view消失
                _repostLabel.text = @"发送验证码";
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _repostLabel.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}


-(void)postTap{
    if (![self.phoneTF.text checkTel]) {
        [SVProgressHUD showErrorWithStatus:@"手机号输入错误"];
        return;
    }
    FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/auth/verify_code?mobile=%@&type=5",self.phoneTF.text] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self startTime];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(UIView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        _phoneView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"手机号";
        [_phoneView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_phoneView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_phoneView.mas_left).mas_offset(15);
            make.width.mas_equalTo(65);
        }];
        
        self.phoneTF = [[UITextField alloc] init];
        self.phoneTF.borderStyle = UITextBorderStyleNone;
        self.phoneTF.placeholder = @"输入手机号";
        [_phoneView addSubview:self.phoneTF];
        self.phoneTF.font = [UIFont systemFontOfSize:14];
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*self.screenHeight/667.0);
            make.right.top.bottom.mas_equalTo(_phoneView).mas_offset(0);
        }];
    }
    return _phoneView;
}

-(UIView *)zhangHuView{
    if (!_zhangHuView) {
        _zhangHuView = [[UIView alloc] init];
        _zhangHuView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"支付宝账户";
        [_zhangHuView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_zhangHuView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_zhangHuView.mas_left).mas_offset(15);
            make.width.mas_equalTo(75);
        }];
        
        self.zhangHuTF = [[UITextField alloc] init];
        _zhangHuTF.borderStyle = UITextBorderStyleNone;
        _zhangHuTF.placeholder = @"输入帐号";
        [_zhangHuView addSubview:_zhangHuTF];
        _zhangHuTF.font = [UIFont systemFontOfSize:14];
        [_zhangHuTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*self.screenHeight/667.0);
            make.right.top.bottom.mas_equalTo(_zhangHuView).mas_offset(0);
        }];
    }
    return _zhangHuView;
}

-(UIView *)nameView{
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        _nameView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"真实姓名";
        [_nameView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_nameView.mas_left).mas_offset(15);
            make.width.mas_equalTo(65);
        }];
        
        self.nameTF = [[UITextField alloc] init];
        _nameTF.borderStyle = UITextBorderStyleNone;
        _nameTF.placeholder = @"输入姓名";
        [_nameView addSubview:_nameTF];
        _nameTF.font = [UIFont systemFontOfSize:14];
        [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*self.screenHeight/667.0);
            make.right.top.bottom.mas_equalTo(_nameView).mas_offset(0);
        }];
    }
    return _nameView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *tuBiao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipayBig"]];
        [_topView addSubview:tuBiao];
        [tuBiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topView.mas_centerY).mas_offset(0);
            make.width.height.mas_equalTo(44*self.screenHeight/667.0);
            make.left.mas_equalTo(_topView.mas_left).mas_offset(15);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#232323"];
        label.text = @"绑定支付宝帐号";
        [_topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(20*self.screenHeight/667.0);
        }];
    }
    return _topView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
