//
//  FiuHeaderTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/6/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@class LMSpringboardItemView;
@class LMSpringboardView;

@interface FiuHeaderWatchTableViewCell : UITableViewCell

@pro_strong UINavigationController      *   nav;
@property (readonly) LMSpringboardView  *   springboard;

- (void)setHeaderImage:(NSArray *)img withId:(NSArray *)ids withType:(NSInteger)type;

@end
