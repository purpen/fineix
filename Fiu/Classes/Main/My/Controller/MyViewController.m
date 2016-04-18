//
//  MyViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyViewController.h"
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
#import "MyOrdersViewController.h"
#import "MyHomePageScenarioViewController.h"
#import "MyPageFocusOnViewController.h"
#import "MyFansViewController.h"


@interface MyViewController ()<UIScrollViewDelegate>


{
    UIScrollView *_homeScrollView;
    BackImagView *_imgV;//背景图片
    
}


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    // Do any additional setup after loading the view.
    //[self setImagesRoundedCorners:27.0 :_headPortraitImageV];
    
    //在下面放置一个scrollview
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _homeScrollView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:247.0/255];
    _homeScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_homeScrollView];
    
    //让背景图片下拉变大
    _homeScrollView.delegate = self;
    //背景图片
    _imgV = [BackImagView getBackImageView];
    _imgV.headImageView.layer.masksToBounds = YES;
    _imgV.headImageView.layer.cornerRadius = 33;
    _imgV.frame = CGRectMake(0, 64, SCREEN_WIDTH, 200/667.0*SCREEN_HEIGHT);
    _imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_imgV addGestureRecognizer:singleTap];
    //我要认证按钮
    [_imgV.wantCertificationBtn addTarget:self action:@selector(clickCertificationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_homeScrollView addSubview:_imgV];
    
    //放一个view替换导航条，颜色为白色
    NaviView *naviV = [NaviView getNaviView];
    naviV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.view addSubview:naviV];
    naviV.backgroundColor = [UIColor clearColor];
    
    
    [naviV.camerlBtn addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];

    //频道选项
    ChanelView *chanelV = [ChanelView getChanelView];
    chanelV.frame = CGRectMake(0, 200+5, SCREEN_WIDTH, 60/667.0*SCREEN_HEIGHT);
    //情景
    chanelV.scenarioView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap:)];
    scenarioTap.numberOfTapsRequired = 1;
    scenarioTap.numberOfTouchesRequired = 1;
    [chanelV.scenarioView addGestureRecognizer:scenarioTap];
    //场景
    chanelV.fieldView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap1:)];
    scenarioTap1.numberOfTapsRequired = 1;
    scenarioTap1.numberOfTouchesRequired = 1;
    [chanelV.fieldView addGestureRecognizer:scenarioTap1];
    //关注
    chanelV.focusView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap2:)];
    scenarioTap2.numberOfTapsRequired = 1;
    scenarioTap2.numberOfTouchesRequired = 1;
    [chanelV.focusView addGestureRecognizer:scenarioTap2];
    //粉丝
    chanelV.fansView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scenarioTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap3:)];
    scenarioTap3.numberOfTapsRequired = 1;
    scenarioTap3.numberOfTouchesRequired = 1;
    [chanelV.fansView addGestureRecognizer:scenarioTap3];
    [_homeScrollView addSubview:chanelV];
    //订单等一些东西
    ChanelViewTwo *chanelTwoV = [ChanelViewTwo getChanelViewTwo];
    chanelTwoV.frame = CGRectMake(0, 200+5+60+5, SCREEN_WIDTH, 194);
    [_homeScrollView addSubview:chanelTwoV];
    //为订单等一些按钮添加方法
    //订单按钮
    [chanelTwoV.orderBtn addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    [chanelTwoV.messageBtn addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
    //订阅按钮
    [chanelTwoV.subscribeBtn addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    //收藏按钮
    [chanelTwoV.collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    //赞过按钮
    [chanelTwoV.praiseBtn addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    //积分按钮
    [chanelTwoV.integralBtn addTarget:self action:@selector(integralBtn:) forControlEvents:UIControlEventTouchUpInside];
    //礼券按钮
    [chanelTwoV.giftBtn addTarget:self action:@selector(giftBtn:) forControlEvents:UIControlEventTouchUpInside];
    //收货地址按钮
    [chanelTwoV.shippingAddressBtn addTarget:self action:@selector(shippingAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
    //服务条款按钮
    [chanelTwoV.serviceBtn addTarget:self action:@selector(serviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    //账户管理按钮
    [chanelTwoV.accountManagementBtn addTarget:self action:@selector(accountManagementBtn:) forControlEvents:UIControlEventTouchUpInside];
    //关于我们等
    BottomView *bottomV = [BottomView getBottomView];
    bottomV.frame = CGRectMake(0, 200+5+60+5+194+2, SCREEN_WIDTH, 134);
    [bottomV.aboutUsBtn addTarget:self action:@selector(clickAboutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV.opinionBtn addTarget:self action:@selector(clickOpinionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV.partnerBtn addTarget:self action:@selector(clickPartnerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_homeScrollView addSubview:bottomV];
    //京东图标
    AppBtnView *appV = [AppBtnView getAppBtnView];
    appV.frame = CGRectMake(0, 200+5+60+5+194+2+134, SCREEN_WIDTH, 91);
    [_homeScrollView addSubview:appV];
    //scrollView滑动范围
    _homeScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(appV.frame)+91);
    //向上滑动tabbar消失
    
    //向下滑动tabbar出现
}

-(void)clickPartnerBtn:(UIButton*)sender{
    NSLog(@"合作伙伴app");
}

-(void)clickOpinionBtn:(UIButton*)sender{
    NSLog(@"意见与反馈");
}

-(void)clickAboutBtn:(UIButton*)sender{
    NSLog(@"关于我们界面");
}

//点击我要认证按钮
-(void)clickCertificationBtn:(UIButton*)sender{
    //跳转到达人认证界面
    NSLog(@"跳转到达人认证界面");
}

-(void)signleTap1:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的场景的界面");
    MyHomePageScenarioViewController *myHomeVC = [[MyHomePageScenarioViewController alloc] init];
    myHomeVC.type = @2;
    [self.navigationController pushViewController:myHomeVC animated:YES];
}

-(void)signleTap2:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的关注的界面");
    MyPageFocusOnViewController *view = [[MyPageFocusOnViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap3:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的粉丝的界面");
    MyFansViewController *view = [[MyFansViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)signleTap:(UITapGestureRecognizer*)gesture{
    //跳转到我的主页的情景的界面
    NSLog(@"跳转到我的主页的情景的界面");
    MyHomePageScenarioViewController *myHomeVC = [[MyHomePageScenarioViewController alloc] init];
    myHomeVC.type = @1;
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
        frame.size.height = -y+200;
        _imgV.frame = frame;
    }
}

//订单按钮
-(void)orderBtn:(UIButton*)sender{
    NSLog(@"#########");
    //跳转到全部订单页
    UIStoryboard *myStory = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    MyOrdersViewController *oderVC = [myStory instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
    [self.navigationController pushViewController:oderVC animated:YES];
}

//消息按钮
-(void)messageBtn:(UIButton*)sender{
    NSLog(@"#########");
}
//订阅按钮
-(void)subscribeBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//收藏按钮
-(void)collectionBtn:(UIButton*)sender{
    NSLog(@"#########");
}

//赞过按钮
-(void)praiseBtn:(UIButton*)sender{
    NSLog(@"#########");
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



//点击导航左按钮
-(void)clickImageBtn:(UIButton*)sender{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    //如果已经登录了直接进入个人中心并展示个人的相关信息
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
//    if (entity.isLogin == YES) {
//        //如果已经登录了直接进入个人中心并展示个人的相关信息
//        //更新用户名
//        _imgV.nickNameLabel.text = entity.nickname;
//        //个人简介
//        _imgV.summaryLabel.text = entity.summary;
//        //等级
//        _imgV.talentLabel.text = entity.levelDesc;
//        _imgV.levelLabel.text = [NSString stringWithFormat:@"V%d",[entity.level intValue]];
//        //更新头像
//        [_imgV.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//    }//如果没有登录提示用户登录
//    else{
//        //跳到登录页面
//        UIStoryboard *loginReginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
//        FBLoginRegisterViewController * loginRegisterVC = [loginReginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
//        //设置导航
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginRegisterVC];
//        [self presentViewController:navi animated:YES completion:nil];
//        
//
//    }
    //将要进入界面时让导航条和tabbar都出现
    self.navigationController.navigationBarHidden = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
