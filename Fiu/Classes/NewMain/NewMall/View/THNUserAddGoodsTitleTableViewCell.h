//
//  THNUserAddGoodsTitleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/9/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILable+Frame.h"
#import "Fiu.h"

@interface THNUserAddGoodsTitleTableViewCell : UITableViewCell

@pro_strong UILabel         *       goodsTitle;     //  商品标题
@pro_assign CGFloat                 cellHeight;

- (void)getContentCellHeight:(NSString *)content;

@end
