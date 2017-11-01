//
//  FBGoodsCommentViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBGoodsCommentViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FBRequest *commentRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSString *targetId;

@property (nonatomic, strong) UITableView *commentTabel;   //  评论视图
@property (nonatomic, strong) UILabel *promptLab;

- (void)networkSceneCommenstData:(NSString *)targetId;

@end
