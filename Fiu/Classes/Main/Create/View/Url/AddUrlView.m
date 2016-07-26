//
//  AddUrlView.m
//  fineix
//
//  Created by FLYang on 16/3/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddUrlView.h"

static const NSInteger webBtnTag = 200;

@implementation AddUrlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
        
        self.webTitle = [NSMutableArray arrayWithObjects:
                         NSLocalizedString(@"JD", nil),
                         NSLocalizedString(@"TaoBao", nil),
                         NSLocalizedString(@"Tmall", nil),
                         nil];
        
        [self addSubview:self.webBtnView];
        [_webBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.centerX.equalTo(self);
        }];

    }
    return self;
}

#pragma mark - 购物网站按钮所在的视图
- (UIView *)webBtnView {
    if (!_webBtnView) {
        _webBtnView = [[UIView alloc] init];
        
        [self initWebButton:self.webTitle];
    }
    
    return _webBtnView;
}

//  创建购物网站按钮
- (void)initWebButton:(NSMutableArray *)btnTitle {
    for (NSUInteger idx = 0; idx < btnTitle.count; ++ idx) {
        UIButton * webBtn = [[UIButton alloc] initWithFrame:CGRectMake(((((SCREEN_WIDTH - 180)/4)*idx) + (60*idx)) + ((SCREEN_WIDTH-180)/4), 0, 60, 60)];
        webBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        webBtn.layer.cornerRadius = 8;
        webBtn.layer.masksToBounds = YES;
        [webBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"web_%zi", idx]] forState:(UIControlStateNormal)];
        webBtn.tag = webBtnTag + idx;
        [webBtn addTarget:self action:@selector(webBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_webBtnView addSubview:webBtn];
        
        UILabel * webLab = [[UILabel alloc] initWithFrame:CGRectMake(((((SCREEN_WIDTH - 180)/4)*idx) + (60*idx)) + ((SCREEN_WIDTH-180)/4), 75, 60, 15)];
        webLab.text = btnTitle[idx];
        webLab.textColor = [UIColor blackColor];
        webLab.textAlignment = NSTextAlignmentCenter;
        webLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [_webBtnView addSubview:webLab];
    }
}

- (void)webBtnClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(webBtnSelectedSearchGoods:)]) {
        [self.delegate webBtnSelectedSearchGoods:(button.tag - webBtnTag)];
    }
}

@end
