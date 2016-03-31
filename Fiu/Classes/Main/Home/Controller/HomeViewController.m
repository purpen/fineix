//
//  HomeViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationViewUI];
    
    [self.view addSubview:self.homeTableView];
    
}

#pragma mark - 加载首页表格
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO;
    }
    return _homeTableView;
}

#pragma mark - tableView Delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"homeTableViewCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi个", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.homeTableView) {
        CGFloat newY = scrollView.contentOffset.y;
        CGFloat oldY = 0;
        //  设置滚动的状态
        if (newY != oldY) {
            if (newY > oldY) {
                self.rollDown = YES;
            } else if (newY < oldY) {
                self.rollDown = NO;
            }
            oldY = newY;
        }
        
        CGRect tabBarRect = self.tabBarController.tabBar.frame;
        UIView * leftBarItem = self.navigationItem.leftBarButtonItem.customView;
        UIView * rightBarItem = self.navigationItem.rightBarButtonItem.customView;
        
        //  判断是否下拉
        if (self.rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 10, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                leftBarItem.alpha = 0;
                rightBarItem.alpha = 0;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
            }];
            
            
        } else if (self.rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                leftBarItem.alpha = 1;
                rightBarItem.alpha = 1;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
            }];
        }
        
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ %f ----  %f", oldY, newY);
        
    }
        
}

- (BOOL)prefersStatusBarHidden {
    return self.rollDown;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Concern"];
    [self addNavLogo:@"Nav_Title"];
    [self navBarTransparent];
    
}

//  点击左边barItem
- (void)leftBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊搜索");
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊关注");
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
    }else{
        NSLog(@"已经不是第一次启动了");
    }
}

@end

