//
//  SubscribePeopleTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribePeopleTableViewCell.h"

@implementation SubscribePeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)getId{
    return @"SubscribePeopleTableViewCell";
}

+(instancetype)getSubscribePeopleTableViewCell{
    return [[NSBundle mainBundle] loadNibNamed:@"SubscribePeopleTableViewCell" owner:nil options:nil][0];
}

@end
