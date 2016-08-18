//
//  THNSearchGoodsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNSearchGoodsTableViewCell : UITableViewCell

@pro_strong UILabel *brandName;
@pro_strong UILabel *goodsName;

- (void)setGoodsInfo:(NSString *)brandTitle withGoods:(NSString *)goodsTitle;

@end
