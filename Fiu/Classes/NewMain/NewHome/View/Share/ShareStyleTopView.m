//
//  ShareStyleTopView.m
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 1516年 taihuoniao. All rights reserved.
//

#import "ShareStyleTopView.h"
#import "HomeSceneListRow.h"
#import "UILable+Frame.h"

static CGFloat const desFont = 9.0f;
static CGFloat const userNameFont = 10.0f;

@interface ShareStyleTopView () {
    NSString    *   _titleText;
}

@end

@implementation ShareStyleTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)changeWithSearchText:(NSString *)title withDes:(NSString *)des {
    _titleText = title;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, 56));
    }];

    [self changeContentLabStyle:des];
}

#pragma mark - 视图信息
- (void)setShareSceneData:(HomeSceneListRow *)sceneModel {
    [self setViewUI];
    
    [self.sceneImg downloadImage:sceneModel.coverUrl place:[UIImage imageNamed:@""]];
    
    if (sceneModel.title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        
    } else if (sceneModel.title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", [sceneModel.title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString *suTitleStr = [NSString stringWithFormat:@"    %@  ", [sceneModel.title substringFromIndex:10]];
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
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr fontSize:17].width));
        }];
    }

    
    [self.userHeader downloadImage:sceneModel.user.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = sceneModel.user.nickname;
    [self.time setTitle:sceneModel.createdAt forState:(UIControlStateNormal)];
    NSString *timeStr = [NSString stringWithFormat:@"    %@", sceneModel.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getTextSizeWidth:timeStr fontSize:17].width));
    }];
    
    if (sceneModel.address.length == 0) {
        self.address.hidden = YES;
    } else {
        [self.address setTitle:sceneModel.address forState:(UIControlStateNormal)];
    }
    
    if (sceneModel.user.isExpert == 1) {
        self.userVimg.hidden = NO;
    } else {
        self.userVimg.hidden = YES;
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

#pragma mark - 视图UI
- (void)setViewUI {
    [self addSubview:self.fiuLogo];
    [_fiuLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 60));
    }];
    
    [self addSubview:self.sceneImg];
    [_sceneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(_fiuLogo.mas_bottom).with.offset(0);
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
    
    [self addSubview:self.userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 50));
        make.top.equalTo(_sceneImg.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.grayView];
    [_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self addSubview:self.describeView];
    [_describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.left.equalTo(_grayView).with.offset(10);
        make.right.equalTo(_grayView.mas_right).with.offset(-10);
    }];


    [self addSubview:self.slogan];
    [_slogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(63, 15));
        make.top.equalTo(_describe.mas_bottom).with.offset(5);
        make.left.equalTo(_describe.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.fiuSlogan];
    [_fiuSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 15));
        make.left.equalTo(_grayView.mas_left).with.offset(10);
        make.bottom.equalTo(_grayView.mas_bottom).with.offset(-5);
    }];
    
    [self addSubview:self.qrCode];
    [_qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(_grayView.mas_bottom).with.offset(-10);
        make.right.equalTo(_grayView.mas_right).with.offset(-10);
    }];
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_userView);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userVimg];
        [_userVimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(-9);
        }];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 14));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 12));
            make.left.equalTo(_userName.mas_left).with.offset(0);
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
        }];
        
        [_userView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.equalTo(_time.mas_right).with.offset(5);
            make.bottom.equalTo(_time.mas_bottom).with.offset(0);
            make.right.equalTo(_userView.mas_right).with.offset(-20);
        }];
        
    }
    return _userView;
}

#pragma mark - 内容
- (UIView *)describeView {
    if (!_describeView) {
        _describeView = [[UIView alloc] init];
        
        [_describeView addSubview:self.describe];
        [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_describeView.mas_top).with.offset(0);
            make.left.right.equalTo(_describeView).with.offset(0);
            make.height.mas_equalTo(@40);
        }];
    }
    return _describeView;
}

- (UIImageView *)sceneImg {
    if (!_sceneImg) {
        _sceneImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _sceneImg.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImg.clipsToBounds = YES;
    }
    return _sceneImg;
}

#pragma mark - 加V标志
- (UIImageView *)userVimg {
    if (!_userVimg) {
        _userVimg = [[UIImageView alloc] init];
        _userVimg.image = [UIImage imageNamed:@"talent"];
        _userVimg.contentMode = UIViewContentModeScaleToFill;
        _userVimg.hidden = YES;
    }
    return _userVimg;
}

- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 30/2;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.borderColor = [UIColor colorWithHexString:@"#555555"].CGColor;
        _userHeader.layer.borderWidth = 0.5f;
    }
    return _userHeader;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        _userName.font = [UIFont systemFontOfSize:userNameFont];
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
        _title.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
        _title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
        _suTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _suTitle.font = [UIFont systemFontOfSize:17];
    }
    return _suTitle;
}

- (UIImageView *)grayView {
    if (!_grayView) {
        _grayView = [[UIImageView alloc] init];
        _grayView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    }
    return _grayView;
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
        _describe.font = [UIFont systemFontOfSize:desFont];
        _describe.numberOfLines = 3;
    }
    return _describe;
}

- (void)changeContentLabStyle:(NSString *)str {
    if (str.length == 0) {
        self.slogan.hidden = YES;
    }
    
    CGFloat desHeigth = [self getTextSizeWidth:str fontSize:12].height;
    
    if (desHeigth <= 40) {
        [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(desHeigth));
        }];
        
    } else if (desHeigth > 40) {
        [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
        }];
        
        [_describeView addSubview:self.describeIcon];
        [_describeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 9));
            make.bottom.equalTo(_describe.mas_bottom).with.offset(-1);
            make.right.equalTo(_describe.mas_right).with.offset(0);
        }];
    }
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    self.describe.attributedText = contentText;
}

#pragma mark - Fiu
- (UIImageView *)qrCode {
    if (!_qrCode) {
        _qrCode = [[UIImageView alloc] init];
        _qrCode.image = [UIImage imageNamed:@"Share_QR_code"];
    }
    return _qrCode;
}

- (UIButton *)fiuLogo {
    if (!_fiuLogo) {
        _fiuLogo = [[UIButton alloc] init];
        [_fiuLogo setImage:[UIImage imageNamed:@"icon_logo_white"] forState:(UIControlStateNormal)];
        _fiuLogo.backgroundColor = [UIColor blackColor];
    }
    return _fiuLogo;
}

- (UIButton *)slogan {
    if (!_slogan) {
        _slogan = [[UIButton alloc] init];
        [_slogan setImage:[UIImage imageNamed:@"icon_slogan"] forState:(UIControlStateNormal)];
    }
    return _slogan;
}

- (UIButton *)fiuSlogan {
    if (!_fiuSlogan) {
        _fiuSlogan = [[UIButton alloc] init];
        [_fiuSlogan setImage:[UIImage imageNamed:@"icon_shareSlogn"] forState:(UIControlStateNormal)];
    }
    return _fiuSlogan;
}

@end
