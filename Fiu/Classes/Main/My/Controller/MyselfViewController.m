//
//  MyselfViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyselfViewController.h"
#import "Fiu.h"
#import "FBLoginRegisterViewController.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NaviView.h"
#import "BackImagView.h"
#import "ChanelView.h"
#import "ChanelViewTwo.h"
#import "BottomView.h"
#import "AppBtnView.h"
#import "AllOderViewController.h"
#import "HomePageViewController.h"
#import "MyPageFocusOnViewController.h"
#import "MyFansViewController.h"
#import "SubscribeViewController.h"
#import "PraisedViewController.h"
#import "FindeFriendViewController.h"
#import "TalentCertificationViewController.h"
#import "SystemSettingViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "UserInfo.h"
#import "MessageViewController.h"
#import "AboutViewController.h"
#import "OptionViewController.h"
#import <SVProgressHUD.h>
#import "CounterModel.h"
#import "TipNumberView.h"

@interface MyselfViewController ()<UIScrollViewDelegate,FBNavigationBarItemsDelegate,FBRequestDelegate>


{
    UIScrollView *_homeScrollView;
    BackImagView *_imgV;//背景图片
    ChanelView *_chanelV;
    CounterModel *_counterModel;
    ChanelViewTwo *_chanelTwoV;
}



@end

static NSString *const follows = @"/follow";

@implementation MyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//    NSLog(@"userid  %@",entity.userId);
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    // Do any additional setup after loading the view.
    //[self setImagesRoundedCorners:27.0 :_headPortraitImageV];
    
    //在下面放置一个scrollview
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _homeScrollView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:247.0/255];
    _homeScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_homeScrollView];
    
    //让背景图片下拉变大
    _homeScrollView.delegate = self;
    //背景图片
    _imgV = [BackImagView getBackImageView];
    _imgV.headImageView.layer.masksToBounds = YES;
    _imgV.headImageView.layer.cornerRadius = 33;
    _imgV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300/667.0*SCREEN_HEIGHT);
    _imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_imgV addGestureRecognizer:singleTap];
    //我要认证按钮
    [_imgV.wantCertificationBtn addTarget:self action:@selector(clickCertificationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_homeScrollView addSubview:_imgV];

    
    
    //频道选项
    _chanelV = [ChanelView getChanelView];
    _chanelV.frame = CGRectMake(0, (300+5)/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
    

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
    [_homeScrollView addSubview:_chanelV];
    //订单等一些东西
    _chanelTwoV = [ChanelViewTwo getChanelViewTwo];
    _chanelTwoV.frame = CGRectMake(0, (300+5+60+5)/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 194/667.0*SCREEN_HEIGHT);
    [_homeScrollView addSubview:_chanelTwoV];
    //为订单等一些按钮添加方法
    //订单按钮
    [_chanelTwoV.orderBtn addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    [_chanelTwoV.messageBtn addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
    //订阅按钮
    [_chanelTwoV.subscribeBtn addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    //收藏按钮
    [_chanelTwoV.collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    //赞过按钮
    [_chanelTwoV.praiseBtn addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    //积分按钮
    [_chanelTwoV.integralBtn addTarget:self action:@selector(integralBtn:) forControlEvents:UIControlEventTouchUpInside];
    //礼券按钮
    [_chanelTwoV.giftBtn addTarget:self action:@selector(giftBtn:) forControlEvents:UIControlEventTouchUpInside];
    //收货地址按钮
    [_chanelTwoV.shippingAddressBtn addTarget:self action:@selector(shippingAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
    //服务条款按钮
    [_chanelTwoV.serviceBtn addTarget:self action:@selector(serviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    //账户管理按钮
    [_chanelTwoV.accountManagementBtn addTarget:self action:@selector(accountManagementBtn:) forControlEvents:UIControlEventTouchUpInside];
    //关于我们等
    BottomView *bottomV = [BottomView getBottomView];
    bottomV.frame = CGRectMake(0, (300+5+60+5+194+2)/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 90/667.0*SCREEN_HEIGHT);
    [bottomV.aboutUsBtn addTarget:self action:@selector(clickAboutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV.opinionBtn addTarget:self action:@selector(clickOpinionBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[bottomV.partnerBtn addTarget:self action:@selector(clickPartnerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_homeScrollView addSubview:bottomV];
    //scrollView滑动范围
    _homeScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(bottomV.frame)+91);

    
}



-(void)netGetData{
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":entity.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"&&&&&&&&result %@",result);
        NSDictionary *dataDict = result[@"data"];
        _chanelV.scenarioNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"scene_count"]];
        _chanelV.fieldNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"sight_count"]];
        _chanelV.focusNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"follow_count"]];
        _chanelV.fansNumLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"fans_count"]];
        
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
        userInfo.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
        [userInfo saveOrUpdate];
        [userInfo updateUserInfoEntity];
        NSLog(@"%@",userInfo);
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.isLogin = YES;
        
        NSLog(@"result %@",result);
        
        //更新用户名
        _imgV.nickNameLabel.text = entity.nickname;
        //个人简介
        _imgV.summaryLabel.text = entity.summary;
        //等级
        _imgV.talentLabel.text = entity.levelDesc;
        _imgV.levelLabel.text = [NSString stringWithFormat:@"V%d",[entity.level intValue]];
        //更新头像
        [_imgV.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        //背景图
        NSLog(@"背景图 %@",entity.head_pic_url);
        [_imgV.bgImageView sd_setImageWithURL:[NSURL URLWithString:entity.head_pic_url] placeholderImage:[UIImage imageNamed:@"image"]];
        
        
        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
        _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
        _counterModel.subscription_count = [result objectForKey:@"data"][@"subscription_count"];
        _counterModel.sight_love_count = [result objectForKey:@"data"][@"sight_love_count"];
        NSLog(@"_counterModel   %@",_counterModel.message_count);
        if ([_counterModel.order_total_count intValue] == 0) {
            //不显示
            
        }else{
            //显示
            TipNumberView *tipNumView = [TipNumberView getTipNumView];
            tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_total_count];
            [_chanelTwoV.orderBtn addSubview:tipNumView];
            [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.right.mas_equalTo(_chanelTwoV.orderBtn.mas_right).with.offset(0);
                make.top.mas_equalTo(_chanelTwoV.orderBtn.mas_top).with.offset(-3);
            }];
        }
        
        if ([_counterModel.message_total_count intValue] == 0) {
            //不显示
            
        }else{
            //显示
            TipNumberView *tipNumView = [TipNumberView getTipNumView];
            tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.message_total_count];
            [_chanelTwoV.messageBtn addSubview:tipNumView];
            [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.right.mas_equalTo(_chanelTwoV.messageBtn.mas_right).with.offset(0);
                make.top.mas_equalTo(_chanelTwoV.messageBtn.mas_top).with.offset(-3);
            }];
        }
        if ([_counterModel.subscription_count intValue] == 0) {
            //不显示
            
        }else{
            //显示
            TipNumberView *tipNumView = [TipNumberView getTipNumView];
            tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.subscription_count];
            [_chanelTwoV.subscribeBtn addSubview:tipNumView];
            [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.right.mas_equalTo(_chanelTwoV.subscribeBtn.mas_right).with.offset(0);
                make.top.mas_equalTo(_chanelTwoV.subscribeBtn.mas_top).with.offset(-3);
            }];
        }
        if ([_counterModel.sight_love_count intValue] == 0) {
            //不显示
            
        }else{
            //显示
            TipNumberView *tipNumView = [TipNumberView getTipNumView];
            tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.sight_love_count];
            [_chanelTwoV.praiseBtn addSubview:tipNumView];
            [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.right.mas_equalTo(_chanelTwoV.praiseBtn.mas_right).with.offset(0);
                make.top.mas_equalTo(_chanelTwoV.praiseBtn.mas_top).with.offset(-3);
            }];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


