//
//  SystemInfoTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemInfoTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLbael;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) UIView *lineView;

-(void)setUI;

@end
