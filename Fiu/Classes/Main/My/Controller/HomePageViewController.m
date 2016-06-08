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
#import "ShieldingViewController.h"
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
#import "MyFansActionSheetViewController.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Helper.h"
#import "HomePageViewController.h"
#import "UIImagePickerController+Flag.h"
#import "ScenarioNonView.h"

#define UserHeadTag 1
#define BgTag 2

@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBRequestDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FBNavigationBarItemsDelegate>
{
    ChanelView *_chanelV;
    NSMutableArray *_fiuSceneList;
    NSMutableArray *_fiuSceneIdList;
    NSMutableArray *_sceneListMarr;
    NSMutableArray *_sceneIdMarr;
    int _n;
    int _m;
    int _totalN;
    int _totalM;
    UserInfo *_model;
    NSInteger _fansN;
    UITapGestureRecognizer *_scenarioTap;
}

@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UITapGestureRecognizer *myTap;
@property(nonatomic,strong) UILabel *titleLabel;
@end

static NSString *const IconURL = @"/my/add_head_pic";

@implementation HomePageViewController

-(void)viewWillDisappear:(BOOL)animated{
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
//    item.badgeValue=@" ";
    
    _fiuSceneList = [NSMutableArray array];
    _fiuSceneIdList = [NSMutableArray array];
    _sceneListMarr = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    //
    _chanelV = [ChanelView getChanelView];
    //情景
    _chanelV.scenarioView.userInteractionEnabled = YES;
    _scenarioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap:)];
    _scenarioTap.numberOfTapsRequired = 1;
    _scenarioTap.numberOfTouchesRequired = 1;
    [_chanelV.scenarioView addGestureRecognizer:_scenarioTap];
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

//    //
    [self.view addSubview:self.myCollectionView];
    
    //  添加渐变层
    CAGradientLayer * shadow = [CAGradientLayer layer];
    shadow.startPoint = CGPointMake(0, 2);
    shadow.endPoint = CGPointMake(0, 0);
    shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                      (__bridge id)[UIColor blackColor].CGColor];
    shadow.locations = @[@(0.5f), @(2.5f)];
    shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.view.layer addSublayer:shadow];
}


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    if (self.isMySelf) {
        AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ShieldingViewController *sheetVC = [[ShieldingViewController alloc] init];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        [sheetVC initFBSheetVCWithNameAry:[NSArray arrayWithObjects:@"拉黑用户",@"取消", nil]];
        [((UIButton*)sheetVC.sheetView.subviews[1]) addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [((UIButton*)sheetVC.sheetView.subviews[0]) addTarget:self action:@selector(shieldingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH - 88, 44)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.delegate = self;
    [self.view addSubview:self.titleLabel];
    [self addBarItemLeftBarButton:nil image:@"Fill 1" isTransparent:YES];
    if (self.isMySelf) {
        [self addBarItemRightBarButton:nil image:@"SET" isTransparent:YES];
    }else{
//        [self addBarItemRightBarButton:nil image:@"more_filled" isTransparent:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    //进行网络请求
    [self netGetData];
    
    [self requestDataForOderList];

    
}

-(void)loadMoreDataM{
    if (_m < _totalM) {
        [self requestDataForOderListOperation];
    } else {
        [self.myCollectionView.mj_footer endRefreshing];
    }
}

-(void)loadMoreData{
    if (_n < _totalN) {
        [self requestDataForOderListOperation];
    } else {
        [self.myCollectionView.mj_footer endRefreshing];
    }
}

- (void)requestDataForOderList
{
    if ([self.type isEqualToNumber:@1]) {
        self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
        _n = 0;
        [_fiuSceneList removeAllObjects];
        [_fiuSceneIdList removeAllObjects];
        [self requestDataForOderListOperation];
    }else if([self.type isEqualToNumber:@2]){
        self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreDataM];
        }];
        _m = 0;
        [_sceneListMarr removeAllObjects];
        [_sceneIdMarr removeAllObjects];
        [self requestDataForOderListOperation];
    }
}

