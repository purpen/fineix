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
    _homeScrollView.contentSize = CGSizeMake(0, 100000);
    //让背景图片下拉变大
    _homeScrollView.delegate = self;
    //背景图片
    _imgV = [BackImagView getBackImageView];
    _imgV.frame = CGRectMake(0, 64, SCREEN_WIDTH, 200);
    _imgV.userInteractionEnabled = YES;
    [_homeScrollView addSubview:_imgV];
    //放一个view替换导航条，颜色为白色
    NaviView *naviV = [NaviView getNaviView];
    [self.view addSubview:naviV];
    [naviV.camerlBtn addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [naviV.calendarBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    //频道选项
    ChanelView *chanelV = [ChanelView getChanelView];
    chanelV.frame = CGRectMake(0, 200+5, SCREEN_WIDTH, 60);
    [_homeScrollView addSubview:chanelV];
    //订单等一些东西
    //关于我们等
    //京东图标
    
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

//点击导航右按钮
-(void)clickRightBtn:(UIButton*)sender{
    NSLog(@"*****");
}

//点击导航左按钮
-(void)clickImageBtn:(UIButton*)sender{
    NSLog(@"#########");
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.isLogin == YES) {
        //如果已经登录了直接进入个人中心并展示个人的相关信息
        //更新用户名
        //self.nickNameLabel.text = entity.nickname;
        //更新头像
        //[self.headPortraitImageV sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        //}];
    }//如果没有登录提示用户登录
    else{
        //跳到登录页面
        UIStoryboard *loginReginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
        FBLoginRegisterViewController * loginRegisterVC = [loginReginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
        //设置导航
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginRegisterVC];
        [self presentViewController:navi animated:YES completion:nil];
        

    }
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