-(void)clickPartnerBtn:(UIButton*)sender{
    NSLog(@"合作伙伴app");
}

-(void)clickOpinionBtn:(UIButton*)sender{
    NSLog(@"意见与反馈");
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickAboutBtn:(UIButton*)sender{
    NSLog(@"关于我们界面");
    AboutViewController *vc = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击我要认证按钮
-(void)clickCertificationBtn:(UIButton*)sender{
    //跳转到达人认证界面
    NSLog(@"跳转到达人认证界面");
    TalentCertificationViewController *vc = [[TalentCertificationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)signleTap1:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的场景的界面");
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = entity.userId;
    myHomeVC.type = @2;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

-(void)signleTap2:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的关注的界面");
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    view.userId = entity.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的粉丝的界面");
    MyFansViewController *view = [[MyFansViewController alloc] init];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    view.userId = entity.userId;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的情景的界面");
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    HomePageViewController *myHomeVC = [[HomePageViewController alloc] init];
    myHomeVC.userId = entity.userId;
    myHomeVC.type = @1;
    myHomeVC.isMySelf = YES;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滑动结束时获取当前滚动坐标的y值
    CGFloat y = scrollView.contentOffset.y;
    if (y<0) {
        //当坐标y大于0时就进行放大
        //改变图片的y坐标和高度
        CGRect frame = _imgV.frame;
        
        frame.origin.y = y;
        frame.size.height = -y+300/667.0*SCREEN_HEIGHT;
        _imgV.frame = frame;
    }
}

//订单按钮
-(void)orderBtn:(UIButton*)sender{
    NSLog(@"#########");
    //跳转到全部订单页
    AllOderViewController *vc = [[AllOderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//消息按钮
-(void)messageBtn:(UIButton*)sender{
    NSLog(@"#########");
    MessageViewController *vc = [[MessageViewController alloc] init];
    vc.countModel = _counterModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//订阅按钮
-(void)subscribeBtn:(UIButton*)sender{
    NSLog(@"#########");
    SubscribeViewController *vc = [[SubscribeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//收藏按钮
-(void)collectionBtn:(UIButton*)sender{
    NSLog(@"#########");
    SystemSettingViewController *systemVC = [[SystemSettingViewController alloc] init];
    [self.navigationController pushViewController:systemVC animated:YES];
}

//赞过按钮
-(void)praiseBtn:(UIButton*)sender{
    NSLog(@"#########");
    PraisedViewController *vc = [[PraisedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//积分按钮
-(void)integralBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//礼券按钮
-(void)giftBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//收货地址按钮
-(void)shippingAddressBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//服务条款按钮
-(void)serviceBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//账户管理按钮
-(void)accountManagementBtn:(UIButton*)sender{
    NSLog(@"#########");
    
    
    
    
}



-(void)leftBarItemSelected{
    FindeFriendViewController *v = [[FindeFriendViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.delegate = self;
//    [self addBarItemLeftBarButton:nil image:@"Page 1" isTransparent:YES];
    [self addNavLogoImgisTransparent:YES];
    
    //网络请求
    [self netGetData];
    
    [self addBarItemLeftBarButton:@"" image:@"Page 1" isTransparent:YES];
    
    
    self.tabBarController.tabBar.hidden = NO;
}



-(void)setImagesRoundedCorners:(float)radius :(UIImageView*)v{
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = 27.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
