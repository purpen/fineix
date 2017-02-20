//
//  THNSceneInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"
#import "TTTAttributedLabel.h"

@interface THNSceneInfoTableViewCell : UITableViewCell <
    TTTAttributedLabelDelegate
>

@pro_strong UINavigationController *nav;
@pro_strong UIView *graybackView;
@pro_strong TTTAttributedLabel *content;
@pro_strong UIButton *moreIcon;
@pro_assign CGFloat cellHigh;
@pro_assign CGFloat defaultCellHigh;

- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel;

@end
