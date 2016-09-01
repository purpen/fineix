//
//  THNUserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNUserInfoTableViewCell.h"
#import "THNHotUserCollectionViewCell.h"
#import "HotUserListUser.h"
#import "HomePageViewController.h"

static NSString *const hotUserCellId = @"HotUserCellId";

@interface THNUserInfoTableViewCell () {
    NSString *_userId;
}

@end

@implementation THNUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        self.clipsToBounds = YES;
        [self setCellUI];
    }
    return self;
}

-(void)setModel:(HomeSceneListRow *)userModel{
    _userModel = userModel;
    [self.head sd_setImageWithURL:[NSURL URLWithString:userModel.user.avatarUrl]
                         forState:(UIControlStateNormal)
                 placeholderImage:[UIImage imageNamed:@""]];
    self.name.text = userModel.user.nickname;
    [self.time setTitle:userModel.createdAt forState:(UIControlStateNormal)];
    NSString *timeStr = [NSString stringWithFormat:@"      %@",userModel.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getTextSizeWidth:timeStr].width));
    }];
    [self.address setTitle:userModel.address forState:(UIControlStateNormal)];
    if (userModel.user.isExpert == 1) {
        self.certificate.hidden = NO;
    } else {
        self.certificate.hidden = YES;
    }
    
    if (userModel.user.isFollow == 0) {
        self.follow.selected = NO;
    } else if (userModel.user.isFollow == 1) {
        self.follow.selected = YES;
    }
    
    _userId = userModel.user._id;
}

#pragma mark - setModel 
- (void)thn_setHomeSceneUserInfoData:(HomeSceneListRow *)userModel userId:(NSString *)userID {
    [self.head sd_setImageWithURL:[NSURL URLWithString:userModel.user.avatarUrl]
                         forState:(UIControlStateNormal)
                 placeholderImage:[UIImage imageNamed:@""]];
    self.name.text = userModel.user.nickname;
    [self.time setTitle:userModel.createdAt forState:(UIControlStateNormal)];
    NSString *timeStr = [NSString stringWithFormat:@"      %@",userModel.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getTextSizeWidth:timeStr].width));
    }];
    [self.address setTitle:[NSString stringWithFormat:@"%@ %@", userModel.city, userModel.address] forState:(UIControlStateNormal)];
    
    if (userModel.address.length == 0) {
        self.address.hidden = YES;
    } else {
        self.address.hidden = NO;
    }
    
    if (userModel.user.isExpert == 1) {
        self.certificate.hidden = NO;
    } else {
        self.certificate.hidden = YES;
    }
    
    if (userModel.user.isFollow == 0) {
        self.follow.selected = NO;
    } else if (userModel.user.isFollow == 1) {
        self.follow.selected = YES;
    }
    
    _userId = [NSString stringWithFormat:@"%zi", userModel.userId];
    if ([_userId isEqualToString:@"0"]) {
        _userId = userModel.user._id;
    }
    
    if ([_userId isEqualToString:userID]) {
        self.follow.hidden = YES;
    } else {
        self.follow.hidden = NO;
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

- (void)thn_setHotUserListData:(NSMutableArray *)hotUserMarr {
    [self.hotUserIdMarr removeAllObjects];
    self.hotUserMarr = hotUserMarr;
    for (HotUserListUser *model in hotUserMarr) {
        [self.hotUserIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    }
    [self.hotUserList reloadData];
}

- (void)thn_isShowHotUserList:(BOOL)show {
    if (show) {
        [self addSubview:self.hotUserList];
        [_hotUserList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 230));
            make.left.equalTo(self.mas_left).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(0);
        }];
    }
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

#pragma mark - init
- (UICollectionView *)hotUserList {
    if (!_hotUserList) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(140, 190);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _hotUserList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230) collectionViewLayout:flowLayout];
        _hotUserList.delegate = self;
        _hotUserList.dataSource = self;
        _hotUserList.backgroundColor = [UIColor colorWithHexString:@"#444444"];
        _hotUserList.showsHorizontalScrollIndicator = NO;
        [_hotUserList registerClass:[THNHotUserCollectionViewCell class] forCellWithReuseIdentifier:hotUserCellId];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheUserInfo:) name:@"closeTheUserInfo" object:nil];
    }
    return _hotUserList;
}

