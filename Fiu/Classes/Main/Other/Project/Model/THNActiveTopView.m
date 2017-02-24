//
//  THNActiveTopView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveTopView.h"
#import "THNArticleModel.h"
#import "UIImageView+WebCache.h"

@interface THNActiveTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation THNActiveTopView

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.short_title;
    if (model.evt == 2) {
        self.timeLabel.text = @"已结束";
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
    }
}

@end
