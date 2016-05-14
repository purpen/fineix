//
//  CommentTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"
#import "CommentRow.h"

@interface CommentTableViewCell : UITableViewCell

@pro_strong UIImageView         *   bubble;         //  气泡背景
@pro_strong UILabel             *   comment;        //  文字内容
@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_assign CGFloat                 cellHeight;

- (void)getCellHeight:(NSString *)str;

- (void)setCommentData:(CommentRow *)model;

@end