//
//  THNSceneCommentTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"
#import "TTTAttributedLabel.h"

@interface THNSceneCommentTableViewCell : UITableViewCell <
    TTTAttributedLabelDelegate
>

@pro_strong UINavigationController *nav;
@pro_strong UIView *graybackView;
@pro_strong UIButton *headImage;
@pro_strong TTTAttributedLabel *comment;
@pro_assign CGFloat cellHigh;

- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel;

@end
