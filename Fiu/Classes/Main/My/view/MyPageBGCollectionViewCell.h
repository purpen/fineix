//
//  MyPageBGCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageBGCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *bgImageView;//背景图片
@property(nonatomic,strong) UIImageView *userHeadImageView;//用户的头像
@property(nonatomic,strong) UILabel *nickName;//用户昵称
@property(nonatomic,strong) UILabel *userProfile;//用户简介
@property(nonatomic,strong) UIView *userLevelView;//用户等级视图
@property(nonatomic,strong) UILabel *userLevelLabel;//用户等级文字
@property(nonatomic,strong) UILabel *userLevelBottomLabel;//用户等级下面的
@property(nonatomic,strong) UIButton *certificationBtn;//认证按钮
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIImageView *idImageView;

- (void)setUI;

@end
