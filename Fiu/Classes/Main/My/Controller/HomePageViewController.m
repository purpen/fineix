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
#import "ShieldingViewController.h"
#import "Fiu.h"
#import "AccountManagementViewController.h"
#import "THNUserData.h"
#import "DirectMessagesViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "HomeSceneListRow.h"
#import "MyFansActionSheetViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Helper.h"
#import "HomePageViewController.h"
#import "UIImagePickerController+Flag.h"
#import "ScenarioNonView.h"
#import "THNHomeSenceCollectionViewCell.h"
#import "UIView+FSExtension.h"
#import "THNSceneDetalViewController.h"
#import "THNMacro.h"

#define UserHeadTag 1
#define BgTag 2

@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBRequestDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FBNavigationBarItemsDelegate,MyPageFocusOnViewControllerDelegate,MyFansViewControllerDelegate,THNSceneDetalViewControllerDelegate>
{
    ChanelView *_chanelV;
    NSMutableArray *_fiuSceneList;
    NSMutableArray *_fiuSceneIdList;
    NSMutableArray *_sceneListMarr;
    NSMutableArray *_sceneIdMarr;
    THNUserData *_model;
    NSInteger _fansN;
    UITapGestureRecognizer *_scenarioTap;
}

@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UITapGestureRecognizer *myTap;
@property(nonatomic,strong) UILabel *titleLabel;
/**  */
@property (nonatomic, strong) ScenarioNonView *defaultView;
/**  */
@property (nonatomic, strong) NSMutableArray *commentsMarr;
/**  */
@property (nonatomic, strong) NSMutableArray *userIdMarr;
/**  */
@property (nonatomic, assign) NSInteger modelAryCount;
/**  */
@property (nonatomic, strong) CAGradientLayer * shadow;
/**  */
@property (nonatomic, assign) int flagCount;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSDictionary *params;

@end

static NSString *const IconURL = @"/my/add_head_pic";
static NSString *sceneCellId = @"THNHomeSenceCollectionViewCell";

@implementation HomePageViewController

-(void)viewWillDisappear:(BOOL)animated{
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(NSMutableArray *)userIdMarr{
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

-(NSMutableArray *)commentsMarr{
    if (!_commentsMarr) {
        _commentsMarr = [NSMutableArray array];
    }
    return _commentsMarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fiuSceneList = [NSMutableArray array];
    _fiuSceneIdList = [NSMutableArray array];
    _sceneListMarr = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    _chanelV = [ChanelView getChanelView];
    //情境
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
    [self.view.layer addSublayer:self.shadow];
    
    [self setUpRefresh];
    [self netGetData];
}

-(CAGradientLayer *)shadow{
    if (!_shadow) {
        _shadow = [CAGradientLayer layer];
        _shadow.startPoint = CGPointMake(0, 2);
        _shadow.endPoint = CGPointMake(0, 0);
        _shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        _shadow.locations = @[@(0.5f), @(2.5f)];
        if (Is_iPhoneX) {
            _shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        } else {
            _shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        }
    }
    return _shadow;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _tipLabel.font = [UIFont systemFontOfSize:13];
        }
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
        if (Is_iPhoneX) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 44, SCREEN_WIDTH - 88, 44)];
        } else {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH - 88, 44)];
        }
        _titleLabel.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        } else {
            _titleLabel.font = [UIFont systemFontOfSize:17];
        }
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
        //[self addBarItemRightBarButton:nil image:@"more_filled" isTransparent:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)setUpRefresh{
    [self loadNew];
    // 自动改变透明度
    self.myCollectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.myCollectionView.mj_header beginRefreshing];
    
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadMore{
    [self.myCollectionView.mj_header endRefreshing];
    NSDictionary *params = @{
                             @"page" : @(++self.current_page),
                             @"size" : @8,
                             @"user_id":self.userId,
                             @"sort" : @0,
                             @"show_all" : @1
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"data"][@"current_page"] integerValue];
        self.total_rows = [result[@"data"][@"total_rows"] integerValue];
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        NSMutableArray *indexAry = [NSMutableArray array];
        for (int i=0; i<sceneArr.count;i++) {
            NSDictionary * sceneDic = sceneArr[i];
            NSIndexPath *index = [NSIndexPath indexPathForRow:_sceneListMarr.count+i inSection:2];
            [indexAry addObject:index];
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [_sceneListMarr addObject:homeSceneModel];
            [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        if (self.params != params) {
            return;
        }
        [self.commentsMarr addObjectsFromArray:[sceneArr valueForKey:@"comments"]];
        [UIView performWithoutAnimation:^{
            [self.myCollectionView reloadData]; 
        }];
        [self.myCollectionView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.myCollectionView.mj_footer endRefreshing];
    }];
}


