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

@interface THNSceneCommentTableViewCell : UITableViewCell

@pro_strong UIView *graybackView;
@pro_strong UIButton *headImage;
@pro_strong UILabel *comment;

- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel;

@end
