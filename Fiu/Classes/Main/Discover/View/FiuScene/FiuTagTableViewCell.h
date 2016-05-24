//
//  FiuTagTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UIImage+Helper.h"
#import "HotTagsData.h"

@interface FiuTagTableViewCell : UITableViewCell

@pro_strong UINavigationController      *   nav;
@pro_strong UIScrollView                *   tagRollView;    //  标签滑动列表
@pro_strong NSMutableArray              *   tagTitleArr;

/** 搜索类型
 *  1:情景    
 *  2:商品
 */
@pro_assign NSInteger                       type;

- (void)setMallHotTagsData:(NSMutableArray *)model;

- (void)setHotTagsData:(NSMutableArray *)model;

@end
