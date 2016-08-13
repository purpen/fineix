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
@property (nonatomic, strong) NSArray *aryAry;
@end

@implementation THNFocusViewController


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
        for (int i = 12; i < 18; i ++) {
            [self.threeModelAry addObject:self.modelAry[i]];
        }
        NSLog(@"%zd",self.modelAry.count);
        self.aryAry = [NSArray arrayWithObjects:self.oneModelAry,self.twoModelAry,self.threeModelAry, nil];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [self.view addSubview:self.contentScrollView];
//    CGPoint offset = self.contentScrollView.contentOffset;
//    offset.x = 1 * self.contentScrollView.width;
//    [self.contentScrollView setContentOffset:offset animated:YES];
    
    for (int i = 0; i < 3; i ++) {
        
        float w = [UIScreen mainScreen].bounds.size.width;
        float h = 0.53 * [UIScreen mainScreen].bounds.size.height;
        float x = i * w;
        float y = 0;
        
        THNFucosPeopleView *view = [[THNFucosPeopleView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        view.modelAry = self.aryAry[i];
        [_contentScrollView addSubview:view];
    }

}

-(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160 / 667.0 * [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0.53 * [UIScreen mainScreen].bounds.size.height)];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
        _contentScrollView.backgroundColor = [UIColor clearColor];
    }
    return _contentScrollView;
}

@end
