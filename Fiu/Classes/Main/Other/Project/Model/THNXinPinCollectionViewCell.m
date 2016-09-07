//
//  THNXinPinCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNXinPinCollectionViewCell.h"
#import "THNArticleModel.h"
#import <UIImageView+WebCache.h>

@interface THNXinPinCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation THNXinPinCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.titleLabel.text = model.title;
    self.countLabel.text = [NSString stringWithFormat:@"%@人浏览",model.view_count];
}


@end
