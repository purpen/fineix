//
//  ProductInfoView.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/24.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductInfoModel;
@class ProductInfoView;
@protocol ProductInfoViewDelegate <NSObject>

@optional
- (void)tapProductInfoView:(ProductInfoView *)productInfoView withProductInfo:(ProductInfoModel *)productInfo;

@end

@class ProductInfoModel;
@interface ProductInfoView : UIView

@property (nonatomic, strong) ProductInfoModel * productInfo;
@property (nonatomic, weak) id<ProductInfoViewDelegate> delegate;

@end
