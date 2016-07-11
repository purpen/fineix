//
//  BrandsListTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "BrandListModel.h"

@interface BrandsListTableViewCell : UITableViewCell

@pro_strong UIImageView     *   brandImg;
@pro_strong UILabel         *   brandName;

- (void)setBrandListData:(BrandListModel *)model;

@end
