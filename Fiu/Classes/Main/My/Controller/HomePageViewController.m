//
//  HomePageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomePageViewController.h"
#import "ChanelView.h"
#import "MyPageFocusOnViewController.h"
#import "MyFansViewController.h"
#import "BackgroundCollectionViewCell.h"
#import "OtherCollectionViewCell.h"
#import "ScenceListCollectionViewCell.h"
#import "AllSceneCollectionViewCell.h"
#import "FBSheetViewController.h"
#import "Fiu.h"
#import "AccountManagementViewController.h"
#import "UserInfoEntity.h"
#import "DirectMessagesViewController.h"
#import <SVProgressHUD.h>
#import "FiuSceneRow.h"
#import "MJRefresh.h"
#import "FiuSceneViewController.h"
#import "HomeSceneListRow.h"
#import "SceneInfoViewController.h"

@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBRequestDelegate>
{
    ChanelView *_chanelV;
    NSMutableArray *_fiuSceneList;
    NSMutableArray *_fiuSceneIdList;
    NSMutableArray *_sceneListMarr;
    NSMutableArray *_sceneIdMarr;
    int _n;
    int _m;
}
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 1;
    _m = 1;
    _fiuSceneList = [NSMutableArray array];
    _fiuSceneIdList = [NSMutableArray array];
    _sceneListMarr = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:self.myCollectionView];
    
    if ([self.type isEqualToNumber:@1]) {
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_scene/" requestDictionary:@{@"page":@(_n),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_scene";
        [request startRequest];
    }else if ([self.type isEqualToNumber:@2]){
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{@"page":@(_m),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_sight";
        [request startRequest];
    }

    
    //上拉加载更多
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.type isEqualToNumber:@1]) {
            _n ++;
            FBRequest *request = [FBAPI postWithUrlString:@"/scene_scene/" requestDictionary:@{@"page":@(_n),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
            request.flag = @"scene_scene";
            [request startRequest];
        }else if ([self.type isEqualToNumber:@2]){
            _m ++;
            FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{@"page":@(_m),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
            request.flag = @"scene_sight";
            [request startRequest];
        }
        [self.myCollectionView.mj_footer endRefreshing];
    }];
    
    
    
}


-(void)requestSucess:(FBRequest *)request result:(id)result{
    [SVProgressHUD show];
    if ([request.flag isEqualToString:@"scene_scene"]) {
        if ([result objectForKey:@"success"]) {
            NSArray * fiuSceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * fiuSceneDic in fiuSceneArr) {
                FiuSceneRow * fiuSceneModel = [[FiuSceneRow alloc] initWithDictionary:fiuSceneDic];
                [_fiuSceneList addObject:fiuSceneModel];
                [_fiuSceneIdList addObject:[NSString stringWithFormat:@"%zi", fiuSceneModel.idField]];
            }
            NSNumber *total_rows = [[result valueForKey:@"data"] valueForKey:@"total_rows"];
            if (_fiuSceneList.count == [total_rows intValue]) {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myCollectionView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismiss];
        }
    }else if ([request.flag isEqualToString:@"scene_sight"]){
        if ([result objectForKey:@"success"]) {
            NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * sceneDic in sceneArr) {
                HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
                [_sceneListMarr addObject:homeSceneModel];
                [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            }
            NSNumber *total_rows = [[result valueForKey:@"data"] valueForKey:@"total_rows"];
            if (_fiuSceneList.count == [total_rows intValue]) {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myCollectionView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismiss];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myCollectionView reloadData];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}


