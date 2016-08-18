//
//  THNSenceTopicView.m
//  Fiu
//
//  Created by dys on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSenceTopicView.h"
#import "THNTopicsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Extension.h"

@interface THNSenceTopicView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;


@end

@implementation THNSenceTopicView

-(void)setModel:(THNTopicsModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.back_url] placeholderImage:[UIImage imageNamed:@"l_topic_default"]];
    [self.tipBtn setTitle:model.title forState:UIControlStateNormal];
    self.layerView.backgroundColor = [UIColor colorWithHexString:@"#525252" alpha:0.4];
    self.numLabel.text = [NSString stringWithFormat:@"已有%ld人订阅",(long)[model.sub_count integerValue]];
}

@end
