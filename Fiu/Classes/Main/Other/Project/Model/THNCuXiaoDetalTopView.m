//
//  THNCuXiaoDetalTopView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoDetalTopView.h"
#import "THNCuXiaoDetalModel.h"
#import <UIImageView+WebCache.h>

@interface THNCuXiaoDetalTopView ()



@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation THNCuXiaoDetalTopView

-(void)setModel:(THNCuXiaoDetalModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.textLabel.text = model.title;
    self.summaryLabel.text = model.summary;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
    self.subTitleLabel.text = model.short_title;
}

@end
