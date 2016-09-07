//
//  THNActiveRuleCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveRuleCollectionViewCell.h"
#import "THNActiveRuleModel.h"
#import "ClipImageViewController.h"

@interface THNActiveRuleCollectionViewCell ()


@end

@implementation THNActiveRuleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(THNActiveRuleModel *)model{
    _model = model;
    if (model.evt == 2) {
        self.attendBtn.userInteractionEnabled = NO;
        self.attendBtn.backgroundColor = [UIColor lightGrayColor];
    }else if (model.evt == 1) {
        [self.attendBtn setTitle:@"参与活动" forState:UIControlStateNormal];
    }else if (model.evt == 0) {
        [self.attendBtn setTitle:@"即将开始" forState:UIControlStateNormal];
        self.attendBtn.userInteractionEnabled = NO;
    }
}

@end
