//
//  THNRedEnvelopeView.m
//  Fiu
//
//  Created by FLYang on 16/9/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRedEnvelopeView.h"

@implementation THNRedEnvelopeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        [self thn_setViewUI];
    }
    return self;
}


- (void)thn_showRedEnvelopeViewOnWindowWithText:(NSString *)text {
    self.content.text = text;
    
    if (self.superview == nil) {
        [[[UIApplication sharedApplication].windows firstObject] addSubview:self];
    }
    self.alertView.transform = CGAffineTransformScale(self.alertView.transform,0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

- (void)thn_remove {
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            [self.redEnvelopeImage removeFromSuperview];
            self.alertView.transform = CGAffineTransformScale(self.alertView.transform,0.1,0.1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 设置视图
- (void)thn_setViewUI {
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@225);
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.centerX.centerY.equalTo(self);
    }];
    
    [self addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.right.equalTo(_alertView).with.offset(0);
    }];
    
    [self addSubview:self.redEnvelopeImage];
    [_redEnvelopeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 125));
        make.top.equalTo(_alertView.mas_top).with.offset(20);
        make.centerX.equalTo(_alertView);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alertView.mas_left).with.offset(30);
        make.right.equalTo(_alertView.mas_right).with.offset(-30);
        make.top.equalTo(_redEnvelopeImage.mas_bottom).with.offset(0);
        make.bottom.equalTo(_alertView.mas_bottom).with.offset(-20);
    }];
}

#pragma mark -  提示面板
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10.0f;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}

#pragma mark - 关闭
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_cancel_black"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(thn_remove) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

#pragma mark - 红包图片
- (UIImageView *)redEnvelopeImage {
    if (!_redEnvelopeImage) {
        _redEnvelopeImage = [[UIImageView alloc] init];
        _redEnvelopeImage.contentMode = UIViewContentModeCenter;
        _redEnvelopeImage.image = [UIImage imageNamed:@"image_RedEnvelope"];
    }
    return _redEnvelopeImage;
}

#pragma mark - 文案
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize:12];
        _content.textColor = [UIColor colorWithHexString:@"#666666"];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.numberOfLines = 0;
    }
    return _content;
}

#pragma mark - 去查看
- (UIButton *)goLook {
    if (!_goLook) {
        _goLook = [[UIButton alloc] init];
    }
    return _goLook;
}

@end
