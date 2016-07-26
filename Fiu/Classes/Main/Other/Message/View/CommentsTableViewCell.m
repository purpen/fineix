//
//  CommentsTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "Fiu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfo.h"
#import "TipNumberView.h"

@implementation CommentsTableViewCell

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
        
        [self.contentView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30/667.0*SCREEN_HEIGHT, 30/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.contentView addSubview:self.headBtn];
        [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        
        [self.contentView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        
        [self.contentView addSubview:self.titleLbael];
        [_titleLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.size.mas_equalTo(CGSizeMake(150, 21));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110, 21));
            make.right.mas_equalTo(_iconImageView.mas_left).with.offset(-15);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.timeLabelTwo];
        [_timeLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 21));
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(248/667.0*SCREEN_HEIGHT, 35/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(10/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_titleLbael.mas_bottom).with.offset(-3);
        }];
        
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
        
        [self.contentView addSubview:self.focusBtn];
        [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72/667.0*SCREEN_HEIGHT, 26/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.alertTipviewNum];
        self.alertTipviewNum.tipNumLabel.text = @"";
        [self.alertTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5/667.0*SCREEN_HEIGHT, 5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.titleLbael.mas_right).with.offset(5);
            make.centerY.mas_equalTo(self.titleLbael.mas_centerY);
        }];
    }
    
    return self;
}

-(UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [[UIButton alloc] init];
    }
    return _headBtn;
}

-(UIButton *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] init];
        [_focusBtn setImage:[UIImage imageNamed:@"focusOn"] forState:UIControlStateNormal];
        [_focusBtn setImage:[UIImage imageNamed:@"hasBeenFocusedOn"] forState:UIControlStateSelected];
    }
    return _focusBtn;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 15/667.0*SCREEN_HEIGHT;
    }
    return _headImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

-(void)setUIWithModel:(UserInfo *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    self.timeLabel.text = model.birthday;
    self.timeLabelTwo.text = model.birthday;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_pic_url] placeholderImage:[UIImage imageNamed:@"werwer"]];
    self.msgLabel.text = model.summary;
    self.titleLbael.text = model.nickname;
    if ([model.firstLogin isEqualToNumber:@1]) {
        //不显示
        self.alertTipviewNum.hidden = YES;
    }else if ([model.firstLogin isEqualToNumber:@0]){
        //显示
        self.alertTipviewNum.hidden = NO;
    }
}


    
-(TipNumberView *)alertTipviewNum{
    if (!_alertTipviewNum) {
        _alertTipviewNum = [TipNumberView getTipNumView];
        _alertTipviewNum.layer.masksToBounds = YES;
        _alertTipviewNum.layer.cornerRadius = 5*0.5/667.0*SCREEN_HEIGHT;
    }
    return _alertTipviewNum;
}
    
    

-(UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
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
        _titleLbael.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    return _titleLbael;
}

-(UILabel *)timeLabelTwo{
    if (!_timeLabelTwo) {
        _timeLabelTwo = [[UILabel alloc] init];
        _timeLabelTwo.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        _timeLabelTwo.textAlignment = NSTextAlignmentRight;
        _timeLabelTwo.textColor = [UIColor lightGrayColor];
    }
    return _timeLabelTwo;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}


@end
