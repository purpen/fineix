//
//  ContentAndTagTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"
#import "UIImage+Helper.h"

@interface ContentAndTagTableViewCell : UITableViewCell

@pro_strong UILabel             *   contentLab;     //  场景内容文字
@pro_strong UIScrollView        *   tagView;        //  标签视图
@pro_assign CGFloat      cellHeight;

- (void)setUI;

- (void)setContent:(NSString *)content;

@end
