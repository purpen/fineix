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
#import "MyOderInfoViewController.h"
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
#import "ServiceViewController.h"
#import "THNCollectionViewController.h"
#import "THNProjectViewController.h"
#import "THNMessageViewController.h"
#import "THNRefundListViewController.h"
#import "THNAllianceViewController.h"
#import "THNDivideCollectionViewCell.h"
#import "THNOrderCollectionViewCell.h"
#import "PictureToolViewController.h"
#import "AboutViewController.h"

@interface MyPageViewController ()<THNNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    ChanelView *_chanelV;
    CounterModel *_counterModel;
    UserInfo *_userInfo;
}
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property(nonatomic,strong) UITapGestureRecognizer *myTap;
@property(nonatomic,strong) TipNumberView *tipNumView1;
@property(nonatomic,strong) TipNumberView *tipNumView2;
@property(nonatomic,strong) TipNumberView *tipNumView3;
@property(nonatomic,strong) BotView *botView;
@property(nonatomic,strong) UIView *naviViewAl;
/**  */
@property (nonatomic, strong) CAGradientLayer *shadowLayer;
@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    _chanelV = [ChanelView getChanelView];
    
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
    view.cleanRemind = @"0";
    [self.navigationController pushViewController:view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.delegate = self;
    [self thn_addNavLogoImage];
//    [self thn_addBarItemLeftBarButton:nil image:@"my_riLi"];
    [self thn_addBarItemRightBarButton:nil image:@"my_set"];
    [self.view insertSubview:self.navView aboveSubview:self.myCollectionView];
    self.navView.backgroundColor = [UIColor clearColor];
    //  添加渐变层
    [self.navView.layer insertSublayer:self.shadowLayer below:self.logoImg.layer];
    
    //网络请求
    [self netGetData];
    self.tabBarController.tabBar.hidden = NO;
}

-(CAGradientLayer *)shadowLayer{
    if (!_shadowLayer) {
        _shadowLayer = [CAGradientLayer layer];
        _shadowLayer.startPoint = CGPointMake(0, 0);
        _shadowLayer.opacity = 0.3;
        _shadowLayer.endPoint = CGPointMake(0, 1);
        _shadowLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
                          (__bridge id)[UIColor clearColor].CGColor];
        _shadowLayer.locations = @[@0];
        _shadowLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return _shadowLayer;
}

-(void)thn_rightBarItemSelected{
    SystemSettingViewController *vc = [[SystemSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        
        _userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
        NSArray *ary = [result objectForKey:@"data"][@"interest_scene_cate"];
        NSMutableString *str = [NSMutableString string];
        for (int i = 0; i < ary.count; i ++) {
            [str appendString:[NSString stringWithFormat:@"%@",ary[i]]];
            if (i == ary.count - 1) {
                break;
            }
            [str appendString:@","];
        }
        _userInfo.interest_scene_cate = str;
        
        _userInfo.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
        NSArray *areasAry = [NSArray arrayWithArray:dataDict[@"areas"]];
        if (areasAry.count) {
            _userInfo.prin = areasAry[0];
            _userInfo.city = areasAry[1];
        }
        _userInfo.is_expert = [result objectForKey:@"data"][@"identify"][@"is_expert"];
        _userInfo.allianceId = [result objectForKey:@"data"][@"identify"][@"alliance_id"];
        [_userInfo saveOrUpdate];
        [_userInfo updateUserInfoEntity];
        
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
        _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[MyPageBGCollectionViewCell class] forCellWithReuseIdentifier:@"MyPageBGCollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell1"];
        [_myCollectionView registerClass:[MyPageBtnCollectionViewCell class] forCellWithReuseIdentifier:@"MyPageBtnCollectionViewCell"];
        [_myCollectionView registerClass:[THNDivideCollectionViewCell class] forCellWithReuseIdentifier:THNDIVIDECollectionViewCell];
        [_myCollectionView registerClass:[THNOrderCollectionViewCell class] forCellWithReuseIdentifier:THNORDErCollectionViewCell];
    }
    return _myCollectionView;
}

