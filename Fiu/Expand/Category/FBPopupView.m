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
    UIView          *   _bgView;
    /*---发布情景成功样式---*/
    NSString        *   _text;
    NSDictionary    *   _sceneData;
    UIView          *   _popView;
    UIButton        *   _closeBtn;
    UIButton        *   _shareBtn;
    UILabel         *   _shareText;
    UIView          *   _bottomView;
     /*---分享成功样式---*/
    NSString        *   _shareDoneText;
    NSInteger           _shareExpNum;
    UIView          *   _donePopView;
    UIImageView     *   _doneTopImg;
    UILabel         *   _doneText;
    UIImageView     *   _goldIconBig;
    UIImageView     *   _goldIconSmall;
    UILabel         *   _addExpNum;
    UILabel         *   _addExpContent;
    UIButton        *   _doneBtn;
}

@end

@implementation FBPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _popWindow = [UIApplication sharedApplication].keyWindow;
        _bgView = [self getBgView];
        [_popWindow addSubview:_bgView];
        
    }
    return self;
}

#pragma mark - 默认背景
- (UIView *)getBgView {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
    return bgView;
}

#pragma mark - 分享成功提示框
- (void)showPopupViewOnWindowStyleTwo:(NSString *)text withAddJifen:(NSInteger)num {
    _shareDoneText = text;
    _shareExpNum = num;
    [self setAlertStyleTwoUI];
}

- (void)setAlertStyleTwoUI {
    _donePopView = [self getDonePopView];
    [_bgView addSubview:_donePopView];
    [_donePopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.centerY.equalTo(_bgView);
        make.centerX.equalTo(_bgView);
    }];
}

- (UIView *)getDonePopView {
    UIView * donePopView = [[UIView alloc] init];
    donePopView.backgroundColor = [UIColor whiteColor];
    donePopView.layer.cornerRadius = 5;
    donePopView.layer.masksToBounds = YES;
    
    _doneTopImg = [self getDoneTopImg];
    [donePopView addSubview:_doneTopImg];
    [_doneTopImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 47));
        make.top.equalTo(donePopView.mas_top).with.offset(0);
        make.centerX.equalTo(donePopView);
    }];
    
    _doneText = [self getDoneText];
    [donePopView addSubview:_doneText];
    [_doneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 20));
        make.top.equalTo(_doneTopImg.mas_bottom).with.offset(20);
        make.centerX.equalTo(donePopView);
    }];
    
    _goldIconBig = [self getGoldIconBig];
    [donePopView addSubview:_goldIconBig];
    [_goldIconBig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(61, 61));
        make.top.equalTo(_doneText.mas_bottom).with.offset(20);
        make.left.equalTo(donePopView.mas_left).with.offset(100);
    }];
    
    _goldIconSmall = [self getGoldIconSmall];
    [donePopView addSubview:_goldIconSmall];
    [_goldIconSmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 29));
        make.bottom.equalTo(_goldIconBig.mas_bottom).with.offset(-5);
        make.left.equalTo(_goldIconBig.mas_right).with.offset(10);
    }];
    
    _addExpNum = [self getAddExpNum];
    [donePopView addSubview:_addExpNum];
    [_addExpNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.top.equalTo(_doneText.mas_bottom).with.offset(15);
        make.left.equalTo(_goldIconBig.mas_right).with.offset(0);
    }];
    
    _addExpContent = [self getAddExpContent];
    [donePopView addSubview:_addExpContent];
    [_addExpContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230, 40));
        make.top.equalTo(_goldIconBig.mas_bottom).with.offset(15);
        make.centerX.equalTo(donePopView);
    }];
    
    _doneBtn = [self getDoneBtn];
    [donePopView addSubview:_doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 44));
        make.bottom.equalTo(donePopView.mas_bottom).with.offset(-20);
        make.centerX.equalTo(donePopView);
    }];
    
    return donePopView;
}

- (UIImageView *)getDoneTopImg {
    UIImageView * topImg = [[UIImageView alloc] init];
    topImg.image = [UIImage imageNamed:@"jifen_line"];
    
    return topImg;
}

