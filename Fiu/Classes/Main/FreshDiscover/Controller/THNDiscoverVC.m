//
//  THNDiscoverVC.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDiscoverVC.h"
#import "QRCodeScanViewController.h"
#import "SearchViewController.h"
#import "LeftTableViewCell.h"
#import "LJCollectionViewFlowLayout.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeaderView.h"
#import "NSObject+Property.h"
#import "THNClassificationModel.h"
#import "CollectionCategoryModel.h"
#import "THNRommendCollectionViewCell.h"
#import "THNSortCollectionViewCell.h"
#import "THNDiPanZhuanTiCollectionViewCell.h"
#import "THNQingJingFenLeiCollectionViewCell.h"
#import "THNCategoryViewController.h"
#import "THNDomainInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNBrandInfoViewController.h"
#import "THNYaoQingHaoYouCollectionViewCell.h"
#import "HomePageViewController.h"
#import "THNNewSortCollectionViewCell.h"
#import "THNFindFriendTableViewCell.h"
#import "THNQingjingCollectionViewCell.h"
#import "UIView+FSExtension.h"
#import "THNQingJingZhuanTiViewController.h"

@interface THNDiscoverVC ()<
THNNavigationBarItemsDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) NSMutableArray *collectionDatas;

@end

@implementation THNDiscoverVC
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
    BOOL _isFirst;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
    _isFirst = YES;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addNavLogoImage];
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
    [self thn_addBarItemRightBarButton:@"" image:@"shouye_search"];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.index = 0;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"discoverLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"discoverLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"faxian_tianjia",@"faxian_paihangbang"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    NSArray *ary = @[@"为你推荐", @"分类", @"地盘", @"情境", @"品牌",@"好货合集",@"发现好友"];
    for (int i = 0; i < ary.count; i ++) {
        THNClassificationModel *model = [THNClassificationModel new];
        model.name = ary[i];
        [self.tableViewDataSource addObject:model];
    }
    
    FBRequest *request = [FBAPI postWithUrlString:@"/gateway/find" requestDictionary:@{} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        
        NSDictionary *stickDict = dataDict[@"stick"];
        StickModel *stickModel = [StickModel mj_objectWithKeyValues:stickDict];
        [self.collectionDatas addObject:stickModel];
        
        NSArray *pro_categoryAry = dataDict[@"pro_category"];
        NSArray *categorys = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:pro_categoryAry];
        [self.collectionDatas addObject:categorys];

        NSDictionary *sceneDict = dataDict[@"scene"];
        NSArray *stickAry = sceneDict[@"stick"];
        NSArray *sticks = [StickModel mj_objectArrayWithKeyValuesArray:stickAry];
        [self.collectionDatas addObject:sticks];
        
        NSArray *categoryAry = sceneDict[@"category"];
        NSArray *categoryss = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:categoryAry];
        [self.collectionDatas addObject:categoryss];
        
        NSDictionary *sightDict = dataDict[@"sight"];
        NSArray *stickAryy = sightDict[@"stick"];
        NSArray *stickss = [StickModel mj_objectArrayWithKeyValuesArray:stickAryy];
        [self.collectionDatas addObject:stickss];
        
        NSArray *categoryAryy = sightDict[@"category"];
        NSArray *categorysss = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:categoryAryy];
        [self.collectionDatas addObject:categorysss];
        
        NSArray *brandAry = dataDict[@"brand"];
        NSArray *brands = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:brandAry];
        [self.collectionDatas addObject:brands];
        
        NSArray *product_subjectAry = dataDict[@"product_subject"];
        NSArray *product_subjects = [StickModel mj_objectArrayWithKeyValuesArray:product_subjectAry];
        [self.collectionDatas addObject:product_subjects];
        
        NSArray *userAry = dataDict[@"users"];
        NSArray *users = [UsersModel mj_objectArrayWithKeyValuesArray:userAry];
        [self.collectionDatas addObject:users];
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
    }];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

}


-(NSMutableArray *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSMutableArray array];
    }
    return _tableViewDataSource;
}


