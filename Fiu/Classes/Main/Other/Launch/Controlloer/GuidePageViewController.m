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
#import "THNTabBarController.h"
#import "InviteCCodeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import <AdSupport/AdSupport.h>

@interface GuidePageViewController ()<UIScrollViewDelegate,FBRequestDelegate>
{
    NSArray *_pictureArr;
    UIViewController *_mainController;
    UIScrollView *_guideScrollView;
    UIImageView *_guideImageView;
    UIPageControl *_guidePageController;
}
@property (nonatomic,strong) UIButton *enterBtn;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
/**  */
@property (nonatomic, strong) UIButton *soundBtn;
/**  */
@property (nonatomic, strong) UIButton *unSoundBtn;
/**  */
@property (nonatomic, strong) UIButton *skipBtn;
/**  */
@property (nonatomic, strong) UITapGestureRecognizer *clickTap;
/**  */
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
/**  */
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

static NSString *userActivationUrl = @"/gateway/record_fiu_user_active";

@implementation GuidePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(UISwipeGestureRecognizer *)leftSwipeGestureRecognizer{
    if (!_leftSwipeGestureRecognizer) {
        _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture)];
        _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _leftSwipeGestureRecognizer;
}

-(UISwipeGestureRecognizer *)rightSwipeGestureRecognizer{
    if (!_rightSwipeGestureRecognizer) {
        _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeGesture)];
        _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _rightSwipeGestureRecognizer;
}

-(void)rightSwipeGesture{
    [_guideScrollView setContentOffset:CGPointMake(2 * SCREEN_WIDTH, 0) animated:YES];
    _guideScrollView.scrollEnabled = YES;
}

-(UITapGestureRecognizer *)clickTap{
    if (!_clickTap) {
        _clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianJi)];
    }
    return _clickTap;
}

-(void)dianJi{
    
    FBRequest *request = [FBAPI postWithUrlString:userActivationUrl requestDictionary:nil delegate:self];
    request.flag = userActivationUrl;
    request.delegate = self;
    [request startRequest];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
    if ([_mainController isKindOfClass:[THNTabBarController class]]) {
        
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
                    THNTabBarController *tab = [[THNTabBarController alloc] init];
                    [tab setSelectedIndex:0];
                    [self presentViewController:tab animated:YES completion:nil];
                }else{
                    if (invitation) {
                        InviteCCodeViewController *vc = [[InviteCCodeViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self presentViewController:vc animated:YES completion:nil];
                    }else{
                        THNTabBarController *tab = [[THNTabBarController alloc] init];
                        [tab setSelectedIndex:0];
                        [self presentViewController:tab animated:YES completion:nil];
                    }
                }
            }else if([code isEqual:@(0)]){
                //没有开启邀请功能
                THNTabBarController *tab = [[THNTabBarController alloc] init];
                [tab setSelectedIndex:0];
                [self presentViewController:tab animated:YES completion:nil];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)leftSwipeGesture{
    
//    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    FBRequest *request = [FBAPI postWithUrlString:userActivationUrl requestDictionary:nil delegate:self];
    request.flag = userActivationUrl;
    request.delegate = self;
    [request startRequest];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
    if ([_mainController isKindOfClass:[THNTabBarController class]]) {
        
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
                    THNTabBarController *tab = [[THNTabBarController alloc] init];
                    [tab setSelectedIndex:0];
                    [self presentViewController:tab animated:YES completion:nil];
                }else{
                    if (invitation) {
                        InviteCCodeViewController *vc = [[InviteCCodeViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self presentViewController:vc animated:YES completion:nil];
                    }else{
                        THNTabBarController *tab = [[THNTabBarController alloc] init];
                        [tab setSelectedIndex:0];
                        [self presentViewController:tab animated:YES completion:nil];
                    }
                }
            }else if([code isEqual:@(0)]){
                //没有开启邀请功能
                THNTabBarController *tab = [[THNTabBarController alloc] init];
                [tab setSelectedIndex:0];
                [self presentViewController:tab animated:YES completion:nil];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(instancetype)initWithPicArr:(NSArray *)picArr andRootVC:(UIViewController *)controller{
    if (self == [super init]) {
        _pictureArr = picArr;
        _mainController = controller;
    }
    return self;
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.flag == shouYe) {
        //播放
        [self.moviePlayer play];
        //添加通知
        [self addNotification];
        
    }else if (self.flag == welcomePage){
        [self startRollImg];
    }
    
}

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSString * audioPath = [[NSBundle mainBundle] pathForResource:@"Fiu" ofType:@"mp4"];
        NSURL * playUrl = [NSURL fileURLWithPath:audioPath];
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:playUrl];
        _moviePlayer.view.frame=self.view.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _moviePlayer.controlStyle = MPMovieControlStyleNone;

        [_moviePlayer.view addSubview:self.soundBtn];
        [_moviePlayer.view addSubview:self.unSoundBtn];
        [_moviePlayer.view addSubview:self.skipBtn];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        self.soundBtn.selected = YES;
        
        [self.view addSubview:_moviePlayer.view];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return _moviePlayer;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    [self startRollImg];
}

