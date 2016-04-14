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

@interface GuidePageViewController ()<UIScrollViewDelegate>
{
    NSArray *_pictureArr;
    UIViewController *_mainController;
    UIScrollView *_guideScrollView;
    UIImageView *_guideImageView;
    UIPageControl *_guidePageController;
}
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
    // Do any additional setup after loading the view from its nib.
    //设置scrollview
    [self setScrollView];
    //设置ImageView
    [self setImageView];
    //设置页码控制器
    [self setPageController];
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
            UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            myBtn.frame = CGRectMake(SCREEN_WIDTH-120, SCREEN_HEIGHT-50, 100, 40);
            CGPoint center = myBtn.center;
            center.x = self.view.center.x;
            myBtn.center = center;
            myBtn.backgroundColor = [UIColor whiteColor];
            [myBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            [myBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            myBtn.layer.cornerRadius = 10;
            myBtn.layer.masksToBounds = YES;
            [myBtn addTarget:self action:@selector(clickSkips:) forControlEvents:UIControlEventTouchUpInside];
            [_guideImageView addSubview:myBtn];
        }
    }
}


//点击『立即使用』按钮
-(void)clickSkips:(UIButton*)sender{
    //弹出登录注册界面
    FBTabBarController *tab = [[FBTabBarController alloc] init];
    [tab setSelectedIndex:0];
    [self presentViewController:tab animated:YES completion:nil];
    

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
