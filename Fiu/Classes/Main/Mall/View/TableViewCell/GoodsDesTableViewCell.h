//
//  GoodsDesTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/6/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"

@interface GoodsDesTableViewCell : UITableViewCell

@pro_strong UILabel             *   headerTitle;        //  标题
@pro_strong UILabel             *   line;               //  分割线
@pro_strong UILabel             *   desContent;         //  描述文字
@pro_assign CGFloat                 cellHeight;

- (void)setGoodsDesText:(NSString *)text;

- (void)getContentCellHeight:(NSString *)content;

@end
