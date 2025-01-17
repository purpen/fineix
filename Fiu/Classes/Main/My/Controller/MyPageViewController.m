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
#import "THNUserData.h"
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
#import "THNUserData.h"
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
#import "THNQiYeQingDingZhiViewController.h"
#import "THNZhaoMuViewController.h"
#import "THNDiPanGuanLiCollectionViewCell.h"
#import "THNDomainSetViewController.h"
#import "THNWelfareViewController.h"

@interface MyPageViewController ()<THNNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    ChanelView *_chanelV;
    CounterModel *_counterModel;
    THNUserData *_userInfo;
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
/**  */
@property(nonatomic,copy) NSString *moneyStr;

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
    
    self.tabBarController.tabBar.hidden = NO;
}

-(void)signleTap1:(UITapGestureRecognizer*)sender{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = userdata.userId;
    myHomeVC.type = @2;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

-(void)signleTap2:(UITapGestureRecognizer*)sender{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    view.userId = userdata.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)sender{
    MyFansViewController *view = [[MyFansViewController alloc] init];
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    view.userId = userdata.userId;
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
    [self thn_addBarItemRightBarButton:nil image:@"my_set"];
    [self.view insertSubview:self.navView aboveSubview:self.myCollectionView];
    self.navView.backgroundColor = [UIColor clearColor];
    //  添加渐变层
    [self.navView.layer insertSublayer:self.shadowLayer below:self.logoImg.layer];
    //网络请求
    [self netGetData];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/alliance/view" requestDictionary:@{} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        self.moneyStr = dict[@"wait_cash_amount"];
        [self.myCollectionView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
    }];
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
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":userdata.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"sight_count"]];
        _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"follow_count"]];
        _chanelV.fansNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"fans_count"]];
        
        _userInfo = [THNUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
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
        _userInfo.storageId = [NSString stringWithFormat:@"%zi", [[result objectForKey:@"data"][@"identify"][@"storage_id"] integerValue]];
        _userInfo.is_storage_manage = [[result objectForKey:@"data"][@"identify"][@"is_scene_subscribe"] integerValue];
        _userInfo.isLogin = YES;
        [_userInfo saveOrUpdate];

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
        
        if (Is_iPhoneX) {
            _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54-17, SCREEN_WIDTH, SCREEN_HEIGHT+54) collectionViewLayout:layout];
        } else {
            _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, SCREEN_HEIGHT+54) collectionViewLayout:layout];
        }
        
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
        [_myCollectionView registerClass:[THNDiPanGuanLiCollectionViewCell class] forCellWithReuseIdentifier:THNDIPanGuanLiCollectionViewCell];
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
        if ((long)[_userInfo.storageId integerValue] == 0) {
            return UIEdgeInsetsMake(8, 0, 10, 0);
        }
        return UIEdgeInsetsMake(8, 0, 0, 0);
    }else if (section == 4) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    } else if (section == 3) {
        if ((long)[_userInfo.storageId integerValue] == 0) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
    else{
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyPageBGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPageBGCollectionViewCell" forIndexPath:indexPath];
        [cell.bgImageView addGestureRecognizer:self.myTap];
        [cell setUI];
        return cell;
    }else if (indexPath.section == 1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:_chanelV];
        [_chanelV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(cell.contentView).mas_offset(0);
        }];
        return cell;
    }else if (indexPath.section == 2){
        THNDivideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIVIDECollectionViewCell forIndexPath:indexPath];
        cell.moneyStr = self.moneyStr;
        return cell;
    } else if (indexPath.section == 3) {
        if ((long)[_userInfo.storageId integerValue] == 0) {
            THNDiPanGuanLiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIPanGuanLiCollectionViewCell forIndexPath:indexPath];
            cell.textLabel.hidden = YES;
            cell.imageV.hidden = YES;
            cell.bgImageV.hidden = YES;
            return cell;
        }
        THNDiPanGuanLiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIPanGuanLiCollectionViewCell forIndexPath:indexPath];
        cell.textLabel.hidden = NO;
        cell.imageV.hidden = NO;
        cell.bgImageV.hidden = NO;
        return cell;
    }
    else if(indexPath.section == 4){
        THNOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNORDErCollectionViewCell forIndexPath:indexPath];
        [cell.btn1 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(oderActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weifukuanTap)]];
        [cell.label2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daifahuoTap)]];
        [cell.label3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daishouhuoTap)]];
        [cell.label4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daipingjiaTap)]];
        [cell.label5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuikuanTap)]];
        [cell.allOderBtn addTarget:self action:@selector(allOderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.section == 5){
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
                    make.right.mas_equalTo(cell.btn1.mas_right).with.offset(-12);
                }else{
                    make.size.mas_equalTo(CGSizeMake(17, 17));
                    make.right.mas_equalTo(cell.btn1.mas_right).with.offset(-15);
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
                    make.right.mas_equalTo(cell.btn7.mas_right).with.offset(-12);
                }else{
                    make.size.mas_equalTo(CGSizeMake(17, 17));
                    make.right.mas_equalTo(cell.btn7.mas_right).with.offset(-15);
                }
                
                make.top.mas_equalTo(cell.btn7.mas_top).with.offset(0/667.0*SCREEN_HEIGHT);
            }];
        }
        
        [cell.btn1 addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(collectionBtnbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(integralBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(giftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(shippingAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (indexPath.section == 6) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell1" forIndexPath:indexPath];
        if (Is_iPhoneX) {
            self.botView.frame = CGRectMake(223, 0, SCREEN_WIDTH, 44*3);
        } else {
            self.botView.frame = CGRectMake(146/667.0*self.screenHeight, 0, SCREEN_WIDTH, 44*3);
        }
        [self.botView.welfareBtn addTarget:self action:@selector(welfareClick) forControlEvents:UIControlEventTouchUpInside];
        [self.botView.optionBtn addTarget:self action:@selector(optionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.botView.qiyeQingdingzhiBtn addTarget:self action:@selector(qiye) forControlEvents:UIControlEventTouchUpInside];
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            self.botView.frame = CGRectMake(80, 0, SCREEN_WIDTH, 44*3);
        }
        [cell.contentView addSubview:self.botView];
        return cell;
    }
    return nil;
    
}

-(void)qiye{
    THNQiYeQingDingZhiViewController *vc = [[THNQiYeQingDingZhiViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 新人福利
-(void)welfareClick{
    THNWelfareViewController *vc = [[THNWelfareViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
  
#pragma mark 全部订单
-(void)allOderBtnClick{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @0;
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
    
-(void)tuikuanTap{
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

-(void)optionBtn:(UIButton*)sender{
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (SCREEN_HEIGHT == 812) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH - 20);
            }
        }
        if (indexPath.section == 1) {
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
                return CGSizeMake(SCREEN_WIDTH, 80);
            }
            return CGSizeMake(SCREEN_WIDTH, 60);
        }
        if (indexPath.section == 2) {
            return CGSizeMake(SCREEN_WIDTH, 44);
        }
        if (indexPath.section == 3) {
            if ((long)[_userInfo.storageId integerValue] == 0) {
                return CGSizeMake(SCREEN_WIDTH, 0.00001);
            }
            return CGSizeMake(SCREEN_WIDTH, 44);
        }
        if (indexPath.section == 4) {
            return CGSizeMake(SCREEN_WIDTH, 120.5);
        }
        if (indexPath.section == 5) {
            return CGSizeMake(SCREEN_WIDTH, (190 + 140));
        }
        if (indexPath.section == 6) {
            return CGSizeMake(SCREEN_HEIGHT, 200);
        }
        return CGSizeMake(0, 0);
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH - 20);
            }
        }
        if (indexPath.section == 1) {
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
                return CGSizeMake(SCREEN_WIDTH, 80/667.0*SCREEN_HEIGHT);
            }
            return CGSizeMake(SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
        }
        if (indexPath.section == 2) {
            return CGSizeMake(SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT);
        }
        if (indexPath.section == 3) {
            if ((long)[_userInfo.storageId integerValue] == 0) {
                return CGSizeMake(SCREEN_WIDTH, 0.00001);
            }
            return CGSizeMake(SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT);
        }
        if (indexPath.section == 4) {
            return CGSizeMake(SCREEN_WIDTH, 120.5/667.0*SCREEN_HEIGHT);
        }
        if (indexPath.section == 5) {
            return CGSizeMake(SCREEN_WIDTH, (190 + 140)/667.0*SCREEN_HEIGHT);
        }
        if (indexPath.section == 6) {
            return CGSizeMake(SCREEN_HEIGHT, 200);
        }
        return CGSizeMake(0, 0);
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        THNAllianceViewController *allianceVC = [[THNAllianceViewController alloc] init];
        [self.navigationController pushViewController:allianceVC animated:YES];
    } else if (indexPath.section == 3) {
        //地盘管理
        if ((long)[_userInfo.storageId integerValue] > 0) {
            THNDomainSetViewController *domainSetVC = [[THNDomainSetViewController alloc] init];
            domainSetVC.domainId = _userInfo.storageId;
            [self.navigationController pushViewController:domainSetVC animated:YES];
        }
    }
}
    
-(void)daishouhuoTap{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @(3);
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)daipingjiaTap{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @(4);
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)weifukuanTap{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @(1);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)daifahuoTap{
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @(2);
    [self.navigationController pushViewController:vc animated:YES];
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
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = userdata.userId;
    myHomeVC.type = @2;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

@end
