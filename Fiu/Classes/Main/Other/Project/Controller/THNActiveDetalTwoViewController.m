//
//  THNActiveDetalTwoViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveDetalTwoViewController.h"
#import "THNActiveTopView.h"
#import "UIView+FSExtension.h"
#import "HMSegmentedControl.h"
#import "THNArticleModel.h"
#import "THNActiveRuleCollectionViewCell.h"
#import "THNActiveRuleModel.h"
#import "PictureToolViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "THNSenceModel.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNSceneDetalViewController.h"
#import <MJRefresh.h>
#import "THNSceneImageViewController.h"

@interface THNActiveDetalTwoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>

{
    UICollectionViewFlowLayout * _flowLayout;
}
/**  */
@property (nonatomic, strong) UICollectionView *contentView;
/**  */
@property (nonatomic, strong) THNActiveTopView *activeTopView;
/**  */
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
/**  */
@property (nonatomic, strong) THNActiveRuleModel *ruleModel;
/**  */
@property (nonatomic, strong) NSMutableArray *senceModelAry;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/**  */
@property (nonatomic, strong) NSMutableArray *resultsAry;
/**  */
@property (nonatomic, strong) THNUserInfoTableViewCell *top;
/**  */
@property (nonatomic, strong) THNSceneImageTableViewCell *scene;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *followRequest;
@pro_strong FBRequest *cancelFollowRequest;
/**  */
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
/**  */
@property (nonatomic, strong) NSMutableArray *userIdMarr;
/**  */
@property (nonatomic, strong) NSMutableArray *resultUserIdAry;
/**  */
@property (nonatomic, assign) CGFloat webViewHeghit;
/**  */
@property (nonatomic, assign) int webViewLoads;

@end

static NSString *const topCellId = @"topCellId";
static NSString *const secondCellId = @"secondCellId";
static NSString *const ruleCellId = @"ruleCellId";
static NSString * collectionViewCellId = @"THNDiscoverSceneCollectionViewCell";
static NSString * resultCellId = @"resultCellId";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";

@implementation THNActiveDetalTwoViewController

