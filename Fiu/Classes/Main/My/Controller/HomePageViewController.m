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

@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ChanelView *_chanelV;
}
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.myCollectionView reloadSections:[[NSIndexSet alloc] initWithIndex:2]];
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    NSLog(@"场景");
    self.type = @2;
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
            return 3;
        }else if([self.type isEqualToNumber:@1]){
            return 3;
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
            [cell setUI];
            return cell;
        }else if([self.type isEqualToNumber:@1]){
            AllSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllSceneCollectionViewCell" forIndexPath:indexPath];
            [cell setUI];
            return cell;
        }
        
    }
    return nil;

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
