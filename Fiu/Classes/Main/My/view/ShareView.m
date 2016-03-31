//
//  ShareView.m
//  fineix
//
//  Created by THN-Dong on 16/3/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

//
//  ShareView.m
//  parrot
//
//  Created by FLYang on 16/1/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareView.h"
#import "UIColor+Extension.h"
#import "Fiu.h"

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgView];
        
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, SCREEN_HEIGHT+200)];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
        
        [_bgView addSubview:self.cancel];
        [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 44));
            make.centerX.equalTo(_bgView);
            make.bottom.equalTo(_bgView.mas_bottom).with.offset(-20);
        }];
        
        [_bgView addSubview:self.shareView];
        [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 115));
            make.centerX.equalTo(_bgView);
            make.bottom.equalTo(_cancel.mas_top).with.offset(-20);
        }];
        
    }
    return _bgView;
}

- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
        _shareView.layer.masksToBounds = YES;
        _shareView.layer.cornerRadius = 4;
        _shareView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1" alpha:.9];
        
        //  分享第三方平台的按钮
        
        [_shareView addSubview:self.wechat];
        [_wechat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 90));
            make.left.equalTo(_shareView.mas_left).with.offset(0);
            make.top.equalTo(_shareView.mas_top).with.offset(0);
        }];
        
        [_shareView addSubview:self.wechatTimeline];
        [_wechatTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 90));
            make.left.equalTo(_shareView.mas_left).with.offset((SCREEN_WIDTH-20)/4);
            make.top.equalTo(_shareView.mas_top).with.offset(0);
        }];
        
        [_shareView addSubview:self.sina];
        [_sina mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 90));
            make.left.equalTo(_shareView.mas_left).with.offset((SCREEN_WIDTH-20)/2);
            make.top.equalTo(_shareView.mas_top).with.offset(0);
        }];
        
        [_shareView addSubview:self.qq];
        [_qq mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 90));
            make.right.equalTo(_shareView.mas_right).with.offset(0);
            make.top.equalTo(_shareView.mas_top).with.offset(0);
        }];
        
        
        //  分享第三方平台的名称
        
        [_shareView addSubview:self.wechatLab];
        [_wechatLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 15));
            make.bottom.equalTo(_shareView.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_wechat);
        }];
        
        [_shareView addSubview:self.wechatTimelineLab];
        [_wechatTimelineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 15));
            make.bottom.equalTo(_shareView.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_wechatTimeline);
        }];
        
        [_shareView addSubview:self.sinaLab];
        [_sinaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 15));
            make.bottom.equalTo(_shareView.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_sina);
        }];
        
        [_shareView addSubview:self.qqLab];
        [_qqLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/4, 15));
            make.bottom.equalTo(_shareView.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_qq);
        }];
        
        /**
         *  判断用户有没有安装第三方应用
         *  设置分享面板
         */
        
        if ([WXApi isWXAppInstalled]) {
            self.wechat.hidden = NO;
            self.wechatLab.hidden = NO;
            
            self.wechatTimeline.hidden = NO;
            self.wechatTimelineLab.hidden = NO;
        } else {
            self.wechat.hidden = YES;
            self.wechatLab.hidden = YES;
            
            self.wechatTimeline.hidden = YES;
            self.wechatTimelineLab.hidden = YES;
        }
        
        if ([QQApiInterface isQQInstalled]) {
            self.qq.hidden = NO;
            self.qqLab.hidden = NO;
        } else {
            self.qq.hidden = YES;
            self.qqLab.hidden = YES;
        }
        
        if ([WeiboSDK isWeiboAppInstalled]) {
            self.sina.hidden = NO;
            self.sinaLab.hidden = NO;
        } else {
            self.sina.hidden = YES;
            self.sinaLab.hidden = YES;
        }
        
        
    }
    return _shareView;
}

- (UIButton *)wechat {
    if (!_wechat) {
        _wechat = [[UIButton alloc] init];
        [_wechat setImage:[UIImage imageNamed:@"weixin"] forState:(UIControlStateNormal)];
    }
    return _wechat;
}

- (UILabel *)wechatLab {
    if (!_wechatLab) {
        _wechatLab = [[UILabel alloc] init];
        _wechatLab.text = @"微信";
        _wechatLab.font = [UIFont systemFontOfSize:14];
        _wechatLab.textAlignment = NSTextAlignmentCenter;
        _wechatLab.textColor = [UIColor blackColor];
    }
    return _wechatLab;
}

- (UIButton *)wechatTimeline {
    if (!_wechatTimeline) {
        _wechatTimeline = [[UIButton alloc] init];
        [_wechatTimeline setImage:[UIImage imageNamed:@"pengyou"] forState:(UIControlStateNormal)];
    }
    return _wechatTimeline;
}

- (UILabel *)wechatTimelineLab {
    if (!_wechatTimelineLab) {
        _wechatTimelineLab = [[UILabel alloc] init];
        _wechatTimelineLab.text = @"朋友圈";
        _wechatTimelineLab.font = [UIFont systemFontOfSize:14];
        _wechatTimelineLab.textAlignment = NSTextAlignmentCenter;
        _wechatTimelineLab.textColor = [UIColor blackColor];
    }
    return _wechatTimelineLab;
}

- (UIButton *)sina {
    if (!_sina) {
        _sina = [[UIButton alloc] init];
        [_sina setImage:[UIImage imageNamed:@"weibo"] forState:(UIControlStateNormal)];
        
    }
    return _sina;
}

- (UILabel *)sinaLab {
    if (!_sinaLab) {
        _sinaLab = [[UILabel alloc] init];
        _sinaLab.text = @"微博";
        _sinaLab.font = [UIFont systemFontOfSize:14];
        _sinaLab.textAlignment = NSTextAlignmentCenter;
        _sinaLab.textColor = [UIColor blackColor];
    }
    return _sinaLab;
}

- (UIButton *)qq {
    if (!_qq) {
        _qq = [[UIButton alloc] init];
        [_qq setImage:[UIImage imageNamed:@"qq"] forState:(UIControlStateNormal)];
        
    }
    return _qq;
}

- (UILabel *)qqLab {
    if (!_qqLab) {
        _qqLab = [[UILabel alloc] init];
        _qqLab.text = @"QQ";
        _qqLab.font = [UIFont systemFontOfSize:14];
        _qqLab.textAlignment = NSTextAlignmentCenter;
        _qqLab.textColor = [UIColor blackColor];
    }
    return _qqLab;
}

- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [[UIButton alloc] init];
        [_cancel setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancel.layer.cornerRadius = 4;
        _cancel.backgroundColor = [UIColor whiteColor];
    }
    return _cancel;
}

@end