-(NSMutableArray *)userIdMarr{
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

-(NSMutableArray *)resultUserIdAry{
    if (!_resultUserIdAry) {
        _resultUserIdAry = [NSMutableArray array];
    }
    return _resultUserIdAry;
}

-(NSMutableArray *)resultsAry{
    if (!_resultsAry) {
        _resultsAry = [NSMutableArray array];
    }
    return _resultsAry;
}

-(NSMutableArray *)sceneIdMarr{
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

-(NSMutableArray *)senceModelAry{
    if (!_senceModelAry) {
        _senceModelAry = [NSMutableArray array];
    }
    return _senceModelAry;
}

-(UICollectionView *)contentView{
    if (!_contentView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:_flowLayout];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:topCellId];
        [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:secondCellId];
        [_contentView registerNib:[UINib nibWithNibName:@"THNActiveRuleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ruleCellId];
        [_contentView registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellId];
        [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:resultCellId];
    }
    return _contentView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)dealloc {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navViewTitle.text = @"活动详情";
    self.type = @0;
    [self ruleRequest];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(THNActiveTopView *)activeTopView{
    if (!_activeTopView) {
        _activeTopView = [THNActiveTopView viewFromXib];
        _activeTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 211);
    }
    return _activeTopView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 2) {
        NSInteger flag = [self.type integerValue];
        switch (flag) {
            case 0:
                //活动规则
                return 1;
                break;
            case 1:
                //参与的情境
                return self.senceModelAry.count;
                break;
            case 2:
                //活动结果
                return self.resultsAry.count;
                break;
                
            default:
                break;
        }
    }
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        NSInteger flag = [self.type integerValue];
        switch (flag) {
            case 1:
                //参与的情境
                return UIEdgeInsetsMake(15, 15, 15, 15);
                break;
            case 2:
                //活动结果
                return UIEdgeInsetsMake(15, 0, 15, 0);
                break;
            default:
                break;
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        NSInteger flag = [self.type integerValue];
        switch (flag) {
            case 1:
                //参与的情境
                return 15;
                break;
            case 2:
                //活动结果
                return 15;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 211);
    }else if (indexPath.section == 1){
        return CGSizeMake(SCREEN_WIDTH, 44);
    }else if (indexPath.section == 2){
        NSInteger flag = [self.type integerValue];
        switch (flag) {
            case 0:
                //活动规则
            {
                return CGSizeMake(SCREEN_WIDTH, self.webViewHeghit + 50);
            }
                break;
            case 1:
                //参与的情境
                return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.3 * SCREEN_HEIGHT);
                break;
            case 2:
                //活动结果
                return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH + 50);
                break;
                
            default:
                break;
        }
    }
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.3 * SCREEN_HEIGHT);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellId forIndexPath:indexPath];
        [cell.contentView addSubview:self.activeTopView];
        return cell;
    }else if (indexPath.section == 1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCellId forIndexPath:indexPath];
        [cell.contentView addSubview:self.segmentedControl];
        return cell;
    }else if (indexPath.section == 2){
        NSInteger flag = [self.type integerValue];
        switch (flag) {
            case 0:
                //活动规则
            {
                THNActiveRuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ruleCellId forIndexPath:indexPath];
                cell.model = self.ruleModel;
                if (self.webViewLoads == 1) {
                    cell.contentWebView.delegate = nil;
                }else{
                    cell.contentWebView.delegate = self;
                }
                
                NSURL *url = [NSURL URLWithString:self.ruleModel.content_view_url];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [cell.contentWebView loadRequest:request];
                [cell.attendBtn addTarget:self action:@selector(attend) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                break;
            }
            case 1:
                //参与的情境
            {
                THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
                cell.model = self.senceModelAry[indexPath.row];
                cell.beginLikeTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkLikeSceneData:idx];
                };
                
                cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkCancelLikeData:idx];
                };
                
                return cell;
            }
                break;
            case 2:
                //活动结果
            {
                _scene = [[THNSceneImageTableViewCell alloc] init];
                
                _scene.sceneImage.tag = indexPath.row;
                [_scene.sceneImage addTarget:self action:@selector(sceneImageClick:) forControlEvents:UIControlEventTouchUpInside];
                _top = [[THNUserInfoTableViewCell alloc] init];
                _top.beginFollowTheUserBlock = ^(NSString *userId) {
                    [weakSelf beginFollowUser:userId];
                };
                
                _top.cancelFollowTheUserBlock = ^(NSString *userId) {
                    [weakSelf cancelFollowUser:userId];
                };
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resultCellId forIndexPath:indexPath];
                [cell.contentView addSubview:self.top];
                [self.top mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(50);
                    make.left.mas_equalTo(cell.contentView.mas_left).offset(0);
                    make.right.mas_equalTo(cell.contentView.mas_right).offset(0);
                    make.top.mas_equalTo(cell.contentView.mas_top).offset(0);
                }];
                [cell.contentView addSubview:self.scene];
                [self.scene mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(SCREEN_WIDTH);
                    make.left.mas_equalTo(cell.contentView.mas_left).offset(0);
                    make.right.mas_equalTo(cell.contentView.mas_right).offset(0);
                    make.top.mas_equalTo(self.top.mas_bottom).offset(0);
                }];
//                self.top.userModel = self.resultsAry[indexPath.row];
                [self.top thn_setHomeSceneUserInfoData:self.resultsAry[indexPath.row] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
                [self.scene thn_setSceneImageData:self.resultsAry[indexPath.row]];
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    
    UICollectionViewCell *cell;
    return cell;
}

//  点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.senceModelAry[index] setValue:@(1) forKey:@"is_love"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//  取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.senceModelAry[index] setValue:@(0) forKey:@"is_love"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//  关注用户
- (void)beginFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.resultsAry valueForKey:@"user"][index] setValue:@"1" forKey:@"isFollow"];
    [self thn_networkBeginFollowUserData:userId];
}

//  取消关注用户
- (void)cancelFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.resultsAry valueForKey:@"user"][index] setValue:@"0" forKey:@"isFollow"];
    [self thn_networkCancelFollowUserData:userId];
}

