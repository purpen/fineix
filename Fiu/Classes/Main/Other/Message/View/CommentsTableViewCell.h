//
//  CommentsTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;
@class TipNumberView;

@interface CommentsTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLbael;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *timeLabelTwo;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UIButton *focusBtn;
@property(nonatomic,strong) UIButton *headBtn;
@property (nonatomic,strong) TipNumberView *alertTipviewNum;
/**  */
@property (nonatomic, strong) UINavigationController *navi;
/**  */
@property(nonatomic,copy) NSString *scenceId;
/**  */
@property (nonatomic, strong) UIButton *iconBtn;

-(void)setUIWithModel:(UserInfo*)model;

@end
