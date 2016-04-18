//
//  BackgroundTableViewCell.h
//  Fiu
//
//  Created by dys on 16/4/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface BackgroundTableViewCell : UITableViewCell


@property(nonatomic,strong) UIImageView *bgImageView;//背景图片
@property(nonatomic,strong) UIImageView *userHeadImageView;//用户的头像
@property(nonatomic,strong) UILabel *nickName;//用户昵称
@property(nonatomic,strong) UILabel *userProfile;//用户简介
@property(nonatomic,strong) UIView *userLevelView;//用户等级视图
@property(nonatomic,strong) UILabel *userLevelLabel;//用户等级文字
@property(nonatomic,strong) UILabel *userLevelBottomLabel;//用户等级下面的
@property(nonatomic,strong) UIButton *backBtn;


-(void)setUI;

@end
