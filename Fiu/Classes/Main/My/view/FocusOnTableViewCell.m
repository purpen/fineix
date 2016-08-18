//
//  FocusOnTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FocusOnTableViewCell.h"
#import "Fiu.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfoEntity.h"
#import "TalentView.h"

@implementation FocusOnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        
        
        [self.contentView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32/667.0*SCREEN_HEIGHT,32/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.talentView];
        [_talentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10/667.0*SCREEN_HEIGHT, 10/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(_headImageView.mas_right).offset(0);
            make.bottom.mas_equalTo(_headImageView.mas_bottom).offset(0);
        }];
        
        [self.contentView addSubview:self.focusOnBtn];
        [_focusOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72/667.0*SCREEN_HEIGHT, 26/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nickNameLabel];
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_focusOnBtn.mas_left).with.offset(-10);
        }];
        
        [self.contentView addSubview:self.summaryLabel];
        [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nickNameLabel.mas_bottom).with.offset(5/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_focusOnBtn.mas_left).with.offset(-5);
            make.height.mas_equalTo(10);
        }];
        
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
            make.left.mas_equalTo(self.nickNameLabel.mas_left).with.offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
        }];
    }
    return self;
}

-(TalentView *)talentView{
    if (!_talentView) {
        _talentView = [TalentView getTalentView];
        _talentView.hidden = YES;
    }
    return _talentView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

-(void)setUIWithModel:(UserInfo *)model andType:(NSNumber *)type{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if ([type isEqualToNumber:@1]) {
        if ([entity.userId intValue] == [model.userId intValue]) {
            self.focusOnBtn.hidden = YES;
        }else{
            self.focusOnBtn.hidden = NO;
            if ([model.level isEqualToNumber:@1]) {
                self.focusOnBtn.selected = YES;
                self.focusOnBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
                self.focusOnBtn.layer.borderColor = [UIColor clearColor].CGColor;
            }else if ([model.level isEqualToNumber:@0]){
                self.focusOnBtn.selected = NO;
                self.focusOnBtn.backgroundColor = [UIColor whiteColor];
                self.focusOnBtn.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
                self.focusOnBtn.layer.borderWidth = 1;
            }
        }

    }else if ([type isEqualToNumber:@0]){
        if ([entity.userId intValue] == [model.userId intValue]) {
            self.focusOnBtn.hidden = YES;
        }else{
            self.focusOnBtn.hidden = NO;
            if (model.is_love == 1) {
                self.focusOnBtn.selected = YES;
                self.focusOnBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
                self.focusOnBtn.layer.borderColor = [UIColor clearColor].CGColor;
            }else if (model.is_love == 0){
                self.focusOnBtn.selected = NO;
                self.focusOnBtn.backgroundColor = [UIColor whiteColor];
                self.focusOnBtn.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
                self.focusOnBtn.layer.borderWidth = 1;
            }
        }
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nickNameLabel.text = model.nickname;
    if (model.summary.length == 0) {
        self.summaryLabel.text = @"";
    }else{
        self.summaryLabel.text = model.summary;
    }
    NSString *str = [NSString stringWithFormat:@"%@ | %@",model.expert_label,model.expert_info];
    if ([model.is_expert integerValue] == 1) {
        self.summaryLabel.text = str;
        self.talentView.hidden = NO;
    }
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 16/667.0*SCREEN_HEIGHT;
        _headImageView.layer.borderWidth = 1.0;
        _headImageView.layer.borderColor = [UIColor colorWithHexString:lineGrayColor].CGColor;
    }
    return _headImageView;
}

-(UIButton *)focusOnBtn{
    if (!_focusOnBtn) {
        _focusOnBtn = [[UIButton alloc] init];
        [_focusOnBtn setImage:[UIImage imageNamed:@"l_fucos_e"] forState:UIControlStateNormal];
        [_focusOnBtn setImage:[UIImage imageNamed:@"l_fucos_r"] forState:UIControlStateSelected];
        _focusOnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _focusOnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        [_focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_focusOnBtn setTitle:@"已关注" forState:UIControlStateSelected];
        _focusOnBtn.layer.masksToBounds = YES;
        _focusOnBtn.layer.cornerRadius = 3;
        _focusOnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_focusOnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_focusOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _focusOnBtn;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _nickNameLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    return _nickNameLabel;
}

-(UILabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _summaryLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _summaryLabel.font = [UIFont systemFontOfSize:10];
        }
        _summaryLabel.textColor = [UIColor lightGrayColor];
    }
    return _summaryLabel;
}

@end