//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperation
{
    if ([self.type isEqualToNumber:@1]) {
        self.myCollectionView.mj_footer.hidden = YES;
        //进行情景的网络请求
//        [SVProgressHUD show];
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_scene/" requestDictionary:@{@"page":@(_n+1),@"size":@6,@"sort":@0,@"user_id":self.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSArray * fiuSceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * fiuSceneDic in fiuSceneArr) {
                FiuSceneRow * fiuSceneModel = [[FiuSceneRow alloc] initWithDictionary:fiuSceneDic];
                [_fiuSceneList addObject:fiuSceneModel];
                [_fiuSceneIdList addObject:[NSString stringWithFormat:@"%zi", fiuSceneModel.idField]];
            }
            
            [self.myCollectionView reloadData];
            _n = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            _totalN = [[[result objectForKey:@"data"] objectForKey:@"total_page"] intValue];
            if (_totalN == 0) {
                self.myCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                self.myCollectionView.mj_footer.hidden = YES;
            }
            
            BOOL isLastPage = (_n == _totalN);
            
            if (!isLastPage && _totalN != 0) {
                if (self.myCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                    [self.myCollectionView.mj_footer resetNoMoreData];
                }
            }
            if (_n == _totalN == 1) {
                self.myCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                self.myCollectionView.mj_footer.hidden = YES;
            }
            
            if ([self.myCollectionView.mj_header isRefreshing]) {
                [self.myCollectionView.mj_header endRefreshing];
            }
            if ([self.myCollectionView.mj_footer isRefreshing]) {
                if (isLastPage) {
                    [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                    self.myCollectionView.mj_footer.hidden = YES;
                }
            }
            
            [SVProgressHUD dismiss];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }else if ([self.type isEqualToNumber:@2]){
        //进行场景的网络请求
//        [SVProgressHUD show];
        self.myCollectionView.mj_footer.hidden = YES;
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{@"page":@(_m+1),@"size":@10,@"sort":@0,@"user_id":self.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * sceneDic in sceneArr) {
                HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
                [_sceneListMarr addObject:homeSceneModel];
                [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            }
            [self.myCollectionView reloadData];
            _m = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            _totalM = [[[result objectForKey:@"data"] objectForKey:@"total_page"] intValue];
            BOOL isLastPage = (_m == _totalM);
            if (_totalM == 0) {
                self.myCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                self.myCollectionView.mj_footer.hidden = YES;
            }
            if (!isLastPage && _totalM != 0) {
                if (self.myCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                    [self.myCollectionView.mj_footer resetNoMoreData];
                }
            }
            if (_m == _totalM == 1) {
                self.myCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                self.myCollectionView.mj_footer.hidden = YES;
            }
            
            if ([self.myCollectionView.mj_header isRefreshing]) {
                [self.myCollectionView.mj_header endRefreshing];
            }
            if ([self.myCollectionView.mj_footer isRefreshing]) {
                if (isLastPage) {
                    [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                    self.myCollectionView.mj_footer.hidden = YES;
                }
            }
            [SVProgressHUD dismiss];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }
}



-(void)netGetData{
    FBRequest *request = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        _chanelV.scenarioNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"scene_count"]];
        _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"sight_count"]];
        _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"follow_count"]];
        _fansN = [dataDict[@"fans_count"] integerValue];
        
        if (self.isMySelf) {
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            userInfo.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
            NSArray *areasAry = [NSArray arrayWithArray:dataDict[@"areas"]];
            if (areasAry.count) {
                userInfo.prin = areasAry[0];
                userInfo.city = areasAry[1];
            }
            userInfo.is_expert = [result objectForKey:@"data"][@"identify"][@"is_expert"];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            self.titleLabel.text = entity.nickname;
            //背景图
        }else{
            _model = [UserInfo mj_objectWithKeyValues:dataDict];
            if (![dataDict[@"label"] isKindOfClass:[NSNull class]]) {
                _model.label = dataDict[@"label"];
            }
            if (![[result objectForKey:@"data"][@"head_pic_url"] isKindOfClass:[NSNull class]]) {
                _model.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
            }
            if (![[result objectForKey:@"data"][@"is_love"] isKindOfClass:[NSNull class]]) {
                _model.is_love = [[result objectForKey:@"data"][@"is_love"] integerValue];
            }
            if (![[result objectForKey:@"data"][@"identify"][@"is_expert"] isKindOfClass:[NSNull class]]) {
                _model.is_expert = [result objectForKey:@"data"][@"identify"][@"is_expert"];
            }
            
            self.titleLabel.text = _model.nickname;
        }
        [self.myCollectionView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

-(void)signleTap:(UITapGestureRecognizer*)sender{
    self.type = @1;
    [self requestDataForOderList];
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    self.type = @2;
    [self requestDataForOderList];
}

-(void)signleTap2:(UITapGestureRecognizer*)sender{
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    view.userId = self.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)sender{
    MyFansViewController *view = [[MyFansViewController alloc] init];
    view.userId = self.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 1;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, SCREEN_HEIGHT+54) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[BackgroundCollectionViewCell class] forCellWithReuseIdentifier:@"BackgroundCollectionViewCell"];
        [_myCollectionView registerClass:[OtherCollectionViewCell class] forCellWithReuseIdentifier:@"OtherCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_myCollectionView registerClass:[ScenceListCollectionViewCell class] forCellWithReuseIdentifier:@"ScenceListCollectionViewCell"];
        [_myCollectionView registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"AllSceneCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellScenarioNon"];
    }
    return _myCollectionView;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 2){
        if ([self.type isEqualToNumber:@2]) {
            if (_sceneListMarr.count == 0) {
                return 1;
            }else{
               return _sceneListMarr.count;
            }
            
        }else if([self.type isEqualToNumber:@1]){
            if (_fiuSceneList.count == 0) {
                return 1;
            }else{
                return _fiuSceneList.count; 
            }
            
        }
    }
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([self.type isEqualToNumber:@1]) {
        if (section == 0) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            return UIEdgeInsetsMake(3, 5, 0, 5);
        }
    }else if ([self.type isEqualToNumber:@2]){
        if (section == 0) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }else if(section == 1){
            return UIEdgeInsetsMake(3, 5, 0, 5);
        }else if (section == 2){
            return UIEdgeInsetsMake(3, 0, 10, 0);
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

#pragma mark - 更换头像
-(void)clickUserHeadBtn:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.flag = @(UserHeadTag);
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.flag = @(UserHeadTag);
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (self.isMySelf) {
            BackgroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BackgroundCollectionViewCell" forIndexPath:indexPath];
            [cell.bgImageView addGestureRecognizer:self.myTap];
            [cell setUI];
            [cell.userHeadBtn addTarget:self action:@selector(clickUserHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            OtherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherCollectionViewCell" forIndexPath:indexPath];
            [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.directMessages addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.focusOnBtn.tag = indexPath.row;
            [cell setUIWithModel:_model];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
            _chanelV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
            _chanelV.fansNumLabel.text = [NSString stringWithFormat:@"%zi",_fansN];
            [cell.contentView addSubview:_chanelV];
            return cell;
        }
    }else if (indexPath.section == 2){
        if ([self.type isEqualToNumber:@2]) {
            if (_sceneListMarr.count == 0) {
                //空的
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellScenarioNon" forIndexPath:indexPath];
                cell.userInteractionEnabled = NO;
                ScenarioNonView *view = [ScenarioNonView getScenarioNonView];
                if (self.isMySelf) {
                    view.tipLabel.text = @"你还没有发表过新场景哦，快来Fiu一下嘛";
                }else{
                    view.tipLabel.text = @"你们好像在哪儿见过，来看看他的足迹吧";
                }
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 320/667.0*SCREEN_HEIGHT));
                    make.left.mas_equalTo(cell.mas_left).with.offset(0);
                    make.top.mas_equalTo(cell.mas_top).with.offset(0);
                }];
                return cell;
            }else{
                //不是空的
                ScenceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScenceListCollectionViewCell" forIndexPath:indexPath];
                [cell setUIWithModel:_sceneListMarr[indexPath.row]];
                return cell;
            }
        }else if([self.type isEqualToNumber:@1]){
            if (_fiuSceneList.count == 0) {
                //空的
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellScenarioNon" forIndexPath:indexPath];
                cell.userInteractionEnabled = NO;
                ScenarioNonView *view = [ScenarioNonView getScenarioNonView];
                if (self.isMySelf) {
                    view.tipLabel.text = @"每个情境都有故事，来都来了，讲讲你的故事吧";
                }else{
                    view.tipLabel.text = @"关于TA的经历，你想知道的可能都在这里";
                }
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 320/667.0*SCREEN_HEIGHT));
                    make.left.mas_equalTo(cell.mas_left).with.offset(0);
                    make.top.mas_equalTo(cell.mas_top).with.offset(0);
                }];
                return cell;
            }else{
                //不是空的
                AllSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllSceneCollectionViewCell" forIndexPath:indexPath];
                [cell setAllFiuSceneListData:_fiuSceneList[indexPath.row]];
                return cell;
            }
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



