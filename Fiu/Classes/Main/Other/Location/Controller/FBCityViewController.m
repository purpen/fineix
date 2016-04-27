//
//  FBCityViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCityViewController.h"
#import "Fiu.h"

@interface FBCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FBCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    [self.view addSubview:self.myTableView];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        //_myTableView.delegate = self;
        //_myTableView.dataSource = self;
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"CityVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"全部城市" image:@"icon_map" isTransparent:NO];
}

@end
