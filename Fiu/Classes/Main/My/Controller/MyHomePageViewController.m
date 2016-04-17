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
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyHomeV.h"
#import "TipNumberView.h"
#import "Fiu.h"
#import "MyHomePageScenarioView.h"

@interface MyHomePageViewController ()<UIScrollViewDelegate>

{
    UIScrollView *_homeScrollView;
    UIImageView *_imgV;//背景图片
    ChanelView *_chanelV;
}

@end

@implementation MyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollView];
    [self setImage];
    [self setChanel];
    //添加情景
    if ([self.type isEqualToNumber:@1]) {
        [self AddScene:5];
    }else if ([self.type isEqualToNumber:@2]){
        //场景
        [self.view addSubview:self.myTableView];
    }
    
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
    btn.clipsToBounds = YES;
    btn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
//    nameLabel.center = CGPointMake(self.view.center.x, 30);
//    nameLabel.text = @"wqeqwe";
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.font = [UIFont systemFontOfSize:13];
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    //设置自动的布局
//    nameLabel.clipsToBounds = YES;
//    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [_imgV addSubview:nameLabel];
    
    
    UIImageView *headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 80, 80)];
    headPortrait.center = CGPointMake(self.view.center.x, 105);
    headPortrait.layer.cornerRadius = 40;
    [_imgV addSubview:headPortrait];
    TipNumberView *tipV = [TipNumberView getTipNumView];
    [_imgV addSubview:tipV];
    tipV.tipNumLabel.text = @"V";
    tipV.frame = CGRectMake(headPortrait.frame.origin.x+headPortrait.frame.size.width-15, headPortrait.frame.origin.y+headPortrait.frame.size.height-25, tipV.frame.size.width, tipV.frame.size.height);
    
    tipV.clipsToBounds = YES;
    tipV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //更新头像
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Dina Alexander"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //设置自动的布局
    headPortrait.clipsToBounds = YES;
    headPortrait.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 100, 20)];
    addressLabel.center = CGPointMake(self.view.center.x, 160);
    //更新用户名
    addressLabel.text = entity.nickname;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    //设置自动的布局
    addressLabel.clipsToBounds = YES;
    addressLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:addressLabel];
    
    
    
    MyHomeV *myHV = [MyHomeV geMyHomeV];
    myHV.frame = CGRectMake(0, 180, myHV.frame.size.width, myHV.frame.size.height);
    myHV.center = CGPointMake(self.view.center.x, 180+13);
    myHV.layer.cornerRadius = 2;
    myHV.summaryLabel.text = entity.summary;
    myHV.talentLabel.text = entity.levelDesc;
    myHV.levelLabel.text = [NSString stringWithFormat:@"V/%d",[entity.level intValue]];
    //设置自动的布局
    myHV.clipsToBounds = YES;
    myHV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imgV addSubview:myHV];
    
    
    [_homeScrollView addSubview:_imgV];
    
}


-(void)setChanel{
    _chanelV = [ChanelView getChanelView];
    _chanelV.frame = CGRectMake(0,_imgV.frame.size.height+5, self.view.frame.size.width, 60);
    [_homeScrollView addSubview:_chanelV];
}


-(void)AddScene:(int) number{
    int p;
    int y = 0;
    if (number%2 == 0) {
        p = number/2;
    }else{
        p = (number+1)/2;
    }
    for (int i = 0; i<p; i++) {
        
        for (int j = 0; j<2; j++) {
            if (number%2 != 0) {
                if (i == p-1 && j == 1) {
                    break;
                }
            }
            MyHomePageView *myHomepageV = [MyHomePageView getMyHomePageView];
            [myHomepageV setUI];
            int x = 5/667.0*SCREEN_HEIGHT+j*(myHomepageV.frame.size.width+5/667.0*SCREEN_HEIGHT);
            y = 5/667.0*SCREEN_HEIGHT+i*(myHomepageV.frame.size.height+5/667.0*SCREEN_HEIGHT)+_chanelV.frame.origin.y+_chanelV.frame.size.height+10;
            myHomepageV.frame = CGRectMake(x, y, myHomepageV.frame.size.width, myHomepageV.frame.size.height);
            [_homeScrollView addSubview:myHomepageV];
        }
    }
    _homeScrollView.contentSize = CGSizeMake(0, y+400);
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
