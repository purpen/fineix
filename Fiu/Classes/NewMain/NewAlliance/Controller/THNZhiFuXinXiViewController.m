//
//  THNZhiFuXinXiViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhiFuXinXiViewController.h"
#import "Fiu.h"

@interface THNZhiFuXinXiViewController ()<THNNavigationBarItemsDelegate>

/**  */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIView *zhangHuView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *yanZhengView;

@end

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
    NSLog(@"保存");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(64);
        make.height.mas_equalTo(120/2*SCREEN_HEIGHT/667.0);
    }];
    
    [self.view addSubview:self.nameView];
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
    }];
    
    [self.view addSubview:self.zhangHuView];
    [_zhangHuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
    }];
    
    [self.view addSubview:self.phoneView];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.zhangHuView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
    }];

    [self.view addSubview:self.yanZhengView];
    [_yanZhengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.phoneView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
    }];
    
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
        
        UITextField *textF = [[UITextField alloc] init];
        textF.borderStyle = UITextBorderStyleNone;
        textF.placeholder = @"输入短信验证码";
        [_yanZhengView addSubview:textF];
        textF.font = [UIFont systemFontOfSize:14];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*SCREEN_HEIGHT/667.0);
            make.right.top.bottom.mas_equalTo(_yanZhengView).mas_offset(0);
        }];
    }
    return _yanZhengView;
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
        
        UITextField *textF = [[UITextField alloc] init];
        textF.borderStyle = UITextBorderStyleNone;
        textF.placeholder = @"输入手机号";
        [_zhangHuView addSubview:textF];
        textF.font = [UIFont systemFontOfSize:14];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*SCREEN_HEIGHT/667.0);
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
            make.width.mas_equalTo(65);
        }];
        
        UITextField *textF = [[UITextField alloc] init];
        textF.borderStyle = UITextBorderStyleNone;
        textF.placeholder = @"输入帐号";
        [_zhangHuView addSubview:textF];
        textF.font = [UIFont systemFontOfSize:14];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*SCREEN_HEIGHT/667.0);
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
        
        UITextField *textF = [[UITextField alloc] init];
        textF.borderStyle = UITextBorderStyleNone;
        textF.placeholder = @"输入姓名";
        [_nameView addSubview:textF];
        textF.font = [UIFont systemFontOfSize:14];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(15*SCREEN_HEIGHT/667.0);
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
            make.width.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
            make.left.mas_equalTo(_topView.mas_left).mas_offset(15);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#232323"];
        label.text = @"绑定支付宝帐号";
        [_topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(20*SCREEN_HEIGHT/667.0);
        }];
    }
    return _topView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