-(void)clickBackBtn:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        [sheetVC setUIWithModel:_model];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _model.is_love = 1;
        _fansN ++;
        [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:1], nil]];
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":self.userId} delegate:self];
        request.flag = @"/follow/ajax_follow";
        [request startRequest];
    }
}



-(UITapGestureRecognizer *)myTap{
    if (!_myTap) {
        _myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMyTap:)];
        _myTap.numberOfTapsRequired = 1;
        _myTap.numberOfTouchesRequired = 1;
    }
    return _myTap;
}



-(void)clickMyTap:(UITapGestureRecognizer*)gesture{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换背景图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.flag = @(BgTag);
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.flag = @(BgTag);
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
    //        NSData * iconData = UIImageJPEGRepresentation(editedImg , 0.5);
    [self uploadIconWithData:iconData andType:picker.flag];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//上传背景图
- (void)uploadIconWithData:(NSData *)iconData andType:(NSNumber*)type
{
    NSString * icon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if ([type isEqualToNumber:@(UserHeadTag)]) {
        NSString * icon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * params = @{@"type": @3, @"tmp": icon64Str};
        FBRequest * request = [FBAPI postWithUrlString:@"/my/upload_token" requestDictionary:params delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSString * message = [result objectForKey:@"message"];
            if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
                
                NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"file_url"];
                UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
                userEntity.mediumAvatarUrl = fileUrl;
                [userEntity updateUserInfo];
                BackgroundCollectionViewCell *cell = (BackgroundCollectionViewCell*)[self.myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
                
                [SVProgressHUD showSuccessWithStatus:message];
            } else {
                [SVProgressHUD showInfoWithStatus:message];
            }
            request = nil;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else if([type isEqualToNumber:@(BgTag)]){
        NSDictionary * params = @{@"type": @3, @"tmp": icon64Str};
        FBRequest * request = [FBAPI postWithUrlString:IconURL requestDictionary:params delegate:self];
        request.flag = IconURL;
        [request startRequest];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}


-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:@"/follow/ajax_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }
    }else if ([request.flag isEqualToString:@"/follow/ajax_cancel_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        }
    }
    
    if ([request.flag isEqualToString:IconURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([result objectForKey:@"success"]) {
            NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"head_pic_url"];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.head_pic_url = fileUrl;
            [userEntity updateUserInfo];
            [self.myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }

}


-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    _model.is_love = 0;
    _fansN --;
    [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:1], nil]];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":self.userId} delegate:self];
    request.flag = @"/follow/ajax_cancel_follow";
    [request startRequest];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)clickMessageBtn:(UIButton*)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    DirectMessagesViewController *vc = [story instantiateViewControllerWithIdentifier:@"DirectMessagesViewController"];
    vc.nickName = _model.nickname;
    vc.userId = _model.userId;
    vc.otherIconImageUrl = _model.mediumAvatarUrl;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)shieldingBtn:(UIButton*)sender{
}

