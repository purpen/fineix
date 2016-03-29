//
//  MyHomePageViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomePageViewController.h"
#import "MyHomePageView.h"
#import "ChanelView.h"

@interface MyHomePageViewController ()<UIScrollViewDelegate>

{
    UIScrollView *_homeScrollView;
    UIImageView *_imgV;//背景图片
}

@end

@implementation MyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollView];
    [self setImage];
    [self setChanel];
    //添加情景
    [self AddScene:4];
    //让背景图片下拉变大
    _homeScrollView.delegate = self;
    //设置图片的contentMode属性
    _imgV.contentMode = UIViewContentModeScaleAspectFill;
    _imgV.autoresizesSubviews = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滑动结束时获取当前滚动坐标的y值
    CGFloat y = scrollView.contentOffset.y;
    if (y<0) {
        //当坐标y大于0时就进行放大
        //改变图片的y坐标和高度
        CGRect frame = _imgV.frame;
        
        frame.origin.y = y;
        frame.size.height = -y+240;
        _imgV.frame = frame;
    }
}

-(void)setScrollView{
    _homeScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _homeScrollView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:247.0/255];
    _homeScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_homeScrollView];
}

-(void)setImage{
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 240)];
    _imgV.image = [UIImage imageNamed:@"image"];
    _imgV.userInteractionEnabled = YES;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, 35, 30, 18)];
    [btn setImage:[UIImage imageNamed:@"Fill 1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [_imgV addSubview:btn];
    //设置自动的布局
//    btn.clipsToBounds = YES;
//    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
    nameLabel.center = CGPointMake(self.view.center.x, 30);
    nameLabel.text = @"wqeqwe";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //设置自动的布局
    nameLabel.clipsToBounds = YES;
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:nameLabel];
    
    
    UIImageView *headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 80, 80)];
    headPortrait.center = CGPointMake(self.view.center.x, 105);
    headPortrait.image = [UIImage imageNamed:@"Dina Alexander"];
    headPortrait.layer.cornerRadius = 40;
    //设置自动的布局
    headPortrait.clipsToBounds = YES;
    headPortrait.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:headPortrait];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, 100, 20)];
    addressLabel.center = CGPointMake(self.view.center.x, 165);
    addressLabel.text = @"wqeqwe";
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    //设置自动的布局
    addressLabel.clipsToBounds = YES;
    addressLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:addressLabel];
    
    
    UIButton *personalDataButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 180, 111, 26)];
    personalDataButton.center = CGPointMake(self.view.center.x, 180+13);
    personalDataButton.layer.cornerRadius = 2;
    personalDataButton.backgroundColor = [UIColor redColor];
    [personalDataButton setTitle:@"修改个人资料" forState:UIControlStateNormal];
    personalDataButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //设置自动的布局
    personalDataButton.clipsToBounds = YES;
    personalDataButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:personalDataButton];
    
    
    [_homeScrollView addSubview:_imgV];
    
}


-(void)setChanel{
    ChanelView *chanelV = [ChanelView getChanelView];
    chanelV.frame = CGRectMake(0, 220, self.view.frame.size.width, 60);
    [_homeScrollView addSubview:chanelV];
}


-(void)AddScene:(int) number{
    for (int i = 0; i<number; i++) {
        MyHomePageView *myHomepageV = [MyHomePageView getMyHomePageView];
        myHomepageV.frame = CGRectMake(8, 303+(myHomepageV.frame.size.height+5)*i, myHomepageV.frame.size.width, myHomepageV.frame.size.height);
        [_homeScrollView addSubview:myHomepageV];
    }
    _homeScrollView.contentSize = CGSizeMake(0, 303+(202+5)*(number)+5);
}

-(void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
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
