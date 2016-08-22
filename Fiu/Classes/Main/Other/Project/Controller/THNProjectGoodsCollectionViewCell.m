//
//  THNProjectGoodsCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNProjectGoodsCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "THNProjectGoodsModel.h"

@interface THNProjectGoodsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation THNProjectGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(THNProjectGoodsModel *)model{
    _model = model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_500"]];
    self.goodTitleLabel.text = model.goodTitle;
    self.priceLabel.text = model.price;
}

@end
