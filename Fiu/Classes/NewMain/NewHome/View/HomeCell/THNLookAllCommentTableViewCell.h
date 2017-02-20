//
//  THNLookAllCommentTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNLookAllCommentTableViewCell : UITableViewCell

@pro_strong UILabel *allComment;
@pro_strong UIView *graybackView;

- (void)thn_setAllCommentCountData:(NSInteger)count;

@end
