//
//  MyPageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyPageViewController.h"
#import "MyPageBGCollectionViewCell.h"
#import "HomePageViewController.h"
#import "UserInfoEntity.h"
#import "ChanelView.h"
#import "MyPageFocusOnViewController.h"
#import "MyFansViewController.h"
#import "MyPageBtnCollectionViewCell.h"
#import "AllOderViewController.h"
#import "MessageViewController.h"
#import "CounterModel.h"
#import "SubscribeViewController.h"
#import "SystemSettingViewController.h"
#import "PraisedViewController.h"
#import "BonusViewController.h"
#import "DeliveryAddressViewController.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "TipNumberView.h"
#import "BotView.h"
#import "AboutViewController.h"
#import "OptionViewController.h"
#import "FindeFriendViewController.h"
#import "TipNumberView.h"
#import "IntegralViewController.h"
#import "UITabBar+badge.h"
#import "ScenarioNonView.h"


@interface MyPageViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    ChanelView *_chanelV;
    CounterModel *_counterModel;
}
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property(nonatomic,strong) UITapGestureRecognizer *myTap;
@property(nonatomic,strong) TipNumberView *tipNumView1;
@property(nonatomic,strong) TipNumberView *tipNumView2;
@property(nonatomic,strong) BotView *botView;
@property(nonatomic,strong) UIView *naviViewAl;
@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addSubview:self.myCollectionView];
}



-(void)signleTap:(UITapGestureRecognizer*)sender{
    //跳转到我的主页的情景的界面
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = entity.userId;
    myHomeVC.type = @1;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    //跳转到我的主页的情景的界面
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = entity.userId;
    myHomeVC.type = @2;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

-(void)signleTap2:(UITapGestureRecognizer*)sender{
    //跳转到我的主页的情景的界面
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    view.userId = entity.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)sender{
    //跳转到我的主页的情景的界面
    MyFansViewController *view = [[MyFansViewController alloc] init];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    view.userId = entity.userId;
    [self.navigationController pushViewController:view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.delegate = self;
    [self addNavLogoImgisTransparent:YES];
    [self addBarItemLeftBarButton:@"" image:@"Page 1" isTransparent:YES];
    //网络请求
    [self netGetData];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)netGetData{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        _chanelV.scenarioNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"scene_count"]];
        _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"sight_count"]];
        _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"follow_count"]];
        _chanelV.fansNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"fans_count"]];
        
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
        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
        _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
        _counterModel.subscription_count = [result objectForKey:@"data"][@"subscription_count"];
        _counterModel.sight_love_count = [result objectForKey:@"data"][@"sight_love_count"];
        [self.myCollectionView reloadData];
        [SVProgressHUD dismiss];
        
        //判断小圆点是否消失
        if (![_counterModel.message_total_count isEqual:@0]) {
            [self.tabBarController.tabBar showBadgeWithIndex:4];
        }else{
            [self.tabBarController.tabBar hideBadgeWithIndex:4];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, SCREEN_HEIGHT+54) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[MyPageBGCollectionViewCell class] forCellWithReuseIdentifier:@"MyPageBGCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell1"];
        [_myCollectionView registerClass:[MyPageBtnCollectionViewCell class] forCellWithReuseIdentifier:@"MyPageBtnCollectionViewCell"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(3, 5, 0, 5);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyPageBGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPageBGCollectionViewCell" forIndexPath:indexPath];
        [cell.bgImageView addGestureRecognizer:self.myTap];
        [cell setUI];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }else if (indexPath.section == 1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        _chanelV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
        [cell.contentView addSubview:_chanelV];
        return cell;
    }else if (indexPath.section == 2){
        MyPageBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPageBtnCollectionViewCell" forIndexPath:indexPath];
        if ([_counterModel.order_total_count intValue] == 0) {
            //不显示
            [self.tipNumView1 removeFromSuperview];
        }else{
            //显示

            self.tipNumView1.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_total_count];
            CGSize size = [self.tipNumView1.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [cell.btn1 addSubview:self.tipNumView1];
            [self.tipNumView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(cell.btn1.mas_right).with.offset(0);
                make.top.mas_equalTo(cell.btn1.mas_top).with.offset(0/667.0*SCREEN_HEIGHT);
            }];
        }
        
        if ([_counterModel.message_total_count intValue] == 0) {
            //不显示
            [self.tipNumView2 removeFromSuperview];
        }else{
            //显示
            self.tipNumView2.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.message_total_count];
            CGSize size = [self.tipNumView2.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [cell.btn2 addSubview:self.tipNumView2];
            [self.tipNumView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(cell.btn2.mas_right).with.offset(0);
                make.top.mas_equalTo(cell.btn2.mas_top).with.offset(0/667.0*SCREEN_HEIGHT);
            }];
        }
        [cell.btn1 addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(integralBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(giftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(shippingAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(serviceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.section == 3){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell1" forIndexPath:indexPath];
        self.botView.frame = CGRectMake(146/667.0*SCREEN_HEIGHT, 0, SCREEN_WIDTH, 100);
        [self.botView.aboutBtn addTarget:self action:@selector(aboutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.botView.optionBtn addTarget:self action:@selector(optionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.botView];
        return cell;
    }
    return nil;
    
}

-(BotView *)botView{
    if (!_botView) {
        _botView = [BotView getBotView];
    }
    return _botView;
}

-(TipNumberView *)tipNumView1{
    if (!_tipNumView1) {
        _tipNumView1 = [TipNumberView getTipNumView];
    }
    return _tipNumView1;
}

-(TipNumberView *)tipNumView2{
    if (!_tipNumView2) {
        _tipNumView2 = [TipNumberView getTipNumView];
    }
    return _tipNumView2;
}


-(void)aboutBtn:(UIButton*)sender{
    AboutViewController *vc = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)leftBarItemSelected{
    FindeFriendViewController *vc = [[FindeFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)optionBtn:(UIButton*)sender{
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        return CGSizeMake(SCREEN_WIDTH, 388*0.5/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 3) {
        return CGSizeMake(SCREEN_HEIGHT, 200);
    }
    return CGSizeMake(0, 0);
}

//订单按钮
-(void)orderBtn:(UIButton*)sender{
    //跳转到全部订单页
    AllOderViewController *vc = [[AllOderViewController alloc] init];
    vc.counterModel = _counterModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//消息按钮
-(void)messageBtn:(UIButton*)sender{
    MessageViewController *vc = [[MessageViewController alloc] init];
    vc.countModel = _counterModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//订阅按钮
-(void)subscribeBtn:(UIButton*)sender{
    SubscribeViewController *vc = [[SubscribeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//收藏按钮
-(void)collectionBtn:(UIButton*)sender{
    SystemSettingViewController *systemVC = [[SystemSettingViewController alloc] init];
    [self.navigationController pushViewController:systemVC animated:YES];
}

//赞过按钮
-(void)praiseBtn:(UIButton*)sender{
    PraisedViewController *vc = [[PraisedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//积分按钮
-(void)integralBtn:(UIButton*)sender{
    IntegralViewController *vc = [[IntegralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//礼券按钮
-(void)giftBtn:(UIButton*)sender{
    BonusViewController *vc = [[BonusViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//收货地址按钮
-(void)shippingAddressBtn:(UIButton*)sender{
    DeliveryAddressViewController *vc = [[DeliveryAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//服务条款按钮
-(void)serviceBtn:(UIButton*)sender{
}

//账户管理按钮
-(void)accountManagementBtn:(UIButton*)sender{
    
    
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
    //跳转到我的主页的情景的界面
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = entity.userId;
    myHomeVC.type = @2;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
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