//  关注
- (void)thn_networkBeginFollowUserData:(NSString *)idx {
    self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  取消关注
- (void)thn_networkCancelFollowUserData:(NSString *)idx {
    self.cancelFollowRequest = [FBAPI postWithUrlString:URLCancelFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.cancelFollowRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)sceneImageClick:(UIButton*)sender{
    THNSceneImageViewController *sceneImageVC = [[THNSceneImageViewController alloc] init];
    sceneImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    sceneImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    HomeSceneListRow *model = self.resultsAry[sender.tag];
    sceneImageVC.image = model.coverUrl;
    [self presentViewController:sceneImageVC animated:YES completion:nil];
}

-(void)attend{
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    pictureToolVC.actionId = self.model._id;
    pictureToolVC.activeTitle = self.model.title;
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

-(HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        if (self.model.evt == 2) {
            _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"活动规则", @"参与的情境", @"活动结果"]];
        }else{
            _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"活动规则", @"参与的情境"]];
        }
        _segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:fineixColor];
        [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            if (selected) {
                NSAttributedString *seletedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:fineixColor], NSFontAttributeName: [UIFont systemFontOfSize:14]}];
                return seletedTitle;
            }
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#222222"], NSFontAttributeName: [UIFont systemFontOfSize:14]}];
            return attString;
        }];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        if ([self.type isEqualToNumber:@0]) {
            [_segmentedControl setSelectedSegmentIndex:0];
        }else if ([self.type isEqualToNumber:@1]){
            [_segmentedControl setSelectedSegmentIndex:1];
        }else if ([self.type isEqualToNumber:@2]){
            [_segmentedControl setSelectedSegmentIndex:2];
        }
    }
    return _segmentedControl;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger flag = [self.type integerValue];
    if (indexPath.section == 2) {
        switch (flag) {
            case 0:
                //活动规则
            {
            }
                break;
            case 1:
                //参与的情境
            {
                THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
                THNDiscoverSceneCollectionViewCell *cell = (THNDiscoverSceneCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                vc.sceneDetalId = cell.model._id;
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case 2:
                //活动结果
            {
  
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.type = [NSNumber numberWithInteger:segmentedControl.selectedSegmentIndex ];
    NSInteger flag = [self.type integerValue];
    switch (flag) {
        case 0:
            //活动规则网络请求
        {
            
            [self ruleRequest];
        }
            break;
        case 1:
            //参与的情境网络请求
        {
            self.contentView.mj_footer.hidden = NO;
            [self setUpRefresh];
        }
            
            break;
        case 2:
            //活动结果网络请求
        {
            
            [self resultRequest];
        }
            break;
            
        default:
            break;
    }
}

-(void)resultRequest{
    
    [self.resultsAry removeAllObjects];
    NSDictionary *params = @{
                             @"id" : self.activeDetalId
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"活动结果 %@",result);
            NSArray *rows = result[@"data"][@"sights"];
            self.resultsAry = [HomeSceneListRow mj_objectArrayWithKeyValuesArray:rows];
            for (HomeSceneListRow *model in self.resultsAry) {
                [self.resultUserIdAry addObject:model.user._id];
            }

            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            self.contentView.mj_footer.hidden = YES;
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
        }
    } failure:nil];
}

-(void)setUpRefresh{
    [self senceRequest];
    
    self.contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadMore{
    NSDictionary *params = @{
                             @"page" : @(++self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.activeDetalId
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            NSArray *ary = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            [self.senceModelAry addObjectsFromArray:ary];
            for (THNSenceModel *model in self.senceModelAry) {
                [self.sceneIdMarr addObject:model._id];
            }
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}


-(void)senceRequest{
    self.current_page = 1;
    [self.senceModelAry removeAllObjects];
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.activeDetalId
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"参与的情境 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            self.senceModelAry = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            for (THNSenceModel *model in self.senceModelAry) {
                [self.sceneIdMarr addObject:model._id];
            }
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
//            [self.myCollectionView.mj_header endRefreshing];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}

-(void)checkFooterState{
    self.contentView.mj_footer.hidden = self.senceModelAry.count == 0;
    if (self.senceModelAry.count == self.total_rows) {
        self.contentView.mj_footer.hidden = YES;
    }else{
        [self.contentView.mj_footer endRefreshing];
    }
}

-(void)ruleRequest{
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.activeDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"活动规则  %@",result);
            BOOL flag = NO;
            self.ruleModel = [THNActiveRuleModel mj_objectWithKeyValues:result[@"data"]];
            self.model = [THNArticleModel mj_objectWithKeyValues:result[@"data"]];
            [self.view addSubview:self.contentView];
            if (flag == NO) {
                self.activeTopView.model = self.model;
                flag = YES;
            }
            [self.contentView reloadData];
            self.contentView.mj_footer.hidden = YES;
        }else{
        }
    } failure:nil];
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    self.webViewHeghit = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    NSLog(@"网页高度 %f",self.webViewHeghit);
    self.webViewLoads = 1;
    [self.contentView reloadData];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
}

@end
