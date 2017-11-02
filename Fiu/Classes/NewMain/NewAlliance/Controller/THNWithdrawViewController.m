//
//  THNWithdrawViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawViewController.h"
#import "UIView+TYAlertView.h"
#import "THNZhangHuView.h"
#import "UIView+FSExtension.h"
#import "THNZhangHuModel.h"
#import "MJExtension.h"

static NSString *const URLAliance = @"/alliance/view";
static NSString *const URLApply = @"/withdraw_cash/apply_cash";

@interface THNWithdrawViewController ()

/**  */
@property (nonatomic, strong) THNZhangHuView *zhangHuView;
/**  */
@property (nonatomic, assign) ZhangHu zhangHu;
/**  */
@property (nonatomic, strong) THNZhangHuModel *zhangHuModel;

@end

@implementation THNWithdrawViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_registerNotification];
    [self thn_networkAllinaceListData];
}

#pragma mark - 请求账户数据
- (void)thn_networkAllinaceListData {
    [SVProgressHUD show];
    self.alianceRequest = [FBAPI postWithUrlString:URLAliance requestDictionary:@{} delegate:self];
    [self.alianceRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dict = [result valueForKey:@"data"];
        self.dataModel = [[THNAllinaceData alloc] initWithDictionary:dict];
        FBRequest *zhangHuRequest = [FBAPI postWithUrlString:@"/payment_card/defaulted" requestDictionary:nil delegate:self];
        [zhangHuRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            self.zhangHuModel = [THNZhangHuModel mj_objectWithKeyValues:dataDict];
            if ([dataDict[@"has_default"] integerValue] == 0) {
                self.zhangHu = none;
            } else {
                if ([dataDict[@"pay_type_label"] rangeOfString:@"银行"].location != NSNotFound) {
                    self.zhangHu = YingHangKa;
                } else {
                    self.zhangHu = zhiFuBao;
                }
            }
            [self setViewUI];
            [SVProgressHUD dismiss];
        } failure:^(FBRequest *request, NSError *error) {
        }];
        
    } failure:^(FBRequest *request, NSError *error) {
    }];
}

#pragma mark - 申请提现
- (void)thn_networkApplyCash {
    [SVProgressHUD show];
    NSString *money = self.withdrawView.moneyTextField.text;
    if (self.dataModel.idField.length > 0 && [money floatValue] >= 10) {
        self.applyRequest = [FBAPI postWithUrlString:URLApply
                                   requestDictionary:@{@"id":self.dataModel.idField,
                                                       @"amount":self.withdrawView.moneyTextField.text,
                                                       @"payment_card_id" : self.zhangHuView.model._id
                                                       }
                                            delegate:self];
        [self.applyRequest startRequestSuccess:^(FBRequest *request, id result) {
            [self thn_showAlertViewTitle:@"申请成功" text:@"可在提现记录中查看提现进度" buttonTitle:@"确认" type:1];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark - 注册通知
- (void)thn_registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(a) name:@"canWithdrawalMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(b) name:@"canNotWithdrawalMoney" object:nil];
}

- (void)a {
    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    self.sureButton.userInteractionEnabled = YES;
}

- (void)b {
    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#8D8D8D"];
    self.sureButton.userInteractionEnabled = NO;
}

#pragma mark - 设置界面UI
- (void)setViewUI {
    [self.view addSubview:self.zhangHuView];
    [self.view addSubview:self.withdrawView];
    [_withdrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
        make.left.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.zhangHuView.mas_bottom).with.offset(15);
    }];
    [self.view addSubview:self.sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 35));
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(_withdrawView.mas_bottom).with.offset(106/2);
    }];
}


-(THNZhangHuView *)zhangHuView{
    if (!_zhangHuView) {
        if (Is_iPhoneX) {
            _zhangHuView = [[THNZhangHuView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 88)];
        } else {
            _zhangHuView = [[THNZhangHuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        }
        _zhangHuView.nav = self.navigationController;
        _zhangHuView.model = self.zhangHuModel;
        _zhangHuView.zhangHu = self.zhangHu;
        switch (self.zhangHu) {
            case none:
            {_zhangHuView.height = 44;}
            break;
            case zhiFuBao:
            {_zhangHuView.height = 60;}
            break;
            case YingHangKa:
            {_zhangHuView.height = 60;}
            break;
            
            default:
            break;
        }
    }
    return _zhangHuView;
}

- (THNWithdrawView *)withdrawView {
    if (!_withdrawView) {
        _withdrawView = [[THNWithdrawView alloc] init];
        [_withdrawView thn_setCanWithdrawMoneyData:self.dataModel.waitCashAmount];
    }
    return _withdrawView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.layer.cornerRadius = 3.0f;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitle:@"申请提现" forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"8D8D8D"];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

#pragma mark - 确认提现
- (void)sureButtonClick:(UIButton *)button {
    [self.withdrawView.moneyTextField resignFirstResponder];

    NSString *title = [NSString stringWithFormat:@"￥%.2f", [self.withdrawView.moneyTextField.text floatValue]];
    NSString *text = @"请确认要提现的金额";
    [self thn_showAlertViewTitle:title text:text buttonTitle:@"提现" type:0];
}

- (void)thn_showAlertViewTitle:(NSString *)title text:(NSString *)text buttonTitle:(NSString *)buttonTitle type:(NSInteger)type {

    TYAlertView *alertView = [TYAlertView alertViewWithTitle:title message:text];
    alertView.layer.cornerRadius = 10;
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
    [alertView addAction:[TYAlertAction actionWithTitle:buttonTitle style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
        if (type == 0) {
            //  确认提现
            [self thn_networkApplyCash];
        } else if (type == 1) {
            //  确认返回
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }]];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"提现";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canWithdrawalMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canNotWithdrawalMoney" object:nil];
}

@end
