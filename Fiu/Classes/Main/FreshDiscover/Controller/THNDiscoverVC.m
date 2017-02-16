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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
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
    
    NSArray *ary = @[@"为你推荐", @"分类", @"地盘", @"情境", @"品牌",@"发现好友"];
    for (int i = 0; i < 5; i ++) {
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
        
        NSArray *pro_categoryAry = result[@"pro_category"];
        NSArray *categorys = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:pro_categoryAry];
        [self.collectionDatas addObject:categorys];
        
        NSDictionary *sceneDict = result[@"scene"];
        NSArray *stickAry = sceneDict[@"stick"];
        NSArray *sticks = [StickModel mj_objectArrayWithKeyValuesArray:stickAry];
        [self.collectionDatas addObject:sticks];
        
        NSArray *categoryAry = sceneDict[@"category"];
        NSArray *categoryss = [StickModel mj_objectArrayWithKeyValuesArray:categoryAry];
        [self.collectionDatas addObject:categoryss];
        
        NSDictionary *sightDict = result[@"sight"];
        NSArray *stickAryy = sightDict[@"stick"];
        NSArray *stickss = [StickModel mj_objectArrayWithKeyValuesArray:stickAryy];
        [self.collectionDatas addObject:stickss];
        
        NSArray *categoryAryy = sceneDict[@"category"];
        NSArray *categorysss = [StickModel mj_objectArrayWithKeyValuesArray:categoryAryy];
        [self.collectionDatas addObject:categorysss];
        
        NSArray *userAry = result[@"users"];
        NSArray *users = [Pro_categoryModel mj_objectArrayWithKeyValuesArray:userAry];
        [self.collectionDatas addObject:users];
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    NSArray *categories = dict[@"data"][@"categories"];
//    for (NSDictionary *dict in categories)
//    {
//        CollectionCategoryModel *model =
//        [CollectionCategoryModel objectWithDictionary:dict];
//        [self.dataSource addObject:model];
//        
//        NSMutableArray *datas = [NSMutableArray array];
//        for (SubCategoryModel *sModel in model.subcategories)
//        {
//            [datas addObject:sModel];
//        }
//        [self.collectionDatas addObject:datas];
//    }
    
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
        LJCollectionViewFlowLayout *flowlayout = [[LJCollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 2;
        //上下间距
        flowlayout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 + 80, 2 + 64, SCREEN_WIDTH - 80 - 4, SCREEN_HEIGHT - 64 - 2 - 49) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 80, SCREEN_HEIGHT - 64 - 49)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
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
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        NSArray *ary = self.collectionDatas[1];
        return ary.count;
    } else if (section == 2) {
        NSArray *ary = self.collectionDatas[2];
        NSArray *ary2 = self.collectionDatas[3];
        return ary.count + ary2.count;
    } else if (section == 3) {
        NSArray *ary = self.collectionDatas[4];
        NSArray *ary2 = self.collectionDatas[5];
        return ary.count + ary2.count;
    } else if (section == 4) {
        NSArray *ary = self.collectionDatas[6];
        return ary.count + 3;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 1;
//    } else if (indexPath.section == 1) {
//        NSArray *ary = self.collectionDatas[1];
//        return ary.count;
//    } else if (indexPath.section == 2) {
//        NSArray *ary = self.collectionDatas[2];
//        NSArray *ary2 = self.collectionDatas[3];
//        return ary.count + ary2.count;
//    } else if (indexPath.section == 3) {
//        NSArray *ary = self.collectionDatas[4];
//        NSArray *ary2 = self.collectionDatas[5];
//        return ary.count + ary2.count;
//    } else if (indexPath.section == 4) {
//        NSArray *ary = self.collectionDatas[6];
//        return ary.count + 3;
//    }
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    SubCategoryModel *model = self.collectionDatas[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 80 - 4 - 4) / 3,
                      (SCREEN_WIDTH - 80 - 4 - 4) / 3 + 30);
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
    return CGSizeMake(SCREEN_WIDTH, 30);
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
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
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
