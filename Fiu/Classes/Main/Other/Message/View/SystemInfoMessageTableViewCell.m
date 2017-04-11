//
//  SystemInfoMessageTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemInfoMessageTableViewCell.h"
#import "Fiu.h"
#import "SystemNoticeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TipNumberView.h"

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
            make.top.mas_equalTo(self.mas_top).with.offset(21/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        
        [self.contentView addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_timeLabel.mas_bottom).with.offset(21/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(-10/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
        
    }
    return self;
}

-(void)setUIWithModel:(SystemNoticeModel *)model{
    self.tipLabel.text = model.title;
    self.timeLabel.text = model.created_at;
    if (model.cover_url) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@""]];
        self.titleLabelTwo.hidden = YES;
        self.tittleLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.tittleLabel.text = model.content;
    }else{
        self.iconImageView.hidden = YES;
        self.tittleLabel.hidden = YES;
        self.titleLabelTwo.text = model.content;
        self.titleLabelTwo.hidden = NO;
    }
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
        
        [_bgView addSubview:self.alertTipView];
        [_alertTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5/667.0*SCREEN_HEIGHT, 5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_tipLabel.mas_right).with.offset(1);
            make.top.mas_equalTo(_tipLabel.mas_top).with.offset(-1);
        }];
        
        [_bgView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 50/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_bgView.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_tipLabel.mas_bottom).with.offset(10/667.0*SCREEN_HEIGHT);
        }];
        
        
        [_bgView addSubview:self.tittleLabel];
        [_tittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImageView.mas_right).with.offset(10/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(_iconImageView.mas_centerY);
            make.bottom.mas_equalTo(_iconImageView.mas_bottom).with.offset(5/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.titleLabelTwo];
        [_titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-10/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(_iconImageView.mas_centerY);
            make.bottom.mas_equalTo(_iconImageView.mas_bottom).with.offset(5/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((375-40)/667.0*SCREEN_HEIGHT, 0.5));
            make.left.mas_equalTo(_bgView.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_iconImageView.mas_bottom).with.offset(10/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.detailsLabel];
        [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_lineView.mas_bottom).with.offset(5/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.enterImageView];
        [_enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 15));
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-10/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(_detailsLabel.mas_centerY);
        }];
        
        [_bgView addSubview:self.detailsBtn];
        [_detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).with.offset(0);
            make.top.mas_equalTo(_lineView.mas_bottom).with.offset(0);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(0);
            make.bottom.mas_equalTo(_bgView.mas_bottom).with.offset(0);
        }];
    }
    return _bgView;
}

-(TipNumberView *)alertTipView{
    if (!_alertTipView) {
        _alertTipView = [TipNumberView getTipNumView];
        _alertTipView.tipNumLabel.text = @"";
        _alertTipView.layer.cornerRadius = 5*0.5/667.0*SCREEN_HEIGHT;
    }
    return _alertTipView;
}

-(UIButton *)detailsBtn{
    if (!_detailsBtn) {
        _detailsBtn = [[UIButton alloc] init];
        
    }
    return _detailsBtn;
}

-(UILabel *)titleLabelTwo{
    if (!_titleLabelTwo) {
        _titleLabelTwo = [[UILabel alloc] init];
        if (IS_iOS9) {
            _titleLabelTwo.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _titleLabelTwo.font = [UIFont systemFontOfSize:13];
        }
        _titleLabelTwo.textColor = [UIColor grayColor];
        _titleLabelTwo.numberOfLines = 0;
    }
    return _titleLabelTwo;
}

-(UIImageView *)enterImageView{
    if (!_enterImageView) {
        _enterImageView = [[UIImageView alloc] init];
        _enterImageView.image = [UIImage imageNamed:@"entr"];
    }
    return _enterImageView;
}

-(UILabel *)detailsLabel{
    if (!_detailsLabel) {
        _detailsLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _detailsLabel.font = [UIFont systemFontOfSize:13];
        }
        _detailsLabel.text = @"查看详情";
    }
    return _detailsLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

-(UILabel *)tittleLabel{
    if (!_tittleLabel) {
        _tittleLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _tittleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _tittleLabel.font = [UIFont systemFontOfSize:12];
        }
        _tittleLabel.textColor = [UIColor grayColor];
        _tittleLabel.numberOfLines = 0;
    }
    return _tittleLabel;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 25/667.0*SCREEN_HEIGHT;
    }
    return _iconImageView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _tipLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    return _tipLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _timeLabel.font = [UIFont systemFontOfSize:12];
        }
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 2;
    }
    return _timeLabel;
}

@end
