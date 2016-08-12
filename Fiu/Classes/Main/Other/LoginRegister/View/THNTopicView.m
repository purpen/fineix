//
//  THNTopicView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNTopicView.h"
#import "THNTopicsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Extension.h"

@interface THNTopicView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end

@implementation THNTopicView

-(void)setModel:(THNTopicsModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.back_url] placeholderImage:[UIImage imageNamed:@"l_topic_default"]];
    [self.tipBtn setTitle:model.title forState:UIControlStateNormal];
    self.layerView.backgroundColor = [UIColor colorWithHexString:@"#525252" alpha:0.4];
}

@end
