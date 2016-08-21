//
//  THNArticleCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNArticleCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "THNArticleModel.h"

@interface THNArticleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation THNArticleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.titleLabel.text = model.title;
    self.countLabel.text = model.attend_count;
}

@end
