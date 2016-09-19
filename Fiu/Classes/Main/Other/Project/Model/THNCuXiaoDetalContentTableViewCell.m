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
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *marketPriceLine;

@end

@implementation THNCuXiaoDetalContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.layer.cornerRadius = 3;
}

-(void)setModel:(THNProductModel *)model{
    _model = model;
    self.summaryLabel.text = model.summary;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    
    //  Fynn
    NSInteger salePrice = [model.sale_price integerValue];
    NSInteger marketPrice = [model.market_price integerValue];
    [self thn_GetGoodsPriceJudgmentIsEqual:salePrice withMarketPrice:marketPrice];
}


/**
 判断售价与原价是否相等，是否隐藏原价

 @param salePrice   售价
 @param marketPrice 原价
 */
- (void)thn_GetGoodsPriceJudgmentIsEqual:(NSInteger)salePrice withMarketPrice:(NSInteger)marketPrice {
    self.salePriceLabel.text = [NSString stringWithFormat:@"￥%zi",salePrice];
    if (salePrice == marketPrice) {
        self.marketPriceLabel.hidden = YES;
        self.marketPriceLine.hidden = YES;
    } else {
        self.marketPriceLabel.hidden = NO;
        self.marketPriceLine.hidden = NO;
        self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%zi",marketPrice];
    }
}

- (IBAction)buy:(id)sender {
    FBGoodsInfoViewController *vc = [[FBGoodsInfoViewController alloc] init];
    vc.goodsID = self.model._id;
    [self.navi pushViewController:vc animated:YES];
}

@end