-(void)signleTap:(UITapGestureRecognizer*)sender{
    NSLog(@"情景");
    self.type = @1;
    if ([self.type isEqualToNumber:@1]) {
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_scene/" requestDictionary:@{@"page":@(_n),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_scene";
        [request startRequest];
    }else if ([self.type isEqualToNumber:@2]){
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{@"page":@(_m),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_sight";
        [request startRequest];
    }
    [self.myCollectionView reloadSections:[[NSIndexSet alloc] initWithIndex:2]];
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    NSLog(@"场景");
    self.type = @2;
    if ([self.type isEqualToNumber:@1]) {
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_scene/" requestDictionary:@{@"page":@(_n),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_scene";
        [request startRequest];
    }else if ([self.type isEqualToNumber:@2]){
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{@"page":@(_m),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        request.flag = @"scene_sight";
        [request startRequest];
    }
    [self.myCollectionView reloadSections:[[NSIndexSet alloc] initWithIndex:2]];
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

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[BackgroundCollectionViewCell class] forCellWithReuseIdentifier:@"BackgroundCollectionViewCell"];
        [_myCollectionView registerClass:[OtherCollectionViewCell class] forCellWithReuseIdentifier:@"OtherCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_myCollectionView registerClass:[ScenceListCollectionViewCell class] forCellWithReuseIdentifier:@"ScenceListCollectionViewCell"];
        [_myCollectionView registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"AllSceneCollectionViewCell"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 2){
        if ([self.type isEqualToNumber:@2]) {
            return _sceneListMarr.count;
        }else if([self.type isEqualToNumber:@1]){
            return _fiuSceneList.count;
        }
    }
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);;
    }else{
        return UIEdgeInsetsMake(3, 5, 0, 5);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isMySelf) {
            BackgroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BackgroundCollectionViewCell" forIndexPath:indexPath];
            [cell.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUI];
            return cell;
        }else{
            OtherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherCollectionViewCell" forIndexPath:indexPath];
            [cell.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.directMessages addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUI];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
            _chanelV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
            [cell.contentView addSubview:_chanelV];
            return cell;
        }
    }else if (indexPath.section == 2){
        if ([self.type isEqualToNumber:@2]) {
            ScenceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScenceListCollectionViewCell" forIndexPath:indexPath];
            [cell setUIWithModel:_sceneListMarr[indexPath.row]];
            return cell;
        }else if([self.type isEqualToNumber:@1]){
            AllSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllSceneCollectionViewCell" forIndexPath:indexPath];
            [cell setAllFiuSceneListData:_fiuSceneList[indexPath.row]];
            return cell;
        }
        
    }
    return nil;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@1]) {
            FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
            fiuSceneVC.fiuSceneId = _fiuSceneIdList[indexPath.row];
            [self.navigationController pushViewController:fiuSceneVC animated:YES];
        }else if([self.type isEqualToNumber:@2]){
            SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
            sceneInfoVC.sceneId = _sceneIdMarr[indexPath.row];
            [self.navigationController pushViewController:sceneInfoVC animated:YES];
        }
    }
}

-(void)clickEditBtn:(UIButton*)sender{
        AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickBackBtn:(UIButton*)sender{
    NSLog(@"backBtn");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
}

-(void)clickMessageBtn:(UIButton*)sender{
    DirectMessagesViewController *vc = [[DirectMessagesViewController alloc] init];
    vc.nickName = @"boc747";

    [self.navigationController pushViewController:vc animated:YES];
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

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, 240/667.0*SCREEN_HEIGHT);
        }
    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@2]) {
            return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        }else if ([self.type isEqualToNumber:@1]){
            return CGSizeMake((SCREEN_WIDTH-15)/2, 320/667.0*SCREEN_HEIGHT);
        }
    }
    
    return CGSizeMake(0, 0);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滑动结束时获取当前滚动坐标的y值
    CGFloat y = scrollView.contentOffset.y;
    if (y<0) {
        //当坐标y大于0时就进行放大
        //改变图片的y坐标和高度
        if (_isMySelf) {
            BackgroundCollectionViewCell *cell = (BackgroundCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGRect frame = cell.bgImageView.frame;
            
            frame.origin.y = y;
            frame.size.height = -y+240/667.0*SCREEN_HEIGHT;
            cell.bgImageView.frame = frame;
        }else{
            OtherCollectionViewCell *cell = (OtherCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGRect frame = cell.bgImageView.frame;
            
            frame.origin.y = y;
            frame.size.height = -y+240/667.0*SCREEN_HEIGHT;
            cell.bgImageView.frame = frame;
        }
        
    }
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
