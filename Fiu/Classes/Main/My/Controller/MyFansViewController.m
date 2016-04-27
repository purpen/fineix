//
//  MyFansViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyFansViewController.h"
#import "FocusOnTableViewCell.h"
#import "MyFansActionSheetViewController.h"

@interface MyFansViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navViewTitle.text = @"粉丝";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.view addSubview:self.mytableView];
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        self.mytableView.delegate = self;
        self.mytableView.dataSource = self;
    }
    return _mytableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FocusOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FocusOnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.focusOnBtn.tag = indexPath.row;
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[cell setUI];
    return cell;
}

-(void)clickFocusBtn:(UIButton*)sender{
    if (!sender.selected) {
        sender.selected = !sender.selected;
    }else{
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        [sheetVC setUI];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:sheetVC animated:NO completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    FocusOnTableViewCell *cell = [_mytableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.focusOnBtn.selected = NO;
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55/667.0*SCREEN_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
