//
//  THNGoodsCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNGoodsCollectionViewCell.h"
#import "GoodsRow.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+FSExtension.h"

@interface THNGoodsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation THNGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(GoodsRow *)model{
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%0.0f",model.salePrice];
}

@end