- (NSMutableArray *)collectionDatas
{
    if (!_collectionDatas)
    {
        _collectionDatas = [NSMutableArray array];
    }
    return _collectionDatas;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 2;
        //上下间距
        flowlayout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 + 90, 64, SCREEN_WIDTH - 90 - 4, SCREEN_HEIGHT - 64 - 49) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
        [_collectionView registerClass:[THNRommendCollectionViewCell class] forCellWithReuseIdentifier:THNRECOmmendCollectionViewCell];
        [_collectionView registerClass:[THNSortCollectionViewCell class] forCellWithReuseIdentifier:THNSORTCollectionViewCell];
        [_collectionView registerClass:[THNNewSortCollectionViewCell class] forCellWithReuseIdentifier:THNNEWSortCollectionViewCell];
        [_collectionView registerClass:[THNDiPanZhuanTiCollectionViewCell class] forCellWithReuseIdentifier:THNDIPANZhuanTiCollectionViewCell];
        [_collectionView registerClass:[THNQingJingFenLeiCollectionViewCell class] forCellWithReuseIdentifier:THNQINGJingFenLeiCollectionViewCell];
        [_collectionView registerClass:[THNYaoQingHaoYouCollectionViewCell class] forCellWithReuseIdentifier:THNYAOQingHaoYouCollectionViewCell];
        [_collectionView registerClass:[THNFindFriendTableViewCell class] forCellWithReuseIdentifier:THNFINDFriendTableViewCell];
        [_collectionView registerClass:[THNQingjingCollectionViewCell class] forCellWithReuseIdentifier:THNQINGjingCollectionViewCell];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 90, SCREEN_HEIGHT - 64 - 49)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor whiteColor];
        [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_tableView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(_tableView).mas_offset(0);
            make.width.mas_equalTo(0.5);
        }];
    }
    return _tableView;
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    THNClassificationModel *model = self.tableViewDataSource[indexPath.row];
    cell.name.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tableViewDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.collectionDatas.count == 0) {
        return 0;
    }
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        NSArray *ary = self.collectionDatas[1];
        return ary.count;
    } else if (section == 2) {
//        NSArray *ary = self.collectionDatas[2];
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        NSArray *ary = self.collectionDatas[6];
        return ary.count;
    } else if (section == 5) {
        NSArray *ary = self.collectionDatas[7];
        return ary.count;
    } else if (section == 6) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        THNRommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNRECOmmendCollectionViewCell forIndexPath:indexPath];
        StickModel *model = self.collectionDatas[0];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 1) {
        THNNewSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNNEWSortCollectionViewCell forIndexPath:indexPath];
        NSArray *ary = self.collectionDatas[1];
        Pro_categoryModel *model = ary[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row <= 1) {
            THNDiPanZhuanTiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIPANZhuanTiCollectionViewCell forIndexPath:indexPath];
            NSArray *ary = self.collectionDatas[2];
            StickModel *model = ary[indexPath.row];
            cell.model = model;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            return cell;
        } else {
            THNSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNSORTCollectionViewCell forIndexPath:indexPath];
            NSArray *ary = self.collectionDatas[3];
            Pro_categoryModel *model = ary[indexPath.row - 2];
            cell.model = model;
            return cell;   
        }
    } else if (indexPath.section == 3) {
        NSMutableArray *ary1 = [NSMutableArray array];
        [ary1 addObjectsFromArray:self.collectionDatas[4]];
        [ary1 addObjectsFromArray:self.collectionDatas[5]];
        NSArray *ary = [NSArray arrayWithArray:ary1];
        THNQingjingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNQINGjingCollectionViewCell forIndexPath:indexPath];
        cell.modelAry = ary;
        cell.nav = self.navigationController;
        return cell;
    } else if (indexPath.section == 4) {
        THNSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNSORTCollectionViewCell forIndexPath:indexPath];
        NSArray *ary = self.collectionDatas[6];
        Pro_categoryModel *model = ary[indexPath.row];
        cell.pModel = model;
        return cell;
    } else if (indexPath.section == 5) {
        THNDiPanZhuanTiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIPANZhuanTiCollectionViewCell forIndexPath:indexPath];
        NSArray *ary = self.collectionDatas[7];
        StickModel *model = ary[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 6) {
        THNFindFriendTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNFINDFriendTableViewCell forIndexPath:indexPath];
        return cell;
    }
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 18*SCREEN_HEIGHT/667.0, 0, 18*SCREEN_HEIGHT/667.0);
    } else if (section == 2) {
        return UIEdgeInsetsMake(0, (self.collectionView.width-120*SCREEN_HEIGHT/667.0)/2, 0, (self.collectionView.width-120*SCREEN_HEIGHT/667.0)/2);
    } else if (section == 4) {
        return UIEdgeInsetsMake(0, 18*SCREEN_HEIGHT/667.0, 0, 18*SCREEN_HEIGHT/667.0);
    } else if (section == 5) {
        return UIEdgeInsetsMake(0, 18*SCREEN_HEIGHT/667.0, 14, 18*SCREEN_HEIGHT/667.0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 18*SCREEN_HEIGHT/667.0;
    }
    if (section == 1) {
        return 18*SCREEN_HEIGHT/667.0;
    } else if (section == 2) {
        return 18*SCREEN_HEIGHT/667.0;
    } else if (section == 4) {
        return 18*SCREEN_HEIGHT/667.0;
    } else if (section == 5) {
        return 3*SCREEN_HEIGHT/667.0;
    }
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 5) {
        return 3*SCREEN_HEIGHT/667.0;
    }
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StickModel *model = self.collectionDatas[0];
        [self thn_tiaoZhuanLanMuWeiWithType:[model.type integerValue] andId:model.web_url andDelegate:self andNav:self.navigationController];
    } else if (indexPath.section == 1) {
        NSArray *ary = self.collectionDatas[1];
        Pro_categoryModel *model = ary[indexPath.row];
        THNCategoryViewController *mallCategoryVC = [[THNCategoryViewController alloc] init];
        mallCategoryVC.vcTitle = model.title;
        mallCategoryVC.categoryId = model._id;
        [self.navigationController pushViewController:mallCategoryVC animated:YES];
    } else if (indexPath.section == 2) {
        NSArray *ary = self.collectionDatas[2];
        StickModel *model = ary[indexPath.row];
        THNDomainInfoViewController *domainInfoVC = [[THNDomainInfoViewController alloc] init];
        domainInfoVC.infoId = model.web_url;
        [self.navigationController pushViewController:domainInfoVC animated:YES];
    } else if (indexPath.section == 4) {
        NSArray *ary = self.collectionDatas[5];
        THNBrandInfoViewController *vc = [[THNBrandInfoViewController alloc] init];
        Pro_categoryModel *model = ary[indexPath.row];
        vc.brandId = model._id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 5) {
        //专辑
        NSArray *ary = self.collectionDatas[7];
        StickModel *model = ary[indexPath.row];
        [self thn_tiaoZhuanLanMuWeiWithType:11 andId:model.web_url andDelegate:self andNav:self.navigationController];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(531.4/2*SCREEN_HEIGHT/667.0,
                          299/2*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 1) {
        return CGSizeMake(60*SCREEN_HEIGHT/667.0,
                          80*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 2) {
        if (indexPath.row <= 1) {
            return CGSizeMake(531.4/2*SCREEN_HEIGHT/667.0,
                              299/2*SCREEN_HEIGHT/667.0);
        } else {
            return CGSizeMake(60*SCREEN_HEIGHT/667.0,
                              100*SCREEN_HEIGHT/667.0);
        }
    } else if (indexPath.section == 3) {
        NSMutableArray *ary1 = [NSMutableArray array];
        [ary1 addObjectsFromArray:self.collectionDatas[4]];
        [ary1 addObjectsFromArray:self.collectionDatas[5]];
        NSInteger n = 0;
        if ((ary1.count - ary1.count/3*3)>0) {
            n = ary1.count/3+1;
        } else {
            n = ary1.count/3;
        }
        return CGSizeMake(SCREEN_WIDTH - 80, (135/2+n*(60+20))*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 4) {
        return CGSizeMake(60*SCREEN_HEIGHT/667.0,
                          100*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 5) {
        return CGSizeMake(120*SCREEN_HEIGHT/667.0, 135/2.0*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 6) {
        return CGSizeMake(SCREEN_WIDTH-80,
                          535/2*SCREEN_HEIGHT/667.0);
    }
    return CGSizeMake(((SCREEN_WIDTH - 80 - 4 - 4) / 3)*SCREEN_HEIGHT/667.0,
                      ((SCREEN_WIDTH - 80 - 4 - 4) / 3 + 30)*SCREEN_HEIGHT/667.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        THNClassificationModel *model = self.tableViewDataSource[indexPath.section];
        view.title.text = model.name;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50*SCREEN_HEIGHT/667.0);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
    if (_isFirst) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        _isFirst = NO;
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    if (index > 6) {
        return;
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
