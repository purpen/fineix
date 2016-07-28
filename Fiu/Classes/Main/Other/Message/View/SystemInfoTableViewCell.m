//
//  SystemInfoTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemInfoTableViewCell.h"
#import "Fiu.h"

@implementation SystemInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [self.contentView addSubview:self.titleLbael];
        [_titleLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(68, 21));
            make.left.mas_equalTo(self.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 21));
            make.left.mas_equalTo(_titleLbael.mas_right).with.offset(5);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.contentView addSubview:self.msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(248/667.0*SCREEN_HEIGHT, 35/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_timeLabel.mas_bottom).with.offset(0);
        }];
        
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
    }
    
    return self;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

-(UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _msgLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _msgLabel.font = [UIFont systemFontOfSize:10];
        }
        _msgLabel.textColor = [UIColor lightGrayColor];
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

-(UILabel *)titleLbael{
    if (!_titleLbael) {
        _titleLbael = [[UILabel alloc] init];
        _titleLbael.text = @"系统消息";
        if (IS_iOS9) {
            _titleLbael.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _titleLbael.font = [UIFont systemFontOfSize:14];
        }
    }
    return _titleLbael;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _timeLabel.font = [UIFont systemFontOfSize:13];
        }
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

@end
