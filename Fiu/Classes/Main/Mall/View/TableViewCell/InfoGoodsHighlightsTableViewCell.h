//
//  InfoGoodsHighlightsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"
#import "GoodsInfoData.h"

@interface InfoGoodsHighlightsTableViewCell : UITableViewCell

@pro_strong UILabel             *   goodsDescribe;      //  产品描述
@pro_strong UILabel             *   describe;
@pro_assign CGFloat                 cellHeight;

- (void)setGoodsInfoData:(GoodsInfoData *)model;

- (void)getContentCellHeight:(NSString *)content;

@end
