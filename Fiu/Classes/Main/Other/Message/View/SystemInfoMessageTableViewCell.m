//
//  SystemInfoMessageTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemInfoMessageTableViewCell.h"
#import "Fiu.h"

@implementation SystemInfoMessageTableViewCell

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
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self.contentView addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_timeLabel.mas_bottom).with.offset(10/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(10/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
        
    }
    return self;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [_bgView addSubview:self.tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(5/667.0*SCREEN_HEIGHT);
        }];
        
//        [_bgView addSubview:self.iconImageView];
//        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(<#CGFloat width#>, <#CGFloat height#>))
//        }];
    }
    return _bgView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

@end
