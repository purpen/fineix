//
//  ShareStyleTopView.m
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 1516年 taihuoniao. All rights reserved.
//

#import "ShareStyleTopView.h"
#import "UILable+Frame.h"

@implementation ShareStyleTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - 视图信息
- (void)setShareSceneData:(HomeSceneListRow *)sceneModel {
    [self setViewUI];
    
    self.tagDataMarr = [NSMutableArray arrayWithArray:sceneModel.product];
    if (self.tagDataMarr.count) {
        [self setUserTagBtn];
    }
    
    [self.sceneImg downloadImage:sceneModel.coverUrl place:[UIImage imageNamed:@""]];
    if (sceneModel.title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        
    } else if (sceneModel.title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"     %@  ", [sceneModel.title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString *suTitleStr = [NSString stringWithFormat:@"     %@  ", [sceneModel.title substringFromIndex:10]];
        self.suTitle.text = suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:suTitleStr fontSize:17].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr fontSize:17].width));
            make.bottom.equalTo(_sceneImg.mas_bottom).with.offset(-48);
        }];
        
    } else if (sceneModel.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"     %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr fontSize:17].width));
        }];
    }

    [self.userName setTitle:[NSString stringWithFormat:@"%@", sceneModel.user.nickname] forState:(UIControlStateNormal)];
    [self.time setTitle:[NSString stringWithFormat:@"%@", sceneModel.createdAt] forState:(UIControlStateNormal)];
    NSString *timeStr = [NSString stringWithFormat:@"     %@", sceneModel.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getTextSizeWidth:timeStr fontSize:12].width));
    }];
    
    if (sceneModel.address.length == 0) {
        self.address.hidden = YES;
    } else {
        [self.address setTitle:[NSString stringWithFormat:@"%@", sceneModel.address] forState:(UIControlStateNormal)];
    }
    
    [self changeContentLabStyle:sceneModel.des];
}

- (CGSize)getTextSizeWidth:(NSString *)text fontSize:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - 创建用户添加商品按钮
- (void)setUserTagBtn {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString *title = [self.tagDataMarr[idx] valueForKey:@"title"];
        NSInteger loc = [[self.tagDataMarr[idx] valueForKey:@"loc"] integerValue];
        
        UserGoodsTag * userTag = [[UserGoodsTag alloc] init];
        userTag.userInteractionEnabled = NO;
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        userTag.isMove = NO;
        CGFloat width = [userTag.title boundingRectWithSize:CGSizeMake(320, 0)].width;
        if (width*1.3 > SCREEN_WIDTH/2) {
            width = SCREEN_WIDTH/2;
        } else {
            width = [userTag.title boundingRectWithSize:CGSizeMake(320, 0)].width * 1.3;
        }
        
        if (loc == 1) {
            userTag.frame = CGRectMake((btnX*SCREEN_WIDTH) - ((width+25)-18), btnY*SCREEN_WIDTH-32+(SCREEN_WIDTH *0.133), width+25, 32);
        } else if (loc == 2) {
            userTag.frame = CGRectMake(btnX*SCREEN_WIDTH-44, btnY*SCREEN_WIDTH-32+(SCREEN_WIDTH *0.133), width+25, 32);
        }
        [userTag thn_setSceneImageUserGoodsTagLoc:loc];
        [self addSubview:userTag];
        [userTag sendSubviewToBack:self.title];
    }
}

#pragma mark - 视图UI
- (void)setViewUI {
    [self addSubview:self.styleImage];
    [_styleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self addSubview:self.sceneImg];
    [_sceneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(SCREEN_WIDTH *0.14);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
    }];

    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(_sceneImg.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImg.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(_sceneImg.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImg.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.contentline];
    [_contentline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 44, 0.5));
        make.left.equalTo(self.mas_left).with.offset(22);
        make.top.equalTo(_sceneImg.mas_bottom).with.offset(SCREEN_WIDTH *0.125);
    }];

    [self addSubview:self.userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 44, 30));
        make.top.equalTo(_contentline.mas_bottom).with.offset(SCREEN_WIDTH *0.12);
        make.left.equalTo(self.mas_left).with.offset(22);
    }];
    
    [self addSubview:self.sendText];
    [_sendText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.left.equalTo(self.mas_left).with.offset(SCREEN_WIDTH *0.21);
        make.bottom.equalTo(self.mas_bottom).with.offset(-SCREEN_WIDTH *0.072);
    }];
    
    [self addSubview:self.describe];
    [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH - 44));
        make.bottom.equalTo(_contentline.mas_top).with.offset(0);
        make.top.equalTo(_sceneImg.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(22);
    }];
}

