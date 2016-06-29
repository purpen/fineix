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

@implementation FocusOnTableViewCell

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
            make.size.mas_equalTo(CGSizeMake(32/667.0*SCREEN_HEIGHT,32/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
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
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
            make.left.mas_equalTo(self.mas_left).with.offset(0);
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

-(void)setUIWithModel:(UserInfo *)model andType:(NSNumber *)type{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if ([type isEqualToNumber:@1]) {
        if ([entity.userId intValue] == [model.userId intValue]) {
            self.focusOnBtn.hidden = YES;
            if (model.is_love == 1) {
            }else if (model.is_love == 2 ){
                self.focusOnBtn.selected = YES;
            }
        }else{
            self.focusOnBtn.hidden = NO;
            if ([model.level isEqualToNumber:@1]) {
                self.focusOnBtn.selected = YES;
            }else if ([model.level isEqualToNumber:@0]){
                self.focusOnBtn.selected = NO;
            }
        }

    }else if ([type isEqualToNumber:@0]){
        if ([entity.userId intValue] == [model.userId intValue]) {
            self.focusOnBtn.hidden = YES;
        }else{
            self.focusOnBtn.hidden = NO;
            if (model.is_love == 1) {
                self.focusOnBtn.selected = YES;
            }else if (model.is_love == 0){
                self.focusOnBtn.selected = NO;
            }
        }

    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nickNameLabel.text = model.nickname;
    if ([entity.userId isEqual:model.userId]) {
        if (model.summary.length == 0) {
            self.summaryLabel.text = @"";
        }else{
            self.summaryLabel.text = model.summary;
        }
    }else{
        if (model.summary.length == 0) {
            self.summaryLabel.text = @"";
        }else{
            self.summaryLabel.text = model.summary;
        }
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
        [_focusOnBtn setImage:[UIImage imageNamed:@"focusOn"] forState:UIControlStateNormal];
        [_focusOnBtn setImage:[UIImage imageNamed:@"hasBeenFocusedOn"] forState:UIControlStateSelected];
    }
    return _focusOnBtn;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickNameLabel;
}

-(UILabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.font = [UIFont systemFontOfSize:10];
        _summaryLabel.textColor = [UIColor lightGrayColor];
    }
    return _summaryLabel;
}

@end