- (void)closeTheUserInfo:(NSNotification *)userId {
    NSUInteger index = [self.hotUserIdMarr indexOfObject:[userId object]];
    [self.hotUserMarr removeObjectAtIndex:index];
    [self.hotUserIdMarr removeObjectAtIndex:index];
    if (self.hotUserMarr.count) {
        [self.hotUserList reloadData];
    }
    
    if (self.hotUserMarr.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteHotUserList" object:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotUserMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNHotUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotUserCellId
                                                                                   forIndexPath:indexPath];
    if (self.hotUserMarr.count) {
        [cell setHotUserListData:self.hotUserMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = self.hotUserIdMarr[indexPath.row];
    userHomeVC.type = @2;
    [self.nav pushViewController:userHomeVC animated:YES];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        
        [_bottomView addSubview:self.head];
        [_head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(_bottomView.mas_left).with.offset(15);
            make.centerY.equalTo(_bottomView);
        }];
        
        [_bottomView addSubview:self.certificate];
        [_certificate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.right.equalTo(_head.mas_right).with.offset(2);
            make.bottom.equalTo(_head.mas_bottom).with.offset(0);
        }];
        
        [_bottomView addSubview:self.name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 15));
            make.top.equalTo(_head.mas_top).with.offset(0);
            make.left.equalTo(_head.mas_right).with.offset(10);
        }];
        
        [_bottomView addSubview:self.follow];
        [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(66, 26));
            make.right.equalTo(_bottomView.mas_right).with.offset(-15);
            make.centerY.equalTo(_bottomView);
        }];
        
        [_bottomView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 12));
            make.left.equalTo(_name.mas_left).with.offset(0);
            make.bottom.equalTo(_head.mas_bottom).with.offset(0);
        }];
        
        [_bottomView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.equalTo(_time.mas_right).with.offset(5);
            make.bottom.equalTo(_time.mas_bottom).with.offset(0);
            make.right.equalTo(_bottomView.mas_right).with.offset(-90);
        }];
    }
    return _bottomView;
}

- (UIButton *)head {
    if (!_head) {
        _head = [[UIButton alloc] init];
        _head.layer.cornerRadius = 30/2;
        _head.layer.masksToBounds = YES;
        [_head addTarget:self action:@selector(headClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _head;
}

- (void)headClick:(UIButton *)button {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = _userId;
    userHomeVC.type = @2;
    [self.nav pushViewController:userHomeVC animated:YES];
}

- (UIImageView *)certificate {
    if (!_certificate) {
        _certificate = [[UIImageView alloc] init];
        _certificate.image = [UIImage imageNamed:@"user_jiaV"];
    }
    return _certificate;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _name.font = [UIFont systemFontOfSize:12];
    }
    return _name;
}

- (UIButton *)follow {
    if (!_follow) {
        _follow = [[UIButton alloc] init];
        _follow.layer.cornerRadius = 5.0f;
        _follow.layer.borderColor = [UIColor colorWithHexString:WHITE_COLOR alpha:0.6f].CGColor;
        _follow.layer.borderWidth = 0.5f;
        _follow.backgroundColor = [UIColor blackColor];
        [_follow setTitle:NSLocalizedString(@"User_follow", nil) forState:(UIControlStateNormal)];
        [_follow setTitle:NSLocalizedString(@"User_followDone", nil) forState:(UIControlStateSelected)];
        _follow.titleLabel.font = [UIFont systemFontOfSize:12];
        [_follow addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_follow setImage:[UIImage imageNamed:@"icon_success"] forState:(UIControlStateSelected)];
        [_follow setImageEdgeInsets:(UIEdgeInsetsMake(0, -6, 0, 0))];
    }
    return _follow;
}

- (void)followClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        button.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        button.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followTheUser" object:_userId];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        button.layer.borderColor = [UIColor colorWithHexString:WHITE_COLOR alpha:0.6].CGColor;
        button.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelFollowTheUser" object:_userId];
    }
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
        [_address addTarget:self action:@selector(addressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _address;
}

- (void)addressClick:(UIButton *)button {
//    [SVProgressHUD showSuccessWithStatus:@"打开情景地图"];
}

- (NSMutableArray *)hotUserMarr {
    if (!_hotUserMarr) {
        _hotUserMarr = [NSMutableArray array];
    }
    return _hotUserMarr;
}

- (NSMutableArray *)hotUserIdMarr {
    if (!_hotUserIdMarr) {
        _hotUserIdMarr = [NSMutableArray array];
    }
    return _hotUserIdMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelFollowTheUser" object:nil];
}
@end