-(void)loadNew{
    [_sceneListMarr removeAllObjects];
    [_sceneIdMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    [self.commentsMarr removeAllObjects];
    [self.myCollectionView.mj_footer endRefreshing];
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"size" : @8,
                             @"user_id":self.userId,
                             @"sort" : @0,
                             @"show_all" : @1
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"data"][@"current_page"] integerValue];
        self.total_rows = [result[@"data"][@"total_rows"] integerValue];
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [_sceneListMarr addObject:homeSceneModel];
            [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        if (self.params != params) {
            return;
        }
        [self.commentsMarr addObjectsFromArray:[sceneArr valueForKey:@"comments"]];
        [self.myCollectionView reloadData];
        [self.myCollectionView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.myCollectionView.mj_header endRefreshing];
    }];
    
}


-(void)checkFooterState{
    self.myCollectionView.mj_footer.hidden = _sceneListMarr.count == 0;
    if (_sceneListMarr.count == self.total_rows) {
        self.myCollectionView.mj_footer.hidden = YES;
    }else{
        [self.myCollectionView.mj_footer endRefreshing];
    }
}

-(void)netGetData{
    FBRequest *request = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = result[@"data"];
        _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"sight_count"]];
        _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"follow_count"]];
        _fansN = [dataDict[@"fans_count"] integerValue];
        
        if (self.isMySelf) {
            THNUserData *userInfo = [THNUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            userInfo.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
            NSArray *areasAry = [NSArray arrayWithArray:dataDict[@"areas"]];
            if (areasAry.count) {
                userInfo.prin = areasAry[0];
                userInfo.city = areasAry[1];
            }
            userInfo.is_expert = [result objectForKey:@"data"][@"identify"][@"is_expert"];
            userInfo.isLogin = YES;
            [userInfo saveOrUpdate];
            self.titleLabel.text = userInfo.nickname;
            //背景图
        }else{
            _model = [THNUserData mj_objectWithKeyValues:dataDict];
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


-(void)signleTap1:(UITapGestureRecognizer*)sender{
    self.type = @2;
    self.current_page = 1;
    [self loadNew];
    _chanelV.fieldView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _chanelV.fieldView.userInteractionEnabled = YES;
    });
}

-(void)signleTap2:(UITapGestureRecognizer*)sender{
    MyPageFocusOnViewController *vc = [[MyPageFocusOnViewController alloc] init];
    vc.userId = self.userId;
    vc.focusQuantityDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)updateTheFocusQuantity:(NSInteger)num{
    _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%ld",num];
}

-(void)signleTap3:(UITapGestureRecognizer*)sender{
    MyFansViewController *vc = [[MyFansViewController alloc] init];
    vc.userId = self.userId;
    vc.cleanRemind = @"0";
    vc.fansQuantityDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)updateTheFansQuantity:(NSInteger)num{
    _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%ld",num];
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 1;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, SCREEN_HEIGHT+54) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[BackgroundCollectionViewCell class] forCellWithReuseIdentifier:@"BackgroundCollectionViewCell"];
        [_myCollectionView registerClass:[OtherCollectionViewCell class] forCellWithReuseIdentifier:@"OtherCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellScenarioNon"];
        [_myCollectionView registerNib:[UINib nibWithNibName:sceneCellId bundle:nil] forCellWithReuseIdentifier:sceneCellId];
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
            return UIEdgeInsetsMake(0, 5, 0, 5);
        }else if (section == 2){
            return UIEdgeInsetsMake(15, 15, 1, 15);
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


-(ScenarioNonView *)defaultView{
    if (!_defaultView) {
        _defaultView = [ScenarioNonView getScenarioNonView];
        if (self.isMySelf) {
            _defaultView.tipLabel.text = @"你还没有发表过新情景哦";
            _defaultView.creatBtn.hidden = NO;
        }else{
            _defaultView.tipLabel.text = @"你们好像在哪儿见过，来看看他的足迹吧";
            _defaultView.creatBtn.hidden = YES;
        }
    }
    return _defaultView;
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
            _chanelV.fansNumLabel.text = [NSString stringWithFormat:@"%zi",_fansN];
            [cell.contentView addSubview:_chanelV];
            [_chanelV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(cell.contentView).mas_offset(0);
            }];
            return cell;
        }
    }else if (indexPath.section == 2){
        if ([self.type isEqualToNumber:@2]) {
            if (_sceneListMarr.count == 0) {
                //空的
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellScenarioNon" forIndexPath:indexPath];
                cell.userInteractionEnabled = YES;
                [cell addSubview:self.defaultView];
                [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 320/667.0*self.screenHeight));
                    make.left.mas_equalTo(cell.mas_left).with.offset(0);
                    make.top.mas_equalTo(cell.mas_top).with.offset(0);
                }];
                return cell;
            }else{
                //不是空的
                THNHomeSenceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCellId forIndexPath:indexPath];
                cell.model = _sceneListMarr[indexPath.row];
                cell.width = (SCREEN_WIDTH - 15 * 3) * 0.5;
                cell.height = 0.25 * self.screenHeight;
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
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 320/667.0*self.screenHeight));
                    make.left.mas_equalTo(cell.mas_left).with.offset(0);
                    make.top.mas_equalTo(cell.mas_top).with.offset(0);
                }];
                return cell;
            }
        }
    }
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@1]) {
            
        }else if([self.type isEqualToNumber:@2]){
            if (_sceneListMarr.count) {
                FBAPI *api = [[FBAPI alloc] init];
                NSString *uuid = [api uuid];
                FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                                       @"id" : _sceneIdMarr[indexPath.row],
                                                                                                       @"uuid" : uuid,
                                                                                                       @"app_type" : @2
                                                                                                       } delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    if ([result[@"success"] isEqualToNumber:@1]) {
                        THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
                        vc.sceneDetalId = _sceneIdMarr[indexPath.row];
                        vc.referenceNo = indexPath.row;
                        vc.sceneDelegate = self;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } failure:nil];
            }
        }
    }
}
    