-(void)cancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
        }
    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@2]) {
            if (_sceneListMarr.count == 0) {
                return CGSizeMake((SCREEN_WIDTH-15)/2, 320/667.0*SCREEN_HEIGHT);
            }else{
                return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+5);
            }
        }else if ([self.type isEqualToNumber:@1]){
            return CGSizeMake((SCREEN_WIDTH-15)/2, 320/667.0*SCREEN_HEIGHT);
        }
    }
    
    return CGSizeMake(0, 0);
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //当滑动结束时获取当前滚动坐标的y值
//    CGFloat y = scrollView.contentOffset.y;
//    if (y<0) {
//        //当坐标y大于0时就进行放大
//        //改变图片的y坐标和高度
//        if (_isMySelf) {
//            BackgroundCollectionViewCell *cell = (BackgroundCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            CGRect frame = cell.bgImageView.frame;
//            
//            frame.origin.y = y;
//            frame.size.height = -y+300/667.0*SCREEN_HEIGHT;
//            cell.bgImageView.frame = frame;
//        }else{
//            OtherCollectionViewCell *cell = (OtherCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            CGRect frame = cell.bgImageView.frame;
//            
//            frame.origin.y = y;
//            frame.size.height = -y+300/667.0*SCREEN_HEIGHT;
//            cell.bgImageView.frame = frame;
//        }
//        
//    }
//}

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
