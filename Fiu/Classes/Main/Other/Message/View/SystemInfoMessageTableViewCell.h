//
//  SystemInfoMessageTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemNoticeModel;
@class TipNumberView;

@interface SystemInfoMessageTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *tittleLabel;
@property(nonatomic,strong) UILabel *titleLabelTwo;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UILabel *detailsLabel;
@property(nonatomic,strong) UIButton *detailsBtn;
@property(nonatomic,strong) UIImageView *enterImageView;
@property(nonatomic,strong) TipNumberView *alertTipView;

-(void)setUIWithModel:(SystemNoticeModel*)model;

@end
