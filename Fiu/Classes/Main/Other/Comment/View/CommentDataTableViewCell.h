//
//  CommentDataTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CommentRow.h"

@interface CommentDataTableViewCell : UITableViewCell

@pro_strong UIImageView             *   userHeader;     //  用户头像
@pro_strong UILabel                 *   userName;       //  用户昵称
@pro_strong UILabel                 *   time;           //  评论时间
@pro_strong UILabel                 *   content;        //  评论内容

- (void)setCommentData:(CommentRow *)model;

@end
