//
//  DataNumTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "SceneInfoData.h"

@interface DataNumTableViewCell : UITableViewCell

@pro_strong UIButton            *   lookBtn;        //  查看
@pro_strong UIButton            *   likeBtn;        //  喜欢
@pro_strong UIButton            *   commentBtn;     //  评论
@pro_strong UIButton            *   moreBtn;        //  更多
@pro_strong UILabel             *   line;           //  分割线

- (void)setSceneDataNum:(SceneInfoData *)model;

@end
