//
//  THNFocusViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNFocusViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UIView+FSExtension.h"
#import "THNFocusUserModel.h"
#import <MJExtension.h>
#import "THNFucosPeopleView.h"
#import "UIColor+Extension.h"
#import <Masonry.h>
#import "THNPeopleView.h"

@interface THNFocusViewController ()<UIScrollViewDelegate>
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *oneModelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *twoModelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *threeModelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *aryAry;
/**  */
@property (nonatomic, strong) UIPageControl *pagrControl;
@end

@implementation THNFocusViewController

-(NSMutableArray *)aryAry{
    if (!_aryAry) {
        _aryAry = [NSMutableArray array];
    }
    return _aryAry;
}

-(NSMutableArray *)oneModelAry{
    if (!_oneModelAry) {
        _oneModelAry = [NSMutableArray array];
    }
    return _oneModelAry;
}

-(NSMutableArray *)twoModelAry{
    if (!_twoModelAry) {
        _twoModelAry = [NSMutableArray array];
    }
    return _twoModelAry;
}

-(NSMutableArray *)threeModelAry{
    if (!_threeModelAry) {
        _threeModelAry = [NSMutableArray array];
    }
    return _threeModelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/user/find_user" requestDictionary:@{
                                                                                         @"size" : @18,
                                                                                         @"type" : @1,
                                                                                         @"sort" : @0,
                                                                                         @"edit_stick" : @1
                                                                                         } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSArray *users = result[@"data"][@"users"];
        self.modelAry = [THNFocusUserModel mj_objectArrayWithKeyValuesArray:users];
        
        for (int i = 0; i < 6; i ++) {
            [self.oneModelAry addObject:self.modelAry[i]];
        }
        for (int i = 6; i < 12; i ++) {
            [self.twoModelAry addObject:self.modelAry[i]];
        }
        for (int i = 12; i < 17; i ++) {
            [self.threeModelAry addObject:self.modelAry[i]];
        }
        
        [self.aryAry addObject:self.oneModelAry];
        [self.aryAry addObject:self.twoModelAry];
        [self.aryAry addObject:self.threeModelAry];
        
        
        for (int i = 0; i < 3; i ++) {
            
            float w = [UIScreen mainScreen].bounds.size.width;
            float h = 0.53 * [UIScreen mainScreen].bounds.size.height;
            float x = i * w;
            float y = 0;
            
            THNFucosPeopleView *view = [[THNFucosPeopleView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            view.modelAry = self.aryAry[i];
            [_contentScrollView addSubview:view];
        }

    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [self.view addSubview:self.contentScrollView];
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = 1 * self.contentScrollView.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
    
    [self.view addSubview:self.pagrControl];
    [_pagrControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.contentScrollView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

-(UIPageControl *)pagrControl{
    if (!_pagrControl) {
        _pagrControl = [[UIPageControl alloc] init];
        _pagrControl.numberOfPages = 3;
        _pagrControl.currentPage = 1;
        _pagrControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pagrControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#909090" alpha:1];
    }
    return _pagrControl;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    _pagrControl.currentPage = index;
}

-(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160 / 667.0 * [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0.53 * [UIScreen mainScreen].bounds.size.height)];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

@end
