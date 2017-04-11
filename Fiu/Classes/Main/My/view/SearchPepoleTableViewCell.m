//
//  SearchPepoleTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchPepoleTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "THNUserData.h"

@interface SearchPepoleTableViewCell ()

@end

@implementation SearchPepoleTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 35 * 0.5;
}

-(void)setModel:(THNUserData *)model{
    _model = model;
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nickNameLabel.text = model.nickname;
    self.signatureLabel.text = model.summary;
    
}

@end
