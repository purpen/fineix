//
//  THNActiveTopView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveTopView.h"
#import "THNArticleModel.h"
#import <UIImageView+WebCache.h>

@interface THNActiveTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation THNActiveTopView

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.short_title;
}

@end
