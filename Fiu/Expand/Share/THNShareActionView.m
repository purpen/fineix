//
//  THNShareActionView.m
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNShareActionView.h"
#import "THNMacro.h"
#import "THND3inExplainViewController.h"
#import "UIView+TYAlertView.h"
#import "THNGoodsQRCodeViewController.h"

static const NSInteger shareButtonTag = 810;

@implementation THNShareActionView

+ (THNShareActionView *)shareView {
    static dispatch_once_t once;
    static THNShareActionView *shareView;
    dispatch_once(&once, ^ { shareView = [[self alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];});
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

+ (void)showShare:(UIViewController *)controller shareMessageObject:(UMSocialMessageObject *)object linkUrl:(NSString *)linkUrl {
    NSArray *titleArr = @[@"微信", @"朋友圈", @"微博", @"QQ", @"二维码"];
    NSArray *iconImageArr = @[@"icon_share_wechatSession", @"icon_share_wechatTimeLine", @"icon_share_sina", @"icon_share_qq", @"icon_share_qr"];
    
    if (linkUrl.length > 0) {
        [self shareView].linkUrl = linkUrl;
    } else {
        [self shareView].linkUrl = @"";
    }
    [self shareView].shareMessageObject = object;
    [self shareView].vc = controller;
    [[self shareView] thn_creatShareButton:titleArr iconImage:iconImageArr];
}

- (void)setViewUI {
    [self addSubview:self.headerlable];
    [_headerlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.top.equalTo(self.mas_top).with.offset(5);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.mas_top).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];
    
    [self addSubview:self.goldImage];
    [_goldImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(_headerlable.mas_bottom).with.offset(25);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.textLable];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_goldImage.mas_bottom).with.offset(15);
    }];
    
    [self addSubview:self.lookButton];
    [_lookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.top.equalTo(_textLable.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchLocation = [touch locationInView:self.overlayView];
    
    if (CGRectContainsPoint(self.overlayView.frame, touchLocation)) {
        [self thn_removeFromSuperview];
    }
}

- (void)thn_creatShareButton:(NSArray *)title iconImage:(NSArray *)iconImage {
    if(!self.overlayView.superview) {
#if !defined(SV_APP_EXTENSIONS)
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
#endif
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if(!self.superview)
        [self.overlayView addSubview:self];
    
    CGRect rect = self.frame;
    rect = CGRectMake(0 , SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
    
    [self setNeedsDisplay];
    
    [self thn_creatButton:title iconImage:iconImage];
    
}

- (void)thn_creatButton:(NSArray *)title iconImage:(NSArray *)iconImage {
    if (self.subviews.count < 8) {
        for (NSInteger idx = 0; idx < title.count; ++ idx) {
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:iconImage[idx]] forState:(UIControlStateNormal)];
            button.tag = shareButtonTag + idx;
            [button addTarget:self action:@selector(shareButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 30) / title.count, (SCREEN_WIDTH - 30) / title.count));
                make.left.equalTo(self.mas_left).with.offset(15 + ((SCREEN_WIDTH - 30) / title.count) * idx);
                make.bottom.equalTo(self.mas_bottom).with.offset(-40);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = title[idx];
            label.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@12);
                make.left.right.equalTo(button).with.offset(0);
                make.top.equalTo(button.mas_bottom).with.offset(0);
            }];
        }
    }
}

- (void)shareButton:(UIButton *)button {
    switch (button.tag - shareButtonTag) {
        case 0:
            [self shareToPlatform:UMSocialPlatformType_WechatSession];
            break;
        case 1:
            [self shareToPlatform:UMSocialPlatformType_WechatTimeLine];
            break;
        case 2:
            [self shareToPlatform:UMSocialPlatformType_Sina];
            break;
        case 3:
            [self shareToPlatform:UMSocialPlatformType_QQ];
            break;
        case 4:
            [self open_shareQRCodeInfo];
            break;
    }
}

- (void)shareToPlatform:(UMSocialPlatformType)type {
    [[UMSocialManager defaultManager] shareToPlatform:(type)
                                        messageObject:self.shareMessageObject
                                currentViewController:self
                                           completion:^(id result, NSError *error) {
                                               if (error) {
                                                   [SVProgressHUD showErrorWithStatus:@"取消分享"];
                                               } else{
                                                   [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                   [self thn_removeFromSuperview];
                                               }
                                           }];
}

- (void)open_shareQRCodeInfo {
    if (_linkUrl.length > 0) {
        [self thn_removeFromSuperview];
        THNGoodsQRCodeViewController *qrCodeVC = [[THNGoodsQRCodeViewController alloc] init];
        qrCodeVC.linkUrl = _linkUrl;
        qrCodeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.vc presentViewController:qrCodeVC animated:YES completion:nil];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无分享链接"];
    }
}

- (UILabel *)headerlable {
    if (!_headerlable) {
        _headerlable = [[UILabel alloc] init];
        _headerlable.font = [UIFont systemFontOfSize:16];
        _headerlable.textColor = [UIColor colorWithHexString:@"#222222"];
        _headerlable.text = @"分享得佣金";
        _headerlable.textAlignment = NSTextAlignmentCenter;
    }
    return _headerlable;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_share_close"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (void)closeButtonClick:(UIButton *)button {
    [self thn_removeFromSuperview];
}

- (UIImageView *)goldImage {
    if (!_goldImage) {
        _goldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_share_gold"]];
    }
    return _goldImage;
}

- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] init];
        _textLable.text = @"现在分享，可获得成交订单的5%佣金";
        _textLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _textLable.font = [UIFont systemFontOfSize:14];
        _textLable.textAlignment = NSTextAlignmentCenter;
    }
    return _textLable;
}

- (UIButton *)lookButton {
    if (!_lookButton) {
        _lookButton = [[UIButton alloc] init];
        [_lookButton setTitle:@"D3IN合伙人招募计划" forState:(UIControlStateNormal)];
        [_lookButton setAttributedTitle:[self getAttributedStringWithString:@"查看 D3IN合伙人招募计划"] forState:(UIControlStateNormal)];
        _lookButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_lookButton addTarget:self action:@selector(lookButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookButton;
}

- (void)lookButtonClick:(UIButton *)button {
    [self thn_removeFromSuperview];
    THND3inExplainViewController *explainVC = [[THND3inExplainViewController alloc] init];
    [self.vc presentViewController:explainVC animated:YES completion:nil];
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:MAIN_COLOR] range:NSMakeRange(3, string.length - 3)];
    return attributedString;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHexString:@"#E5E5E5"] CGColor]);
    CGContextMoveToPoint(context, 0, 50);
    CGContextAddLineToPoint(context, self.bounds.size.width, 50);
    CGContextStrokePath(context);
}

- (void)thn_removeFromSuperview {
    CGRect rect = self.frame;
    rect = CGRectMake(0 , SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
        self.overlayView.hidden = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.overlayView removeFromSuperview];
    }];
}

@end