-(void)thn_leftBarItemSelected{
    FindeFriendViewController *vc = [[FindeFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (section == 2) {
        return UIEdgeInsetsMake(8, 0, 10, 0);
    }else if (section == 3) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
    else{
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyPageBGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPageBGCollectionViewCell" forIndexPath:indexPath];
        [cell.bgImageView addGestureRecognizer:self.myTap];
        [cell setUI];
        return cell;
    }else if (indexPath.section == 1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        _chanelV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
        [cell.contentView addSubview:_chanelV];
        return cell;
    }else if (indexPath.section == 2){
        THNDivideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIVIDECollectionViewCell forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 3){
        THNOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNORDErCollectionViewCell forIndexPath:indexPath];
        [cell.btn1 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.section == 4){
        MyPageBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPageBtnCollectionViewCell" forIndexPath:indexPath];
        cell.nav = self.navigationController;
        if ([_counterModel.message_total_count intValue] == 0) {
            //不显示
            [self.tipNumView1 removeFromSuperview];
        }else{
            //显示
            
            self.tipNumView1.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.message_total_count];
            CGSize size = [self.tipNumView1.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [cell.btn1 addSubview:self.tipNumView1];
            [self.tipNumView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+11, 17));
                    make.right.mas_equalTo(cell.btn1.mas_right).with.offset(5);
                }else{
                    make.size.mas_equalTo(CGSizeMake(17, 17));
                    make.right.mas_equalTo(cell.btn1.mas_right).with.offset(2);
                }
                make.top.mas_equalTo(cell.btn1.mas_top).with.offset(0/667.0*SCREEN_HEIGHT);
            }];
        }
        
        if ([_counterModel.fiu_bonus_count intValue] == 0) {
            //不显示
            [self.tipNumView3 removeFromSuperview];
        }else{
            //显示
            self.tipNumView3.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.fiu_bonus_count];
            CGSize size = [self.tipNumView3.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [cell.btn7 addSubview:self.tipNumView3];
            [self.tipNumView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+11, 17));
                    make.right.mas_equalTo(cell.btn7.mas_right).with.offset(5);
                }else{
                    make.size.mas_equalTo(CGSizeMake(17, 17));
                    make.right.mas_equalTo(cell.btn7.mas_right).with.offset(2);
                }
                
                make.top.mas_equalTo(cell.btn7.mas_top).with.offset(0/667.0*SCREEN_HEIGHT);
            }];
        }
        
//        if ( _userInfo.allianceId.length == 0) {
//            cell.allianceLabel.hidden = YES;
//            cell.allianceBtn.hidden = YES;
//        } else {
//            cell.allianceLabel.hidden = NO;
//            cell.allianceBtn.hidden = NO;
//        }
        
        [cell.btn1 addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(collectionBtnbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(integralBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(giftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(shippingAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (indexPath.section == 5) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell1" forIndexPath:indexPath];
        self.botView.frame = CGRectMake(146/667.0*SCREEN_HEIGHT, 0, SCREEN_WIDTH, 88);
        [self.botView.aboutBtn addTarget:self action:@selector(aboutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.botView.optionBtn addTarget:self action:@selector(optionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.botView.qiyeQingdingzhiBtn addTarget:self action:@selector(qiye) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.botView];
        return cell;
    }
    return nil;
    
}

-(void)qiye{
    AboutViewController *vc = [[AboutViewController alloc] init];
    vc.text = @"企业轻定制";
    vc.url = @"https://m.taihuoniao.com/storage/custom?from=app";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark “创建情景”的按钮事件
- (void)createBtnClick {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

#pragma mark - 退款售后
-(void)refundAction{
    THNRefundListViewController *refundListVC = [[THNRefundListViewController alloc] init];
    [self.navigationController pushViewController:refundListVC animated:YES];
}

/**
 *  收藏按钮
 *
 *  @return 
 */
#pragma mark - 收藏按钮
-(void)collectionBtnbtn:(UIButton*)sender{
    THNCollectionViewController *vc = [[THNCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

-(TipNumberView *)tipNumView3{
    if (!_tipNumView3) {
        _tipNumView3 = [TipNumberView getTipNumView];
    }
    return _tipNumView3;
}

-(void)aboutBtn:(UIButton*)sender{
    AboutViewController *vc = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)optionBtn:(UIButton*)sender{
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH - 20);
        }
    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 120.5/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 4) {
        return CGSizeMake(SCREEN_WIDTH, (190 + 140)/667.0*SCREEN_HEIGHT);
    }
    if (indexPath.section == 5) {
        return CGSizeMake(SCREEN_HEIGHT, 200);
    }
    return CGSizeMake(0, 0);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        THNAllianceViewController *allianceVC = [[THNAllianceViewController alloc] init];
        [self.navigationController pushViewController:allianceVC animated:YES];
    } else if (indexPath.section == 3) {
        MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
        vc.type = @0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 订单的不同action
-(void)oderActionBtn:(UIButton*)sender{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @(sender.tag);
    [self.navigationController pushViewController:vc animated:YES];
}

//消息按钮
-(void)messageBtn:(UIButton*)sender{
//    MessageViewController *vc = [[MessageViewController alloc] init];
//    vc.countModel = _counterModel;
//    [self.navigationController pushViewController:vc animated:YES];

    //  Fynn
    THNMessageViewController *messageVC = [[THNMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
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
    ServiceViewController *vc = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

@end
