//
//  CommentViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface CommentViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong UITableView             *   commentTabel;   //  评论视图

@end
