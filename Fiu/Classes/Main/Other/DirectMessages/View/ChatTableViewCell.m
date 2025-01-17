//
//  ChatTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "AXModel.h"
#import "Fiu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "THNUserData.h"
#import "HomePageViewController.h"

@interface ChatTableViewCell()

/** 私信对象头像的点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *otherHeadImageTap;

@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.myTextBtn.titleLabel.numberOfLines = 0;
    self.otherTextBtn.titleLabel.numberOfLines = 0;
}

- (void)setMessage:(AXModel *)message
{
    _message = message;
    
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    [self.myIconImageView sd_setImageWithURL:[NSURL URLWithString:userdata.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    
    
    if (message.hideTime) { // 隐藏时间
        self.timeLabel.hidden = YES;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else { // 显示时间
        self.timeLabel.text = message.created_at;
        self.timeLabel.hidden = NO;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
        }];
    }
    
    if ([message.user_type isEqualToNumber:@1]) { // 右边
        [self settingShowTextButton:self.myTextBtn showIconView:self.myIconImageView hideTextButton:self.otherTextBtn hideIconView:self.otherIconImageView];
    } else { // 左边
        [self settingShowTextButton:self.otherTextBtn showIconView:self.otherIconImageView hideTextButton:self.myTextBtn hideIconView:self.myIconImageView];
    }
    
    self.otherIconImageView.userInteractionEnabled = YES;
    [self.otherIconImageView addGestureRecognizer:self.otherHeadImageTap];
    
    
}

#pragma mark - 私信对象头像点击手势
-(UITapGestureRecognizer *)otherHeadImageTap{
    if (!_otherHeadImageTap) {
        _otherHeadImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOtherHeadImage)];
    }
    return _otherHeadImageTap;
}

#pragma mark - 点击私信对象头像事件
-(void)clickOtherHeadImage{
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.type = @2;
    vc.userId = _message.userId;
    [self.cellNavi pushViewController:vc animated:YES];
}

/**
 * 处理左右按钮、头像
 */
- (void)settingShowTextButton:(UIButton *)showTextButton showIconView:(UIImageView *)showIconView hideTextButton:(UIButton *)hideTextButton hideIconView:(UIImageView *)hideIconView
{
    hideTextButton.hidden = YES;
    hideIconView.hidden = YES;
    
    showTextButton.hidden = NO;
    showIconView.hidden = NO;
    
    // 设置按钮的文字
    [showTextButton setTitle:self.message.content forState:UIControlStateNormal];
    
    // 强制更新
    [showTextButton layoutIfNeeded];
    
    // 设置按钮的高度就是titleLabel的高度
    [showTextButton mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat btnH = showTextButton.titleLabel.frame.size.height+30;
        make.height.mas_equalTo(btnH);
    }];
    
    // 强制更新
    [showTextButton layoutIfNeeded];
    
    // 计算当前cell的高度
    CGFloat buttonMaxY = CGRectGetMaxY(showTextButton.frame);
    CGFloat iconMaxY = CGRectGetMaxY(showIconView.frame);
    self.message.cellHeight = MAX(buttonMaxY, iconMaxY) + 10;
    
    self.myIconImageView.layer.masksToBounds = YES;
    self.myIconImageView.layer.cornerRadius = 25;
    self.otherIconImageView.layer.masksToBounds = YES;
    self.otherIconImageView.layer.cornerRadius = 25;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
