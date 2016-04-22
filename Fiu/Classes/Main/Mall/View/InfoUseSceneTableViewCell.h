//
//  InfoUseSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface InfoUseSceneTableViewCell : UITableViewCell

@pro_strong UILabel             *   headerTitle;        //  标题
@pro_strong UILabel             *   line;               //  分割线
@pro_strong UIScrollView        *   useSceneRollView;   //  应用的场景

- (void)setUI:(NSArray *)sceneArr;

@end
