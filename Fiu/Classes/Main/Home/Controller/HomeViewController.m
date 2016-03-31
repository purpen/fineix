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
    
//    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
    [self.view addSubview:self.homeTableView];
    
}

#pragma mark - 加载首页表格
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
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
        CGFloat rollY = scrollView.contentOffset.y;
        NSLog(@"＝＝＝＝＝＝＝＝＝＝  %f", rollY);
    }

        
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

