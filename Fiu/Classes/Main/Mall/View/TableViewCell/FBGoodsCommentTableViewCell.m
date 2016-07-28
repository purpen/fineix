//
//  FBGoodsCommentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBGoodsCommentTableViewCell.h"

@implementation FBGoodsCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.userHeaderImg];
        [_userHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self addSubview:self.userNameLab];
        [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userHeaderImg);
            make.left.equalTo(_userHeaderImg.mas_right).with.offset(10);
        }];
        
        [self addSubview:self.timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userNameLab);
            make.left.equalTo(_userNameLab.mas_right).with.offset(10);
        }];
        
        [self addSubview:self.starBgView];
        [_starBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 13));
            make.top.equalTo(_userHeaderImg.mas_bottom).with.offset(5);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self addSubview:self.textLab];
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_starBgView.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        
        [self addSubview:self.lineLab];
        [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 1));
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
    }
    return self;
}

- (void)setCommentModel:(CommentModelRow *)commentModel {
    self.textLab.text = commentModel.content;
    self.userNameLab.text = commentModel.user.nickname;
    [self.userHeaderImg downloadImage:commentModel.user.smallAvatarUrl place:[UIImage imageNamed:@""]];
    self.starNum = commentModel.star;
    [self.starBgView addSubview:self.starView];
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.center.equalTo(_starBgView);
    }];
}


- (UILabel *)lineLab {
    if (!_lineLab) {
        _lineLab = [[UILabel alloc] init];
        _lineLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    }
    return _lineLab;
}

- (UIImageView *)userHeaderImg {
    if (!_userHeaderImg) {
        _userHeaderImg = [[UIImageView alloc] init];
        _userHeaderImg.layer.masksToBounds = YES;
        _userHeaderImg.layer.cornerRadius = 15;
        
    }
    return _userHeaderImg;
}

- (UILabel *)userNameLab {
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _userNameLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _userNameLab.font = [UIFont systemFontOfSize:10];
        }
        _userNameLab.textColor = [UIColor colorWithHexString:titleColor];
        _userNameLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _userNameLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _timeLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _timeLab.font = [UIFont systemFontOfSize:10];
        }
        _timeLab.textColor = [UIColor colorWithHexString:titleColor];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _timeLab;
}

- (UIView *)starBgView{
    if (!_starBgView) {
        _starBgView = [[UIView alloc] init];
        
        for (NSUInteger idx = 0; idx < 5; idx++) {
            UIImageView * starImg = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 15*idx, 0, 13, 13)];
            starImg.image = [UIImage imageNamed:@"star_invalid"];
            [_starBgView addSubview:starImg];
        }
        
    }
    return _starBgView;
}

- (UIView *)starView {
    if (!_starView) {
        _starView = [[UIView alloc] init];
        
        for (NSUInteger idx = 0; idx < self.starNum; idx ++) {
            UIImageView * starImg = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 15*idx, 0, 13, 13)];
            starImg.image = [UIImage imageNamed:@"star"];
            [_starView addSubview:starImg];
        }
    }
    return _starView;
}

- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _textLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _textLab.font = [UIFont systemFontOfSize:10];
        }
        _textLab.textColor = [UIColor colorWithHexString:titleColor];
        _textLab.numberOfLines = 0;
    }
    return _textLab;
}

@end
