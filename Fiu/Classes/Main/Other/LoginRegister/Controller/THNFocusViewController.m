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
#import "UIColor+Extension.h"
#import <Masonry.h>
#import "THNPeopleView.h"
#import <SVProgressHUD.h>
#import "THNRedEnvelopeView.h"

@interface THNFocusViewController ()<UIScrollViewDelegate>
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *idAry;
/**  */
@property (nonatomic, strong) NSMutableArray *viewAry;
/**  */
@property (nonatomic, strong) UIPageControl *pagrControl;

@property(nonatomic, strong) UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet UIView *logoView;
/**  */
@property (nonatomic, assign) NSInteger page;

@end

@implementation THNFocusViewController

-(NSMutableArray *)idAry{
    if (!_idAry) {
        _idAry = [NSMutableArray array];
    }
    return _idAry;
}

-(NSMutableArray *)viewAry{
    if (!_viewAry) {
        _viewAry = [NSMutableArray array];
    }
    return _viewAry;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/user/find_user" requestDictionary:@{
                                                                                         @"size" : @18,
                                                                                         @"type" : @1,
                                                                                         @"sort" : @0,
                                                                                         @"edit_stick" : @1
                                                                                         } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSArray *users = result[@"data"][@"users"];
        self.modelAry = [THNFocusUserModel mj_objectArrayWithKeyValuesArray:users];
        int n = self.modelAry.count % 6;
        int m = n > 0 ? 1 : 0;
        self.page = self.modelAry.count / 6 + m;
        self.contentScrollView.frame = CGRectMake(0, 160 / 667.0 * [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0.53 * [UIScreen mainScreen].bounds.size.height);
        self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.page, 0);
        
        
        for (int i = 0; i < self.modelAry.count; i ++) {
            int page = i / 6;
            
            float w = ([UIScreen mainScreen].bounds.size.width - 15 * 2 - 8 * 2) / 3;
            float h = (self.contentScrollView.height - 7.5) * 0.5;
            float x = 15 + (i % 3) * (w + 8) + page * [UIScreen mainScreen].bounds.size.width;
            float y = 0 + ((i - page * 6) / 3) * (h + 7.5);
            THNPeopleView *view = [THNPeopleView viewFromXib];
            view.model = self.modelAry[i];
            view.frame = CGRectMake(x, y, w, h);
            [view.fucosBtn addTarget:self action:@selector(fucos:) forControlEvents:UIControlEventTouchUpInside];
            view.fucosBtn.tag = i;
            
            [self.contentScrollView addSubview:view];
            [self.viewAry addObject:view];
            if (page == 0) {
                [self fucos:view.fucosBtn];
            }
        }
        [self.view addSubview:self.contentScrollView];
        
        [self.view addSubview:self.pagrControl];
        [_pagrControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.contentScrollView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        [self.view addSubview:self.enterBtn];
        [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(self.pagrControl.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    } failure:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)fucos:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        sender.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
        sender.layer.borderColor = [UIColor clearColor].CGColor;

        [self.idAry addObject:((THNPeopleView*)self.viewAry[sender.tag]).model._id];
    }else{
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
        
        [self.idAry removeObject:((THNPeopleView*)self.viewAry[sender.tag]).model._id];
    }
    
}

-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:@"进入Fiu世界" forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _enterBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
        [_enterBtn setTitleColor:[UIColor colorWithHexString:@"#161002"] forState:UIControlStateNormal];
        _enterBtn.layer.masksToBounds = YES;
        _enterBtn.layer.cornerRadius = 3;
        [_enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

-(void)enter{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < self.idAry.count; i ++) {
        [str appendString:self.idAry[i]];
        if (i == self.idAry.count - 1) {
            break;
        }
        [str appendString:@","];
    }
    if (str.length == 0) {
        [self updateIdentify];
        return;
    }
    //开始传送数据
    NSDictionary *params = @{
                             @"follow_ids":str
                             };
    FBRequest *request1 = [FBAPI postWithUrlString:@"/follow/batch_follow" requestDictionary:params delegate:self];
    [request1 startRequestSuccess:^(FBRequest *request, id result) {
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD dismiss];
        }
        [self updateIdentify];
    } failure:^(FBRequest *request, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

-(void)updateIdentify{
    FBRequest *request = [FBAPI postWithUrlString:@"/my/update_user_identify" requestDictionary:@{
                                                                                                  @"type":@1
                                                                                                  } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(FBRequest *request, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(UIPageControl *)pagrControl{
    if (!_pagrControl) {
        _pagrControl = [[UIPageControl alloc] init];
        _pagrControl.numberOfPages = self.page;
        _pagrControl.currentPage = 0;
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
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

@end
