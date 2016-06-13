//
//  GuidePageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GuidePageViewController.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import "FBTabBarController.h"
#import "InviteCCodeViewController.h"

@interface GuidePageViewController ()<UIScrollViewDelegate>
{
    NSArray *_pictureArr;
    UIViewController *_mainController;
    UIScrollView *_guideScrollView;
    UIImageView *_guideImageView;
    UIPageControl *_guidePageController;
}
@property (nonatomic,strong) UIButton *enterBtn;
@end

@implementation GuidePageViewController

-(instancetype)initWithPicArr:(NSArray *)picArr andRootVC:(UIViewController *)controller{
    if (self == [super init]) {
        _pictureArr = picArr;
        _mainController = controller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.player play];

    //设置页码控制器
//    [self setPageController];
//    InviteCCodeViewController *vc = [[InviteCCodeViewController alloc] init];
//    BOOL userIsFirstInstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasGuideView"];
//    if (userIsFirstInstalled) {
//        FBTabBarController * tabBarC = [[FBTabBarController alloc] init];
//        self.window.rootViewController = tabBarC;
//        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//        FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
//        [request startRequestSuccess:^(FBRequest *request, id result) {
//            NSDictionary *dataDict = result[@"data"];
//            NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
//            _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
//            //判断小圆点是否消失
//            if (![_counterModel.message_total_count isEqual:@0]) {
//                [tabBarC.tabBar showBadgeWithIndex:4];
//            }else{
//                [tabBarC.tabBar hideBadgeWithIndex:4];
//            }
//        } failure:^(FBRequest *request, NSError *error) {
//        }];
//    }else{
//        self.window.rootViewController = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:[[FBTabBarController alloc] init]];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
//    }
}

#pragma mark - 首次启动视频
- (AVPlayer *)player {
    if (!_player) {
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        
        NSString * audioPath = [[NSBundle mainBundle] pathForResource:@"Fiu" ofType:@"mp4"];
        NSURL * playUrl = [NSURL fileURLWithPath:audioPath];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer addSublayer:layer];
        
        [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(startRollImg) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}

- (void)startRollImg {
    //设置scrollview
    [self setScrollView];
    //设置ImageView
    [self setImageView];
}

//设置页码控制器
-(void)setPageController{
    _guidePageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, 50, 20)];
    CGPoint center = _guidePageController.center;
    center.x = self.view.center.x;
    _guidePageController.center = center;
    _guidePageController.numberOfPages = _pictureArr.count;
    _guidePageController.currentPage = 0;
    [self.view addSubview:_guidePageController];
}

//设置scrollview
-(void)setScrollView{
    _guideScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_pictureArr.count, SCREEN_HEIGHT);
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.showsVerticalScrollIndicator = NO;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.alwaysBounceVertical = NO;
    _guideScrollView.alwaysBounceHorizontal = NO;
    _guideScrollView.bounces = NO;
    _guideScrollView.delegate = self;
    [self.view addSubview:_guideScrollView];
}

//设置ImageView
-(void)setImageView{
    for (int i = 0; i<_pictureArr.count; i++) {
        _guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_pictureArr[i]]];
        _guideImageView.userInteractionEnabled = YES;
        _guideImageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_guideScrollView addSubview:_guideImageView];
        if (i == _pictureArr.count - 1) {
            [_guideImageView addSubview:self.enterBtn];
            [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
                make.centerX.mas_equalTo(_guideImageView.mas_centerX);
                make.bottom.mas_equalTo(_guideImageView.mas_bottom).with.offset(-50/667.0*SCREEN_HEIGHT);
            }];
        }
    }
}

-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        _enterBtn.backgroundColor = [UIColor whiteColor];
//        [_enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _enterBtn.layer.cornerRadius = 10;
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn addTarget:self action:@selector(clickSkips:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

//点击『立即使用』按钮
-(void)clickSkips:(UIButton*)sender{
    if ([_mainController isKindOfClass:[FBTabBarController class]]) {

        __block BOOL invitation;
        FBRequest *request = [FBAPI postWithUrlString:@"/gateway/is_invited" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dict = [result objectForKey:@"data"];
            NSNumber *code = [dict objectForKey:@"status"];
            if ([code isEqual:@(1)]) {
                //开启了邀请功能
                invitation = YES;
                BOOL codeFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"codeFlag"];
                if (codeFlag) {
                    FBTabBarController *tab = [[FBTabBarController alloc] init];
                    [tab setSelectedIndex:0];
                    [self presentViewController:tab animated:YES completion:nil];
                }else{
                    if (invitation) {
                        [self presentViewController:[[InviteCCodeViewController alloc] init] animated:YES completion:nil];
                    }else{
                        FBTabBarController *tab = [[FBTabBarController alloc] init];
                        [tab setSelectedIndex:0];
                        [self presentViewController:tab animated:YES completion:nil];
                    }
                }
            }else if([code isEqual:@(0)]){
                //没有开启邀请功能
                invitation = NO;
                BOOL codeFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"codeFlag"];
                if (codeFlag) {
                    FBTabBarController *tab = [[FBTabBarController alloc] init];
                    [tab setSelectedIndex:0];
                    [self presentViewController:tab animated:YES completion:nil];
                }else{
                    if (invitation) {
                        [self presentViewController:[[InviteCCodeViewController alloc] init] animated:YES completion:nil];
                    }else{
                        FBTabBarController *tab = [[FBTabBarController alloc] init];
                        [tab setSelectedIndex:0];
                        [self presentViewController:tab animated:YES completion:nil];
                    }
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    

//    //如果没有登录过弹出登录注册界面
//    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//    if (entity.isLogin == NO) {
//        //转到我的界面
//        UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"My" bundle:nil];
//        MyViewController *loginVC = [loginStory instantiateViewControllerWithIdentifier:@"MyViewController"];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:navi animated:YES completion:nil];
//    }//跳到首页页面，如果没有登录过弹出登录注册界面
//    else{
//        [self presentViewController:_mainController animated:YES completion:nil];
//    }
    
}

//UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x/SCREEN_WIDTH);
    _guidePageController.currentPage = index;
    //如果是最后一个页面UIPageControl隐藏
    if (index == _pictureArr.count-1) {
        _guidePageController.hidden = YES;
    }//如果不是显示
    else{
       _guidePageController.hidden = NO;
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