#pragma mark - 样式背景
- (UIImageView *)styleImage {
    if (!_styleImage) {
        _styleImage = [[UIImageView alloc] init];
        if (IS_PHONE5) {
            _styleImage.image = [UIImage imageNamed:@"5_share_style_0"];
        } else {
            _styleImage.image = [UIImage imageNamed:@"share_style_0"];
        }
        _styleImage.contentMode = UIViewContentModeCenter;
    }
    return _styleImage;
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 14));
            make.top.equalTo(_userView.mas_top).with.offset(0);
            make.left.equalTo(_userView.mas_left).with.offset(1);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 12));
            make.left.equalTo(_userView.mas_left).with.offset(0);
            make.top.equalTo(_userName.mas_bottom).with.offset(5);
        }];
        
        [_userView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.equalTo(_time.mas_right).with.offset(5);
            make.bottom.equalTo(_time.mas_bottom).with.offset(0);
            make.right.equalTo(_userView.mas_right).with.offset(0);
        }];
    }
    return _userView;
}

#pragma mark - 内容
- (UIImageView *)sceneImg {
    if (!_sceneImg) {
        _sceneImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _sceneImg.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImg.clipsToBounds = YES;
    }
    return _sceneImg;
}

- (UIButton *)userName {
    if (!_userName) {
        _userName = [[UIButton alloc] init];
        [_userName setImage:[UIImage imageNamed:@"icon_user_gray"] forState:(UIControlStateNormal)];
        [_userName setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _userName.titleLabel.font = [UIFont systemFontOfSize:10];
        [_userName setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        _userName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _userName;
}

- (UIButton *)time {
    if (!_time) {
        _time = [[UIButton alloc] init];
        [_time setImage:[UIImage imageNamed:@"icon_time"] forState:(UIControlStateNormal)];
        [_time setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _time.titleLabel.font = [UIFont systemFontOfSize:10];
        [_time setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _time;
}

- (UIButton *)address {
    if (!_address) {
        _address = [[UIButton alloc] init];
        [_address setImage:[UIImage imageNamed:@"icon_location"] forState:(UIControlStateNormal)];
        [_address setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _address.titleLabel.font = [UIFont systemFontOfSize:10];
        [_address setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        _address.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _address;
}
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        _title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        _suTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _suTitle.font = [UIFont systemFontOfSize:17];
    }
    return _suTitle;
}

- (UILabel *)contentline {
    if (!_contentline) {
        _contentline = [[UILabel alloc] init];
        _contentline.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1" alpha:0];
    }
    return _contentline;
}

- (UIButton *)describeIcon {
    if (!_describeIcon) {
        _describeIcon = [[UIButton alloc] init];
        [_describeIcon setImage:[UIImage imageNamed:@"share_other"] forState:(UIControlStateNormal)];
    }
    return _describeIcon;
}

- (UILabel *)describe {
    if (!_describe) {
        _describe = [[UILabel alloc] init];
        _describe.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _describe.font = [UIFont systemFontOfSize:10];
        _describe.numberOfLines = 2;
    }
    return _describe;
}

- (void)changeContentLabStyle:(NSString *)str {
    CGFloat desHeigth = [self getTextSizeWidth:str fontSize:12].height;
    if (desHeigth >= 20 && str.length >= 55) {
        [self addSubview:self.describeIcon];
        [_describeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 9));
            make.right.equalTo(_describe.mas_right).with.offset(0);
            make.top.equalTo(_describe.mas_centerY).with.offset(3);
        }];
    }
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName:paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    self.describe.attributedText = contentText;
}

#pragma mark - 注册送红包
- (UILabel *)sendText {
    if (!_sendText) {
        _sendText = [[UILabel alloc] init];
        _sendText.textColor = [UIColor colorWithHexString:fineixColor];
        _sendText.font = [UIFont systemFontOfSize:9];
        _sendText.text = NSLocalizedString(@"newSendRed", nil);
    }
    return _sendText;
}

@end