- (UILabel *)getDoneText {
    UILabel * doneText = [[UILabel alloc] init];
    if (IS_iOS9) {
        doneText.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    } else {
        doneText.font = [UIFont systemFontOfSize:18];
    }
    doneText.textAlignment = NSTextAlignmentCenter;
    doneText.textColor = [UIColor colorWithHexString:@"#222222"];
    doneText.text = NSLocalizedString(@"shareDone", nil);
    
    return doneText;
}

- (UIImageView *)getGoldIconBig {
    UIImageView * goldIconBig = [[UIImageView alloc] init];
    goldIconBig.image = [UIImage imageNamed:@"jifen_big"];
    
    return goldIconBig;
}

- (UIImageView *)getGoldIconSmall {
    UIImageView * goldIconSmall = [[UIImageView alloc] init];
    goldIconSmall.image = [UIImage imageNamed:@"jifen_small"];
    
    return goldIconSmall;
}

- (UILabel *)getAddExpNum {
    UILabel * addExpNum = [[UILabel alloc] init];
    addExpNum.textColor = [UIColor colorWithHexString:fineixColor];
    if (IS_iOS9) {
        addExpNum.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    } else {
        addExpNum.font = [UIFont systemFontOfSize:18];
    }
    addExpNum.textAlignment = NSTextAlignmentCenter;
    addExpNum.text = [NSString stringWithFormat:@"＋%zi", _shareExpNum];
    
    return addExpNum;
}

- (UILabel *)getAddExpContent {
    UILabel * addExpContent = [[UILabel alloc] init];
    if (IS_iOS9) {
        addExpContent.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    } else {
        addExpContent.font = [UIFont systemFontOfSize:16];
    }
    addExpContent.textColor = [UIColor colorWithHexString:@"#666666"];
    addExpContent.textAlignment = NSTextAlignmentCenter;
    addExpContent.text = _shareDoneText;
    
    return addExpContent;
}

- (UIButton *)getDoneBtn {
    UIButton * doneBtn = [[UIButton alloc] init];
    doneBtn.layer.borderWidth = 0.5f;
    doneBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    [doneBtn setTitle:NSLocalizedString(@"doneAndKnow", nil) forState:(UIControlStateNormal)];
    if (IS_iOS9) {
        doneBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    } else {
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    [doneBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    return doneBtn;
}

- (void)doneBtnClick {
    for (UIView * view in _popWindow.subviews) {
        if ([view isEqual:_bgView]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - 发布情景成功提示框
- (void)showPopupViewOnWindowStyleOne:(NSString *)text withSceneData:(NSDictionary *)data {
    _text = text;
    _sceneData = data;
    [self setAlertStyleOneUI];
}

- (void)setAlertStyleOneUI {
    _popView = [self getPopView];
    [_bgView addSubview:_popView];
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 200));
        make.centerY.equalTo(_bgView);
        make.centerX.equalTo(_bgView);
    }];
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
    
    _shareText = [self getShareText];
    [popView addSubview:_shareText];
    [_shareText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230, 50));
        make.centerX.equalTo(popView);
        make.top.equalTo(popView.mas_top).with.offset(60);
    }];
    
    _shareBtn = [self getShareBtn];
    [popView addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 44));
        make.centerX.equalTo(popView);
        make.bottom.equalTo(popView.mas_bottom).with.offset(-30);
    }];
    
//    _bottomView = [self getBottomView];
//    [popView addSubview:_bottomView];
//    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(240, 80));
//        make.centerX.equalTo(popView);
//        make.bottom.equalTo(popView.mas_bottom).with.offset(-20);
//    }];
    
    return popView;
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
    if (IS_iOS9) {
        shareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    } else {
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareBtn.layer.cornerRadius = 3;
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    return shareBtn;
}

- (void)shareBtnClick {
    if ([_sceneData valueForKey:@"cover_url"]) {
        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
//        shareVC.dataDict = _sceneData;
        [self.vc presentViewController:shareVC animated:YES completion:^{
            [_bgView removeFromSuperview];
        }];
    }
}

- (UILabel *)getShareText {
    UILabel * shareText = [[UILabel alloc] init];
    shareText.textColor = [UIColor colorWithHexString:@"#222222"];
    if (IS_iOS9) {
        shareText.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    } else {
        shareText.font = [UIFont systemFontOfSize:14];
    }
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
