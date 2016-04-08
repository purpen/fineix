//
//  SceneInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "DataNumTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"

@interface SceneInfoViewController ()

@end

@implementation SceneInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationViewUI];
    
    [self setSceneInfoViewUI];
    
}

#pragma mark -
- (void)setSceneInfoViewUI {
    [self.view addSubview:self.sceneTableView];
}

#pragma mark - 设置场景详情的视图
- (UITableView *)sceneTableView {
    if (!_sceneTableView) {
        _sceneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _sceneTableView.delegate = self;
        _sceneTableView.dataSource = self;
        _sceneTableView.showsVerticalScrollIndicator = NO;
        _sceneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sceneTableView.backgroundColor = [UIColor whiteColor];
    }
    return _sceneTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * userInfoCellId = @"userInfoCellId";
            UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            cell = [[UserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            [cell setUI];
            cell.navItem = self.navigationItem;
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * contentCellId = @"contentCellId";
            ContentAndTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
            cell = [[ContentAndTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentCellId];
            [cell setUI];
            return cell;
        
        } else if (indexPath.row == 2) {
            static NSString * dataNumCellId = @"dataNumCellId";
            DataNumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataNumCellId];
            cell = [[DataNumTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataNumCellId];
            [cell setUI];
            return cell;
            
        } else if (indexPath.row == 3) {
            static NSString * likePeopleCellId = @"likePeopleCellId";
            LikePeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:likePeopleCellId];
            cell = [[LikePeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:likePeopleCellId];
            [cell setUI];
            return cell;
        }
    }
    
    static NSString * CellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_HEIGHT;
            
        } else if (indexPath.row == 1) {
            NSString * str = @"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。它更是一条逼你拼命挣钱的鞭子，让你为它拉车犁地。家又是一个充满亲情的地方，就会有一种亲情感回荡心头。在风雨人生中，渐渐地形成了一种强烈的感觉：我爱家，更离不开家。";
            ContentAndTagTableViewCell * cell = [[ContentAndTagTableViewCell alloc] init];
            [cell setContent:str];
            return cell.cellHeight;
            
        } else if (indexPath.row == 2) {
            return 44;
            
        } else if (indexPath.row == 3) {
            NSArray * arr = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
            LikePeopleTableViewCell * cell = [[LikePeopleTableViewCell alloc] init];
            [cell getCellHeight:arr];
            return cell.cellHeight;
            
        }
        return 100;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    
    if (section == 1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"此场景下的商品" withSubtitle:@""];
    } else if (section == 2) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"相近的商品" withSubtitle:@""];
    }
    
    return self.headerView;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    self.delegate = self;
    [self addBarItemRightBarButton:@"" image:@"Share_Scene"];
    [self addNavLogo:@"Nav_Title"];
    [self navBarTransparent];
    [self hiddenNavItem:YES];
}

//  隐藏Nav左右的按钮
- (void)hiddenNavItem:(BOOL)hidden {
    self.navigationItem.leftBarButtonItem.customView.hidden = hidden;
    self.navigationItem.rightBarButtonItem.customView.hidden = hidden;
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊分享");
}

@end
