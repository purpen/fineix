//
//  MorePeopleViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MorePeopleViewController.h"
#import "LikeOrSuPeopleRow.h"
#import "FocusOnTableViewCell.h"
#import "HomePageViewController.h"

static NSString *const URLLikeScenePeople = @"/favorite";

@interface MorePeopleViewController ()

@end

@implementation MorePeopleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.peopleTable];
    if (self.type == 0) {
        self.likeType = @"sight";
        self.event = @"love";
        
    } else if (self.type == 1) {
        self.likeType = @"scene";
        self.event = @"subscription";
    }
    self.currentpageNum = 0;
    [self networkLikePeopleData];

}

#pragma mark 给此场景点赞的用户
- (void)networkLikePeopleData {
    [SVProgressHUD show];
    self.peopleRequest = [FBAPI postWithUrlString:URLLikeScenePeople requestDictionary:@{@"type":self.likeType, @"event":self.event, @"id":self.ids, @"page":@(self.currentpageNum + 1), @"size":@"30"} delegate:self];
    [self.peopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * rowsAry = [[result valueForKey:@"data"] valueForKey:@"rows"];
        NSLog(@"－－－－－－－－－－－ %@", rowsAry[0]);
//        for (NSDictionary * rowsDict in rowsAry) {
//            NSDictionary * followsDict = [rowsDict objectForKey:@"user"];
//            UserInfo * model = [[UserInfo alloc] init];
//            model.userId = followsDict[@"user_id"];
//            model.summary = followsDict[@"summary"];
//            model.nickname = followsDict[@"nickname"];
//            model.mediumAvatarUrl = followsDict[@"avatar_url"];
//            model.is_love = [rowsDict[@"type"] integerValue];
//            model.level = followsDict[@"is_love"];
//            model.expert_info = followsDict[@"expert_info"];
//            model.expert_label = followsDict[@"expert_label"];
//            model.is_expert = followsDict[@"is_expert"];
//            
//            [self.peopleMarr addObject:model];
//        }
        
        [self.peopleTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 加载用户表格
- (UITableView *)peopleTable {
    if (!_peopleTable) {
        _peopleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _peopleTable.delegate = self;
        _peopleTable.dataSource = self;
        _peopleTable.showsVerticalScrollIndicator = NO;
        _peopleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _peopleTable.pagingEnabled = YES;
    }
    return _peopleTable;
}

#pragma mark - tableView Delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peopleMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * morePeopleCellId = @"MorePeopleCellId";
    FocusOnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:morePeopleCellId];
    if (cell == nil) {
        cell = [[FocusOnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:morePeopleCellId];
    }
    
    UserInfo * model = [self.peopleMarr objectAtIndex:indexPath.row];
    
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.focusOnBtn.tag = indexPath.row;
    [cell setUIWithModel:model andType:@1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageViewController *v = [[HomePageViewController alloc] init];
    UserInfo *model = self.peopleMarr[indexPath.row];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    v.userId = model.userId;
    if ([entity.userId integerValue] == [model.userId integerValue]) {
        v.isMySelf = YES;
    }else{
        v.isMySelf = NO;
    }
    v.type = @2;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    UserInfo * model = self.peopleMarr[sender.tag];
    model.whetherFocusOn = !model.whetherFocusOn;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.peopleTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type == 0) {
        self.navViewTitle.text = NSLocalizedString(@"likePeopleVC", nil);
        
    } else if (self.type == 1) {
        self.navViewTitle.text = NSLocalizedString(@"suPeopleVC", nil);
    }
}

#pragma mark - 
- (NSMutableArray *)peopleMarr {
    if (!_peopleMarr) {
        _peopleMarr = [NSMutableArray array];
    }
    return _peopleMarr;
}

@end
