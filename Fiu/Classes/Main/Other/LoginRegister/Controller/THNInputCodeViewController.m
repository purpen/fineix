//
//  THNInputCodeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNInputCodeViewController.h"
#import "THNTFCodeView.h"
#import "Masonry.h"
#import "THNSetPwdViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"

@interface THNInputCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/**  */
@property (nonatomic, strong) THNTFCodeView *tFView;
/**  */
@property (nonatomic, strong) UIButton *commitBtn;
@end

static NSString *const checkVerify = @"/auth/check_verify_code";//第三方登录接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation THNInputCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tFView];
    [self.tFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.tFView.mas_bottom).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = [UIColor blackColor];
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.layer.cornerRadius = 3;
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitBtn setTitleColor:[UIColor colorWithRed:148/255.0 green:107/255.0 blue:16/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

-(void)commitClick{
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //请求数据，如果正确就跳转
    FBRequest *request = [FBAPI postWithUrlString:checkVerify requestDictionary:@{
                                                                                @"phone" : self.phoneString,
                                                                                @"code"  : self.tFView.textField.text
                                                                                } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        THNSetPwdViewController *vc = [[THNSetPwdViewController alloc] init];
        vc.phoneStr = self.phoneString;
        vc.codeStr = self.tFView.textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    }];
}

-(THNTFCodeView *)tFView{
    if (!_tFView) {
        _tFView = [[THNTFCodeView alloc] initWithFrame:CGRectMake(80, 220, 200, 44)];
        _tFView.elementCount = 6;
    }
    return _tFView;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
