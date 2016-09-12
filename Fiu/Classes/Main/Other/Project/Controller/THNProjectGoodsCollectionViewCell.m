//
//  THNProjectGoodsCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNProjectGoodsCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "THNCuXiaoProductModel.h"

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

-(void)setModel:(THNCuXiaoProductModel *)model{
    _model = model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_500"]];
    self.goodTitleLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.sale_price];
}

@end