-(UIButton *)soundBtn{
    if (!_soundBtn) {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _soundBtn.frame = CGRectMake(15, 15, 28, 28);
        _soundBtn.layer.masksToBounds = YES;
        _soundBtn.layer.cornerRadius = 14;
        _soundBtn.backgroundColor = [UIColor colorWithHexString:@"#231916" alpha:0.6];
        [_soundBtn setImage:[UIImage imageNamed:@"guide_unSound"] forState:UIControlStateNormal];
        [_soundBtn setImage:[UIImage imageNamed:@"guide_sound"] forState:UIControlStateSelected];
        [_soundBtn addTarget:self action:@selector(soundClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundBtn;
}

//-(UIButton *)unSoundBtn{
//    if (!_unSoundBtn) {
//        _unSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _unSoundBtn.frame = CGRectMake(48, 19, 20, 20);
//        [_unSoundBtn setImage:[UIImage imageNamed:@"guide_unSound"] forState:UIControlStateNormal];
//        [_unSoundBtn addTarget:self action:@selector(unSoundClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _unSoundBtn;
//}

-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 40, 15, 40, 21);
        _skipBtn.backgroundColor = [UIColor colorWithHexString:@"#231916" alpha:0.6];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = 2;
        [_skipBtn addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

-(void)skipClick{
    [self.moviePlayer stop];
}

-(void)soundClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
    }else{
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.5];
    }
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
            [_guideImageView addGestureRecognizer:self.clickTap];
            [_guideImageView addGestureRecognizer:self.leftSwipeGestureRecognizer];
            [_guideImageView addGestureRecognizer:self.rightSwipeGestureRecognizer];
//            [_guideImageView addSubview:self.enterBtn];
//            [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(100/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
//                make.centerX.mas_equalTo(_guideImageView.mas_centerX);
//                make.bottom.mas_equalTo(_guideImageView.mas_bottom).with.offset(-50/667.0*SCREEN_HEIGHT);
//            }];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (index == 3) {
        scrollView.scrollEnabled = NO;
    }else{
        scrollView.scrollEnabled = YES;
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
    if ([_mainController isKindOfClass:[THNTabBarController class]]) {

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
                    THNTabBarController *tab = [[THNTabBarController alloc] init];
                    [tab setSelectedIndex:0];
                    [self presentViewController:tab animated:YES completion:nil];
                }else{
                    if (invitation) {
                        InviteCCodeViewController *vc = [[InviteCCodeViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self presentViewController:vc animated:YES completion:nil];
                    }else{
                        THNTabBarController *tab = [[THNTabBarController alloc] init];
                        [tab setSelectedIndex:0];
                        [self presentViewController:tab animated:YES completion:nil];
                    }
                }
            }else if([code isEqual:@(0)]){
                //没有开启邀请功能
                THNTabBarController *tab = [[THNTabBarController alloc] init];
                [tab setSelectedIndex:0];
                [self presentViewController:tab animated:YES completion:nil];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
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

- (void)dealloc {
    
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