-(void)updatScenceNum:(NSInteger)num andDeleteReferenceNo:(NSInteger)reference{
    _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%ld",num];
    [_sceneListMarr removeObjectAtIndex:reference];
    [_sceneIdMarr removeObjectAtIndex:reference];
    [self.commentsMarr removeObjectAtIndex:reference];
    [self.userIdMarr removeObjectAtIndex:reference];
    [self.myCollectionView reloadData];
//    [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:reference inSection:2], nil]];
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
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换个人主页封面" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
                THNUserData *userdata = [[THNUserData findAll] lastObject];
                userdata.mediumAvatarUrl = fileUrl;
                userdata.isLogin = YES;
                [userdata saveOrUpdate];
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
        if (![[result objectForKey:@"success"] isEqualToNumber:@0]) {
            _model.is_love = 1;
            _fansN ++;
            [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:1], nil]];
        }else{
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
        }
    }else if ([request.flag isEqualToString:@"/follow/ajax_cancel_follow"]){
        if ([result objectForKey:@"success"]) {
        }else{

        }
    }
    
    if ([request.flag isEqualToString:IconURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([result objectForKey:@"success"]) {
            NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"head_pic_url"];
            THNUserData *userdata = [[THNUserData findAll] lastObject];
            userdata.head_pic_url = fileUrl;
            [userdata saveOrUpdate];
            BackgroundCollectionViewCell *cell = (BackgroundCollectionViewCell*)[self.myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:userdata.head_pic_url] placeholderImage:nil];
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion < 100) {
        self.shadow.startPoint = CGPointMake(0, 2);
        self.shadow.endPoint = CGPointMake(0, 0);
        self.shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                           (__bridge id)[UIColor blackColor].CGColor];
    }
    else if (currentPostion > 100)
    {
        self.shadow.startPoint = CGPointMake(0.5, 0);
        self.shadow.endPoint = CGPointMake(0.5, 1);
        self.shadow.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.8].CGColor,
                           (__bridge id)[UIColor clearColor].CGColor];
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
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH - 20);
        }
    }
    if (indexPath.section == 1) {
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            return CGSizeMake(SCREEN_WIDTH, 80/667.0*self.screenHeight);
        }
        return CGSizeMake(SCREEN_WIDTH, 60/667.0*self.screenHeight);
    }
    if (indexPath.section == 2) {
        if ([self.type isEqualToNumber:@2]) {
            if (_sceneListMarr.count == 0) {
                return CGSizeMake(SCREEN_WIDTH, 320/667.0*self.screenHeight);
            }else{
                return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * self.screenHeight);
            }
        }else if ([self.type isEqualToNumber:@1]){
            return CGSizeMake((SCREEN_WIDTH-15)/2, 320/667.0*self.screenHeight);
        }
    }
    
    return CGSizeMake(0, 0);
}


@end
