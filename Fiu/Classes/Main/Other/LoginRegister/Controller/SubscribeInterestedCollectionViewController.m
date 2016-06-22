//
//  SubscribeInterestedCollectionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribeInterestedCollectionViewController.h"
#import "TurnPageLayout.h"
#import "RecommendedScenarioView.h"
#import "Fiu.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "RecommendedScenarioModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "NumView.h"
#import "ImprovViewController.h"
#import "UserInfoEntity.h"

#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth   ([UIScreen mainScreen].bounds.size.width)

@interface SubscribeInterestedCollectionViewController ()<BMKLocationServiceDelegate,FBRequestDelegate>
{
    NumView *_numV;
    float _la;
    float _lo;
    NSMutableArray *_modelAry;
}

@property (nonatomic, strong) BMKLocationService *locationSevice;
@end

static NSString *const recommendedScenarioURL = @"/scene_scene/";
static NSString *const sceneSubscription = @"/favorite/ajax_subscription";

@implementation SubscribeInterestedCollectionViewController

-(instancetype)init{
    //创建布局对象
    TurnPageLayout *layout = [[TurnPageLayout alloc] init];
    return [super initWithCollectionViewLayout:layout];
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订阅感兴趣的情景";
    _modelAry = [NSMutableArray array];
    //创建定为服务对象
//    self.locationSevice = [[BMKLocationService alloc] init];
//    //设置定位服务对象代理
//    self.locationSevice.delegate = self;
//    self.locationSevice.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //1，开启定位服务
//    [self.locationSevice startUserLocationService];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    nextBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
    [nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+20/667.0*kScreenHeight, 240, 15)];
    CGPoint headLabelcenter = headLabel.center;
    headLabelcenter.x = self.view.center.x;
    headLabel.center = headLabelcenter;
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.text = @"现在你可以订阅感兴趣的情景来开始";
    headLabel.textColor = [UIColor grayColor];
    [self.view addSubview:headLabel];
    _numV = [NumView getNumView];
    _numV.frame = CGRectMake(kScreenWidth-90, kScreenHeight-44-30, 50, 30);
    [self.view addSubview:_numV];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    // Do any additional setup after loading the view.
    
    //发送请求获取数据
    NSDictionary *params = @{
                             @"page" : @1,
                             @"size" : @15,
                             @"sort" : @1,
                             };
    FBRequest *request = [FBAPI postWithUrlString:recommendedScenarioURL requestDictionary:params delegate:self];
    request.flag = recommendedScenarioURL;
    [request startRequest];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
}

//#pragma mark -BMKLocationServiceDelegate
//-(void)willStartLocatingUser{
//}

//-(void)didFailToLocateUserWithError:(NSError *)error{
//    //[_hud hideAnimated:YES];
//    //发送请求获取数据
//    NSDictionary *params = @{
//                             @"page" : @1,
//                             @"size" : @15,
//                             @"sort" : @0,
//                             @"stick" : @1,
//                             @"dis" : @5000,
//                             @"lng" : @(39.9),
//                             @"lat" : @(116.3)
//                             };
//    FBRequest *request = [FBAPI postWithUrlString:recommendedScenarioURL requestDictionary:params delegate:self];
//    request.flag = recommendedScenarioURL;
//    [request startRequest];
//}

////定位成功，再次定位
//-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    _la = userLocation.location.coordinate.latitude;
//    _lo = userLocation.location.coordinate.longitude;
//    
//
//    [_locationSevice stopUserLocationService];
//    //发送请求获取数据
//    NSDictionary *params = @{
//                             @"page" : @1,
//                             @"size" : @15,
//                             @"sort" : @0,
//                             @"stick" : @1,
//                             @"dis" : @5000,
//                             @"lng" : @(_lo),
//                             @"lat" : @(_la)
//                                 };
//    FBRequest *request = [FBAPI postWithUrlString:recommendedScenarioURL requestDictionary:params delegate:self];
//    request.flag = recommendedScenarioURL;
//    [request startRequest];
//}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:recommendedScenarioURL]) {
        NSDictionary *dataDic = result[@"data"];
        NSArray *dataAry = dataDic[@"rows"];
        for (int i = 0; i<dataAry.count; i++) {
            NSDictionary *modelDict = dataAry[i];
            NSDictionary *modellDict = @{
                                         @"covers":modelDict[@"cover_url"],
                                         @"title" : modelDict[@"title"],
                                         @"address" : modelDict[@"address"],
                                         @"subscription_count" : modelDict[@"subscription_count"],
                                         @"id" : modelDict[@"_id"]
                                         };
            RecommendedScenarioModel *model = [[RecommendedScenarioModel alloc] initWithDict:modellDict];
            model.flag = @0;
            //获取的数据转为模型存储起来
            [_modelAry addObject:model];
        }
        //进行数据展示
        [self.collectionView reloadData];
        _numV.totalNumberLabel.text = [NSString stringWithFormat:@"/%d",(int)_modelAry.count];
    }
}


