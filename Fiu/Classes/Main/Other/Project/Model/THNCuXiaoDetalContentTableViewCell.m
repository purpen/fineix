//
//  THNCuXiaoDetalContentTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoDetalContentTableViewCell.h"
#import "THNProductModel.h"
#import <UIImageView+WebCache.h>
#import "FBGoodsInfoViewController.h"

@interface THNCuXiaoDetalContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;

@end

@implementation THNCuXiaoDetalContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(THNProductModel *)model{
    _model = model;
    self.summaryLabel.text = model.summary;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.goodsTitleLabel.text = model.title;
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.market_price];
    self.salePriceLabel.text = [NSString stringWithFormat:@"￥%@",model.sale_price];
}

- (IBAction)buy:(id)sender {
    FBGoodsInfoViewController *vc = [[FBGoodsInfoViewController alloc] init];
    vc.goodsID = self.model._id;
    [self.navi pushViewController:vc animated:YES];
}

@end
