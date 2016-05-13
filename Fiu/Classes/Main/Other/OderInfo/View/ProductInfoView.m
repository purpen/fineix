//
//  ProductInfoView.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/24.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "ProductInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductInfoModel.h"

@interface ProductInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

- (IBAction)tapViewGestureAction:(id)sender;

@end

@implementation ProductInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setProductInfo:(ProductInfoModel *)productInfo
{
    if (_productInfo != productInfo) {
        _productInfo = productInfo;
    }
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:productInfo.coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLbl.text = productInfo.name;
    if (productInfo.skuName) {
        self.typeLbl.text = [NSString stringWithFormat:@"颜色：%@，数量*%ld",productInfo.skuName,productInfo.quantity];
    }else{
        self.typeLbl.text = [NSString stringWithFormat:@"数量*%ld",productInfo.quantity];
    }
    
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.0f", [productInfo.salePrice floatValue]];
    //self.amountLbl.text = [NSString stringWithFormat:@"x %ld", productInfo.quantity];
}

- (IBAction)tapViewGestureAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tapProductInfoView:withProductInfo:)]) {
        [self.delegate tapProductInfoView:self withProductInfo:self.productInfo];
    }
}

@end