//下一步按钮
-(void)clickNextBtn:(UIButton*)sender{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.nickname) {
        //已经订阅过，直接个人中心
        //跳回个人主页
        //跳回个人主页
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:3];
    }else{
        //跳转到个人信息完善页面
        ImprovViewController *improveVC = [[ImprovViewController alloc] init];
        [self.navigationController pushViewController:improveVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    //    //无限循环....
    //    float targetX = _scrollView.contentOffset.x;
    //    int numCount = [self.collectionView numberOfItemsInSection:0];
    //    float ITEM_WIDTH = _scrollView.frame.size.width;
    //
    //    if (numCount>=3)
    //    {
    //        if (targetX < ITEM_WIDTH/2) {
    //            [_scrollView setContentOffset:CGPointMake(targetX+ITEM_WIDTH *numCount, 0)];
    //        }
    //        else if (targetX >ITEM_WIDTH/2+ITEM_WIDTH *numCount)
    //        {
    //            [_scrollView setContentOffset:CGPointMake(targetX-ITEM_WIDTH *numCount, 0)];
    //        }
    //    }
    
    int page = (int)(_scrollView.contentOffset.x/(250/667.0*kScreenHeight+30/667.0*kScreenHeight)+0.5);
    _numV.currentNumberLabel.text = [NSString stringWithFormat:@"%d",page+1];
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





#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _modelAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    RecommendedScenarioView *view = [RecommendedScenarioView getRecommendedScenarioView];
    view.frame = cell.contentView.frame;
    RecommendedScenarioModel *model = _modelAry[indexPath.row];
    [view.coversImageView sd_setImageWithURL:[NSURL URLWithString:model.covers] placeholderImage:[UIImage imageNamed:@"scenario"]];
    view.tittleLabel.text = model.title;
    view.addressLabel.text = model.address;
    view.subscribeNumberLabel.text = [NSString stringWithFormat:@"订阅人%d",model.subscription_count];
    if ([model.flag isEqualToNumber:@0]) {
        view.subscribeBtn.selected = NO;
    }else if ([model.flag isEqualToNumber:@1]){
        view.subscribeBtn.selected = YES;
    }
    view.backgroundColor = [UIColor clearColor];
    [view.subscribeBtn addTarget:self action:@selector(clickSubscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    view.subscribeBtn.tag = indexPath.row;
    [cell.contentView addSubview:view];
    //    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-20)];
    //    imageview.image = [UIImage imageNamed:@"scenario"];
    //    [cell.contentView addSubview:imageview];
    //    cell.image = [UIImage imageNamed:@"scenario"];
    return cell;
}

//点击订阅按钮
-(void)clickSubscribeBtn:(UIButton*)sender{
    RecommendedScenarioModel *model = _modelAry[sender.tag];
    if (sender.selected == NO) {
        //订阅
        NSDictionary *params = @{
                                 @"id":@(model.id)
                                 };
        FBRequest *request = [FBAPI postWithUrlString:sceneSubscription requestDictionary:params delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if (result[@"success"]) {
                [SVProgressHUD showSuccessWithStatus:@"订阅成功"];
                model.flag = @1;
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"订阅失败"];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else if(sender.selected == YES){
        //取消订阅
        FBRequest *request = [FBAPI postWithUrlString:@"/favorite/ajax_cancel_subscription" requestDictionary:@{@"id":@(sender.tag)} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                [SVProgressHUD showSuccessWithStatus:@"取消订阅成功"];
                model.flag = @0;
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil]];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"操作失败"];
        }];
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
