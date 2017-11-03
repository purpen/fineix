//
//  THNAllianceInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAllianceInfoViewController.h"

static NSString *const URLAllianceInfo = @"/alliance/info";

@interface THNAllianceInfoViewController ()

@end

@implementation THNAllianceInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkAllianceInfoData];
    [self.view addSubview:self.infoText];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        self.infoText.frame = CGRectMake(15, 88, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 88);
    }
}

- (void)thn_networkAllianceInfoData {
    self.infoRequest = [FBAPI postWithUrlString:URLAllianceInfo requestDictionary:@{} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dict = [result valueForKey:@"data"];
        [self thn_setAllianceInfoText:dict[@"info"]];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)thn_setAllianceInfoText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, text.length)];
    self.infoText.attributedText = attStr;
}

- (UITextView *)infoText {
    if (!_infoText) {
        _infoText = [[UITextView alloc] initWithFrame:CGRectMake(15, 64, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 64)];
        _infoText.font = [UIFont systemFontOfSize:14];
        _infoText.textColor = [UIColor colorWithHexString:@"#222222"];
        _infoText.editable = NO;
        _infoText.showsVerticalScrollIndicator = NO;
    }
    return _infoText;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"结算规则";
}


@end
