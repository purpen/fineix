//
//  FBGoodsCommentTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CommentModelRow.h"

@interface FBGoodsCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel               *       lineLab;            //  分割线
@property (strong, nonatomic) UIImageView           *       userHeaderImg;      //  用户头像
@property (strong, nonatomic) UILabel               *       userNameLab;        //  用户昵称
@property (strong, nonatomic) UILabel               *       timeLab;            //  评论时间
@property (strong, nonatomic) UIView                *       starBgView;         //  星星
@property (strong, nonatomic) UIView                *       starView;           //  评价点亮的星星
@property (assign, nonatomic) NSInteger                     starNum;
@property (strong, nonatomic) UILabel               *       textLab;            //  评价的内容

- (void)setCommentModel:(CommentModelRow *)commentModel;

@end
