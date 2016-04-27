//
//  ChatTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "AXModel.h"
#import "Fiu.h"

@implementation ChatTableViewCell

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
    }
    return self;
}

-(void)setUIWithModel:(AXModel *)model{
    self.timeLabel.text = model.created_at;
    if ([model.lastTime isEqualToString:model.created_at]) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        self.timeLabel.hidden = NO;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20.5);
        }];
    }
    
    if (model.type == AXModelTypeMe) {
        self.meHeadImg.hidden = NO;
        self.otherHeadImg.hidden = YES;
        self.oterhMsgBtn.hidden = YES;
        self.meMsgBtn.hidden = NO;
        [self.meMsgBtn setTitle:model.content forState:UIControlStateNormal];
        [self setFunctionSupplyWithButton:self.meMsgBtn andImgView:self.meHeadImg];
    }else{
        self.meHeadImg.hidden = YES;
        self.otherHeadImg.hidden = NO;
        self.oterhMsgBtn.hidden = NO;
        self.meMsgBtn.hidden = YES;
        [self.oterhMsgBtn setTitle:model.content forState:UIControlStateNormal];
        [self setFunctionSupplyWithButton:self.oterhMsgBtn andImgView:self.otherHeadImg];
    }
}

-(void)setFunctionSupplyWithButton:(UIButton*)btn andImgView:(UIImageView*)img{
    btn.titleLabel.numberOfLines = 0;
    btn.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [self layoutIfNeeded];
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(btn.titleLabel.frame.size.height+20);
    }];
    [self layoutIfNeeded];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(btn.frame) > CGRectGetMaxY(img.frame) ? CGRectGetMaxY(btn.frame) : CGRectGetMaxY(img.frame)
);
    }];
}

@end
