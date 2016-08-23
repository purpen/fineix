//
//  THNDiscoverSceneCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverSceneCollectionViewCell.h"
#import "THNSenceModel.h"
#import "UserInfo.h"

@interface THNDiscoverSceneCollectionViewCell () {
    NSString *_sceneId;
    NSString *_userId;
    NSInteger _loveCount;
}

@end

@implementation THNDiscoverSceneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViewUI];
    }
    return self;
}

-(void)setModel:(THNSenceModel *)model{
    _model = model;
    [self.image downloadImage:model.cover_url place:[UIImage imageNamed:@"Defaul_Bg_420"]];
    [self.userHeader downloadImage:model.user_info.avatar_url place:[UIImage imageNamed:@"default_head"]];
    self.userName.text = model.user_info.nickname;
    if ([model.is_love integerValue] == 1) {
        self.likeBtn.selected = YES;
    } else {
        self.likeBtn.selected = NO;
    }
    
    if (model.title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        
    } else if (model.title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", [model.title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString *suTitleStr = [NSString stringWithFormat:@"    %@  ", [model.title substringFromIndex:10]];
        self.suTitle.text = suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:suTitleStr].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
            make.bottom.equalTo(self.mas_bottom).with.offset(-70);
        }];
        
    } else if (model.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", model.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
        }];
    }

}

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)sceneModel {
    [self.image downloadImage:sceneModel.coverUrl place:[UIImage imageNamed:@""]];
    [self.userHeader downloadImage:sceneModel.user.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = sceneModel.user.nickname;
    if (sceneModel.isLove == 1) {
        self.likeBtn.selected = YES;
    } else {
        self.likeBtn.selected = NO;
    }
    _loveCount = sceneModel.loveCount;
    _sceneId = [NSString stringWithFormat:@"%zi", sceneModel.idField];
    _userId = [NSString stringWithFormat:@"%zi", sceneModel.userId];

    if (sceneModel.title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        
    } else if (sceneModel.title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"   %@  ", [sceneModel.title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString *suTitleStr = [NSString stringWithFormat:@"   %@  ", [sceneModel.title substringFromIndex:10]];
        self.suTitle.text = suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:suTitleStr].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
            make.bottom.equalTo(_image.mas_bottom).with.offset(-33);
        }];
        
    } else if (sceneModel.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"   %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
            make.bottom.equalTo(_image.mas_bottom).with.offset(-5);
        }];
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - setUI 
- (void)setViewUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.top.left.right.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_image.mas_bottom).with.offset(-5);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_image.mas_bottom).with.offset(-5);
    }];
    
    [self addSubview:self.userInfo];
    [_userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.bounds.size.width));
        make.left.bottom.equalTo(self).with.offset(0);
        make.top.equalTo(_image.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(_userInfo);
    }];
    
    [self addSubview:self.likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 35));
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.centerY.equalTo(_userInfo);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userHeader.mas_right).with.offset(5);
        make.right.equalTo(_likeBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(_userInfo);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    return _image;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:0.8];
        _title.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _title.font = [UIFont systemFontOfSize:12];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:0.8];
        _suTitle.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _suTitle.font = [UIFont systemFontOfSize:12];
    }
    return _suTitle;
}

- (UIView *)userInfo {
    if (!_userInfo) {
        _userInfo = [[UIView alloc] init];
        _userInfo.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
    }
    return _userInfo;
}

- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 21/2;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _userHeader;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _userName.font = [UIFont systemFontOfSize:10];
    }
    return _userName;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_zan_white"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_yizan"] forState:(UIControlStateSelected)];
        [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _likeBtn;
}

- (void)likeClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"findLikeTheScene" object:_sceneId];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"findCancelLikeTheScene" object:_sceneId];
    }
}

@end
