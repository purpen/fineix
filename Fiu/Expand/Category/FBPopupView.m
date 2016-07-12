//
//  FBPopupView.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPopupView.h"
#import "FBShareViewController.h"

@interface FBPopupView () {
    UIWindow        *   _popWindow;
    NSString        *   _text;
    NSDictionary    *   _sceneData;
    UIView          *   _bgView;
    UIView          *   _popView;
    UIButton        *   _closeBtn;
    UIButton        *   _shareBtn;
    UILabel         *   _shareText;
    UIView          *   _bottomView;
}

@end

@implementation FBPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showPopupViewOnWindowStyleOne:(NSString *)text withSceneData:(NSDictionary *)data {
    _text = text;
    _sceneData = data;
    [self setAlertStyleOneUI];
}

- (void)showPopupViewOnWindowStyleTwo:(NSString *)text {
    
}

- (void)setAlertStyleOneUI {
    _popWindow = [UIApplication sharedApplication].keyWindow;
    
    _bgView = [self getBgView];
    [_popWindow addSubview:_bgView];
    
}

- (UIView *)getPopView {
    UIView * popView = [[UIView alloc] init];
    popView.backgroundColor = [UIColor whiteColor];
    popView.layer.cornerRadius = 5;
    popView.layer.masksToBounds = YES;
    
    _closeBtn = [self getCloseBtn];
    [popView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(popView.mas_right).with.offset(0);
        make.top.equalTo(popView.mas_top).with.offset(0);
    }];
    
    _shareBtn = [self getShareBtn];
    [popView addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 44));
        make.centerX.equalTo(popView);
        make.top.equalTo(popView.mas_top).with.offset(70);
    }];
    
    _shareText = [self getShareText];
    [popView addSubview:_shareText];
    [_shareText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230, 50));
        make.centerX.equalTo(popView);
        make.top.equalTo(_shareBtn.mas_bottom).with.offset(15);
    }];
    
    _bottomView = [self getBottomView];
    [popView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 80));
        make.centerX.equalTo(popView);
        make.bottom.equalTo(popView.mas_bottom).with.offset(-20);
    }];
    
    return popView;
}

- (UIView *)getBgView {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
    
    _popView = [self getPopView];
    [bgView addSubview:_popView];
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.centerY.equalTo(bgView);
        make.centerX.equalTo(bgView);
    }];
    
    return bgView;
}

- (UIButton *)getCloseBtn {
    UIButton * closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"jifen_close"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    return closeBtn;
}

- (void)closeBtnClick {
    for (UIView * view in _popWindow.subviews) {
        if ([view isEqual:_bgView]) {
            [view removeFromSuperview];
        }
    }
}

- (UIButton *)getShareBtn {
    UIButton * shareBtn = [[UIButton alloc] init];
    shareBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
    [shareBtn setTitle:NSLocalizedString(@"ShareBtn", nil) forState:(UIControlStateNormal)];
    shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareBtn.layer.cornerRadius = 3;
    [shareBtn addTarget:self action:@selector(searchBarClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    return shareBtn;
}

- (void)searchBarClick {
    if ([_sceneData valueForKey:@"cover_url"]) {
        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
        shareVC.dataDict = _sceneData;
        [self.vc presentViewController:shareVC animated:YES completion:nil];
    }
}

- (UILabel *)getShareText {
    UILabel * shareText = [[UILabel alloc] init];
    shareText.textColor = [UIColor colorWithHexString:@"#222222"];
    shareText.font = [UIFont systemFontOfSize:14];
    shareText.textAlignment = NSTextAlignmentCenter;
    shareText.numberOfLines = 0;
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:_text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    shareText.attributedText = contentText;
    return shareText;
}

- (UIView *)getBottomView {
    UIView * bottomView = [[UIView alloc] init];
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [bottomView addSubview:line];
    
    NSArray * iconImg = @[@"jifen_weixin", @"jifen_friend", @"jifen_weibo", @"jifen_qq"];
    
    for (NSUInteger idx = 0; idx < 4; ++ idx) {
        UIButton * shareIcon = [[UIButton alloc] initWithFrame:CGRectMake(10 + (60 * idx), 20, 40, 40)];
        [shareIcon setImage:[UIImage imageNamed:iconImg[idx]] forState:(UIControlStateNormal)];
        shareIcon.layer.cornerRadius = 20;
        shareIcon.layer.masksToBounds = YES;
        
        [bottomView addSubview:shareIcon];
    }
    
    return bottomView;
}

@end
