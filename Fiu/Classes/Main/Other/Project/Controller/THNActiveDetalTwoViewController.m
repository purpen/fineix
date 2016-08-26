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
#import "ClipImageViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "THNSenceModel.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"

@interface THNActiveDetalTwoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

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

@end

static NSString *const topCellId = @"topCellId";
static NSString *const secondCellId = @"secondCellId";
static NSString *const ruleCellId = @"ruleCellId";
static NSString * collectionViewCellId = @"THNDiscoverSceneCollectionViewCell";
static NSString * resultCellId = @"resultCellId";

@implementation THNActiveDetalTwoViewController


-(NSMutableArray *)resultsAry{
    if (!_resultsAry) {
        _resultsAry = [NSMutableArray array];
    }
    return _resultsAry;
}

-(NSMutableArray *)senceModelAry{
    if (!_senceModelAry) {
        _senceModelAry = [NSMutableArray array];
    }
    return _senceModelAry;
}

-(UICollectionView *)contentView{
    if (!_contentView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navViewTitle.text = @"活动详情";
    self.type = @0;
    [self.view addSubview:self.contentView];
    [self ruleRequest];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(THNActiveTopView *)activeTopView{
    if (!_activeTopView) {
        _activeTopView = [THNActiveTopView viewFromXib];
        _activeTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 211);
        _activeTopView.model = self.model;
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
                // 文字的最大尺寸
                CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT);
                // 计算文字的高度
                CGFloat textH = [self.ruleModel.summary boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
                if (textH + 20 + 44 + 211 + 44 + 64 <= SCREEN_HEIGHT) {
                    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 211 - 44);
                }else{
                    return CGSizeMake(SCREEN_WIDTH, textH + 20 + 44);
                }
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
                [cell.attendBtn addTarget:self action:@selector(attend) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                break;
            }
            case 1:
                //参与的情境
            {
                THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
                cell.model = self.senceModelAry[indexPath.row];
                return cell;
            }
                break;
            case 2:
                //活动结果
            {
                _scene = [[THNSceneImageTableViewCell alloc] init];
                _top = [[THNUserInfoTableViewCell alloc] init];
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
                [self.top thn_setHomeSceneUserInfoData:self.resultsAry[indexPath.row]];
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


-(void)attend{
    ClipImageViewController *vc = [[ClipImageViewController alloc] init];
    vc.id = self.model._id;
    vc.activeTitle = self.model.title;
    [self presentViewController:vc animated:YES completion:nil];
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

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.type = [NSNumber numberWithInteger:segmentedControl.selectedSegmentIndex ];
    NSInteger flag = [self.type integerValue];
    switch (flag) {
        case 0:
            //活动规则网络请求
        {
            [self.senceModelAry removeAllObjects];
            [self.resultsAry removeAllObjects];
            [self ruleRequest];
        }
            break;
        case 1:
            //参与的情境网络请求
        {
            [self.senceModelAry removeAllObjects];
            [self.resultsAry removeAllObjects];
            [self senceRequest];
        }
            
            break;
        case 2:
            //活动结果网络请求
        {
            [self.senceModelAry removeAllObjects];
            [self.resultsAry removeAllObjects];
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
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
        }
    } failure:nil];
}

-(void)senceRequest{
//    self.current_page = 1;
    [self.senceModelAry removeAllObjects];
    NSDictionary *params = @{
                             @"page" : @(1),
                             @"size" : @8,
                             @"subject_id" : self.activeDetalId
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"参与的情境 %@",result);
//            self.current_page = [result[@"data"][@"current_page"] integerValue];
//            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            self.senceModelAry = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
//            [self.myCollectionView.mj_header endRefreshing];
//            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
//            [self.myCollectionView.mj_footer endRefreshing];
        }
    } failure:nil];
}

-(void)ruleRequest{
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.activeDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.ruleModel = [THNActiveRuleModel mj_objectWithKeyValues:result[@"data"]];
            [self.contentView reloadData];
        }else{
        }
    } failure:nil];
}

@end
