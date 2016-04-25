//
//  FiuSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuSceneViewController.h"
#import "UserInfoTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"
#import "SceneListTableViewCell.h"
#import "SceneInfoViewController.h"
#import "PictureToolViewController.h"

@interface FiuSceneViewController ()

@end

@implementation FiuSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textMar = [NSArray arrayWithObjects:@"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。", @"家是我们人生的驿站", @"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。它更是一条逼你拼命挣钱的鞭子，让你为它拉车犁地。家又是一个充满亲情的地方，就会有一种亲情感回荡心头。在风雨人生中，渐渐地形成了一种强烈的感觉：我爱家，更离不开家。",nil];
    
    [self setSceneInfoViewUI];
}

#pragma mark -
- (void)setSceneInfoViewUI {
    [self.view addSubview:self.fiuSceneTable];
    
    [self.view addSubview:self.suBtn];
}

#pragma mark - 订阅按钮
- (SuFiuScenrView *)suBtn {
    if (!_suBtn) {
        _suBtn = [[SuFiuScenrView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 44)];
    }
    return _suBtn;
}

#pragma mark - 设置场景详情的视图
- (UITableView *)fiuSceneTable {
    if (!_fiuSceneTable) {
        _fiuSceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _fiuSceneTable.delegate = self;
        _fiuSceneTable.dataSource = self;
        _fiuSceneTable.showsVerticalScrollIndicator = NO;
        _fiuSceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fiuSceneTable.backgroundColor = [UIColor whiteColor];
    }
    return _fiuSceneTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * userInfoCellId = @"userInfoCellId";
            UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            if (cell == nil) {
                cell = [[UserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            }
            [cell setFiuSceneUI];
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * contentCellId = @"contentCellId";
            ContentAndTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
            if (cell == nil) {
                cell = [[ContentAndTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentCellId];
            }
            cell.nav = self.navigationController;
//            [cell setUI];
            return cell;
            
        } else if (indexPath.row == 2) {
            static NSString * likePeopleCellId = @"likePeopleCellId";
            LikePeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:likePeopleCellId];
            if (cell == nil) {
                cell = [[LikePeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:likePeopleCellId];
            }
            [cell setUI];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        static NSString * fiuSceneTableViewCellID = @"fiuSceneTableViewCellID";
        SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneTableViewCellID];
        if (!cell) {
            cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneTableViewCellID];
        }
//        [cell setUI];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_HEIGHT;
            
        } else if (indexPath.row == 1) {
            NSString * str = @"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。它更是一条逼你拼命挣钱的鞭子，让你为它拉车犁地。家又是一个充满亲情的地方，就会有一种亲情感回荡心头。在风雨人生中，渐渐地形成了一种强烈的感觉：我爱家，更离不开家。";
            ContentAndTagTableViewCell * cell = [[ContentAndTagTableViewCell alloc] init];
            [cell getContentCellHeight:str];
            return cell.cellHeight;
            
        }  else if (indexPath.row == 2) {
            NSArray * arr = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
            LikePeopleTableViewCell * cell = [[LikePeopleTableViewCell alloc] init];
            [cell getCellHeight:arr];
            return cell.cellHeight;
        }
        
    } else if (indexPath.section == 1) {
        return SCREEN_HEIGHT + 5;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    
    if (section == 1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"此场景下的商品" withSubtitle:@""];
    }
    
    return self.headerView;
}

#pragma mark - 跳转到场景的详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.fiuSceneTable) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.fiuSceneTable) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            self.rollDown = YES;
        }else{
            self.rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.fiuSceneTable) {
        CGRect suBtnRect = self.suBtn.frame;
        
        if (self.rollDown == YES) {
            suBtnRect = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
            [UIView animateWithDuration:.3 animations:^{
                self.suBtn.frame = suBtnRect;
            }];
            
        } else if (self.rollDown == NO) {
            suBtnRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            [UIView animateWithDuration:.3 animations:^{
                self.suBtn.frame = suBtnRect;
            }];
        }
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    self.delegate = self;
    [self addBarItemRightBarButton:@"" image:@"icon_newScene"];
    [self addNavLogoImg];
    [self hiddenNavItem:NO];
}

//  隐藏Nav左右的按钮
- (void)hiddenNavItem:(BOOL)hidden {
    self.navigationItem.leftBarButtonItem.customView.hidden = hidden;
    self.navigationItem.rightBarButtonItem.customView.hidden = hidden;
}

//  点击右边barItem
- (void)rightBarItemSelected {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    pictureToolVC.createType = @"scene";
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

@end
