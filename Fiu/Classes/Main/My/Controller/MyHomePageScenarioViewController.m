//
//  MyHomePageScenarioViewController.m
//  Fiu
//
//  Created by dys on 16/4/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomePageScenarioViewController.h"
#import "Fiu.h"
#import "BackgroundTableViewCell.h"
#import "ChanelView.h"
#import "SceneListTableViewCell.h"
#import "MyHomePageView.h"
#import "MyPageFocusOnViewController.h"
#import "MyFansViewController.h"
#import "OtherBackGrandTableViewCell.h"
#import "FBSheetViewController.h"

@interface MyHomePageScenarioViewController ()<UITableViewDelegate,UITableViewDataSource,FBNavigationBarItemsDelegate>
{
    ChanelView *_chanelV;
    int _y;
    int _n;
}
@end

@implementation MyHomePageScenarioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    _chanelV = [ChanelView getChanelView];
    //情景
    _chanelV.scenarioView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap:)];
    scenarioTap.numberOfTapsRequired = 1;
    scenarioTap.numberOfTouchesRequired = 1;
    [_chanelV.scenarioView addGestureRecognizer:scenarioTap];
    //场景
    _chanelV.fieldView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap1:)];
    scenarioTap1.numberOfTapsRequired = 1;
    scenarioTap1.numberOfTouchesRequired = 1;
    [_chanelV.fieldView addGestureRecognizer:scenarioTap1];
    //关注
    _chanelV.focusView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap2:)];
    scenarioTap2.numberOfTapsRequired = 1;
    scenarioTap2.numberOfTouchesRequired = 1;
    [_chanelV.focusView addGestureRecognizer:scenarioTap2];
    //粉丝
    _chanelV.fansView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap3:)];
    scenarioTap3.numberOfTapsRequired = 1;
    scenarioTap3.numberOfTouchesRequired = 1;
    [_chanelV.fansView addGestureRecognizer:scenarioTap3];

    //
    _n = 1;
    //设置tableview
    [self.view addSubview:self.myTableView];
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }else if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)signleTap:(UITapGestureRecognizer*)sender{
    NSLog(@"情景");
    self.type = @1;
    [self.myTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationRight];
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    NSLog(@"场景");
    self.type = @2;
    [self.myTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)signleTap2:(UITapGestureRecognizer*)sender{
    NSLog(@"跳转到我的主页的关注的界面");
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)sender{
    NSLog(@"跳转到我的主页的粉丝的界面");
    MyFansViewController *view = [[MyFansViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

//导航栏左边按钮
-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

#pragma mark - tableViewDelegate & dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2){
        if ([self.type isEqualToNumber:@2]) {
            return 3;
        }else if([self.type isEqualToNumber:@1]){
            return _n;
        }
    }

    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isMySelf) {
            static NSString *backImageCellId = @"backImageCellId";
            BackgroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:backImageCellId];
            if (cell == nil) {
                cell = [[BackgroundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:backImageCellId];
            }
            [cell.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUI];
            return cell;
        }else{
            static NSString *otherCellId = @"other";
            OtherBackGrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
            if (cell == nil) {
                cell = [[OtherBackGrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
            }
            [cell.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.focusOnBtn addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
//            [cell.directMessages addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
            [cell setUI];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *chanel = @"chanel";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chanel];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chanel];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _chanelV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
            [cell.contentView addSubview:_chanelV];
            return cell;
        }
    }else if (indexPath.section == 2){
        if ([self.type isEqualToNumber:@2]) {
            static NSString *sceneListTableViewCellId = @"sceneListTableViewCellId";
            SceneListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneListTableViewCellId];
            if (cell == nil) {
                cell = [[SceneListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sceneListTableViewCellId];
            }
            [cell setUI];
            return cell;
        }else if([self.type isEqualToNumber:@1]){
            static NSString *loveListId = @"loveListId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loveListId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loveListId];
                int p;
                _y = 0;
                if (_n%2 == 0) {
                    p = _n/2;
                }else{
                    p = (_n+1)/2;
                }
                for (int i = 0; i<p; i++) {
                    
                    for (int j = 0; j<2; j++) {
                        if (_n%2 != 0) {
                            if (i == p-1 && j == 1) {
                                break;
                            }
                        }
                        MyHomePageView *myHomepageV = [MyHomePageView getMyHomePageView];
                        [myHomepageV setUI];
                        int x = 5/667.0*SCREEN_HEIGHT+j*(myHomepageV.frame.size.width+5/667.0*SCREEN_HEIGHT);
                        _y = i*(myHomepageV.frame.size.height+5/667.0*SCREEN_HEIGHT);
                        myHomepageV.frame = CGRectMake(x, _y, myHomepageV.frame.size.width, myHomepageV.frame.size.height);
                        [cell.contentView addSubview:myHomepageV];
                    }
                }

            }
            return cell;
        }
        
    }
    return nil;
}

-(void)clickMoreBtn:(UIButton*)sender{
    FBSheetViewController *sheetVC = [[FBSheetViewController alloc] init];
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:NO completion:nil];
    [sheetVC initFBSheetVCWithNameAry:[NSArray arrayWithObjects:@"拉黑用户",@"举报",@"取消", nil]];
    [((UIButton*)sheetVC.sheetView.subviews[2]) addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)clickBackBtn:(UIButton*)sender{
    NSLog(@"backBtn");
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 240/667.0*SCREEN_HEIGHT;
        }
    }
    if (indexPath.section == 1) {
        return 60/667.0*SCREEN_HEIGHT;
    }
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@2]) {
            return SCREEN_HEIGHT;
        }else if ([self.type isEqualToNumber:@1]){
            return 320/667.0*SCREEN_HEIGHT;
        }
    }
    
    return 0;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滑动结束时获取当前滚动坐标的y值
    CGFloat y = scrollView.contentOffset.y;
    if (y<0) {
        //当坐标y大于0时就进行放大
        //改变图片的y坐标和高度
        if (_isMySelf) {
            BackgroundTableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGRect frame = cell.bgImageView.frame;
            
            frame.origin.y = y;
            frame.size.height = -y+240/667.0*SCREEN_HEIGHT;
            cell.bgImageView.frame = frame;
        }else{
            OtherBackGrandTableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGRect frame = cell.bgImageView.frame;
            
            frame.origin.y = y;
            frame.size.height = -y+240/667.0*SCREEN_HEIGHT;
            cell.bgImageView.frame = frame;
        }
        
    }
}



-(void)getNetData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
