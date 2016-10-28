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
#import "THNLoginRegisterViewController.h"
#import "UserInfoEntity.h"

@interface THNDiscoverSceneCollectionViewCell () {
    NSString *_sceneId;
    NSString *_userId;
    NSInteger _loveCount;
    BOOL _isLogin;
}

@end

@implementation THNDiscoverSceneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViewUI];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSceneListData:) name:@"refreshSceneData" object:nil];
    }
    return self;
}

#pragma mark - 刷新用户状态
- (void)refreshSceneListData:(NSNotification *)notification {
    if (_isLogin == YES) {
        _isLogin = NO;
    } else if (_isLogin == NO) {
        _isLogin = YES;
    }
}

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)sceneModel isLogin:(BOOL)login {
    self.sceneImageView.alpha = 0.0f;
    
    _isLogin = login;

    [self.sceneImageView sd_setImageWithURL:[NSURL URLWithString:sceneModel.coverUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.5 animations:^{
            self.sceneImageView.alpha = 1.0f;
        }];
    }];
    
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
            make.bottom.equalTo(_sceneImageView.mas_bottom).with.offset(-33);
        }];
        
    } else if (sceneModel.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"   %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
            make.bottom.equalTo(_sceneImageView.mas_bottom).with.offset(-5);
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
    [self addSubview:self.sceneImageView];
    [_sceneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.top.left.right.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImageView.mas_bottom).with.offset(-5);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImageView.mas_bottom).with.offset(-5);
    }];
    
    [self addSubview:self.userInfo];
    [_userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.bounds.size.width));
        make.left.bottom.equalTo(self).with.offset(0);
        make.top.equalTo(_sceneImageView.mas_bottom).with.offset(0);
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
- (UIImageView *)sceneImageView {
    if (!_sceneImageView) {
        _sceneImageView = [[UIImageView alloc] init];
        _sceneImageView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _sceneImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImageView.clipsToBounds = YES;
    }
    return _sceneImageView;
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
    if (_isLogin) {
        if (button.selected == NO) {
            button.selected = YES;
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            scaleAnimation.springBounciness = 10.f;
            scaleAnimation.springSpeed = 10.0f;
            [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            
            self.beginLikeTheSceneBlock(_sceneId);
            
        } else if (button.selected == YES) {
            button.selected = NO;
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            scaleAnimation.springBounciness = 10.f;
            scaleAnimation.springSpeed = 10.0f;
            [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            
            self.cancelLikeTheSceneBlock(_sceneId);
        }
        
    } else {
        THNLoginRegisterViewController * loginSignupVC = [[THNLoginRegisterViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
        [self.vc presentViewController:navi animated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSceneData" object:nil];
}


@end
