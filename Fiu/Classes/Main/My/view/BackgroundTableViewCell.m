//
//  BackgroundTableViewCell.m
//  Fiu
//
//  Created by dys on 16/4/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BackgroundTableViewCell.h"
#import "Fiu.h"

@implementation BackgroundTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
    }
    return self;
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bgImageView addSubview:self.userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_bgImageView.frame);
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(0);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(0);
        }];
    }
    return _bgImageView;
}

#pragma mark -用户信息
-(UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userHeadImageView];
        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.centerX.mas_equalTo(_userView.mas_centerX);
            make.top.mas_equalTo(_userView.mas_top).with.offset(80);
        }];
        
        [_userView addSubview:self.nickName];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 19));
             
        }];
    }
    return _userView;
}

-(UIImageView *)userHeadImageView{
    if (!_userHeadImageView) {
        _userHeadImageView = [[UIImageView alloc] init];
        _userHeadImageView.layer.masksToBounds = YES;
        _userHeadImageView.layer.cornerRadius = 40;
    }
    return _userHeadImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
