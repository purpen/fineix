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


@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end

@implementation THNActiveRuleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(THNActiveRuleModel *)model{
    _model = model;
    self.textLabel.text = model.summary;
    self.attendBtn.hidden = model.evt == 2;
}

@end
