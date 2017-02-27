//
//  THNSelecteCityViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/14.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNSelecteCityViewController.h"
#import "CityModel.h"
#import "MJExtension.h"
#import "CollectionViewHeaderView.h"
#import "THNCityCollectionViewCell.h"
#import "Fiu.h"

@interface THNSelecteCityViewController () <THNNavigationBarItemsDelegate, UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;

@end

@implementation THNSelecteCityViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 16;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[THNCityCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25/2 + 5, 47/2, 0, 47/2);//分别为上、左、下、右
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.delegate = self;
    self.navViewTitle.hidden = NO;
    self.navViewTitle.text = @"切换城市";
    [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
}

- (void)thn_leftBarItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

-(void)setLocalCity:(NSString *)localCity{
    NSArray *ary = @[@{@"name" : @"北京"}, @{@"name" : @"上海"}];
    self.modelAry = [CityModel mj_objectArrayWithKeyValuesArray:ary];
    [self.collectionView reloadData];
    _localCity = localCity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    THNCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    CityModel *model = self.modelAry[indexPath.row];
    cell.model = model;
    if ([self.localCity isEqualToString:cell.name.text]) {
        cell.name.textColor = [UIColor colorWithHexString:fineixColor];
        cell.bgImageView.image = [UIImage imageNamed:@"selectedCity"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 61 - 47) / 3,
                      40);
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
    CGRect frame = view.frame;
    view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    frame.size.height = 50;
    view.frame = frame;
    CGRect titleFrame = view.title.frame;
    titleFrame.origin.x = -97;
    titleFrame.origin.y = 20;
    view.title.frame = titleFrame;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        view.title.text = @"已开通城市";
        view.leftLineView.hidden = YES;
        view.rightLineView.hidden = YES;
        [view.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(view.mas_centerY).mas_offset(0);
        }];
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CityModel *model = self.modelAry[indexPath.row];
    if ([self.selectedCityDelegate respondsToSelector:@selector(setSelectedCityStr:)]) {
        [self.selectedCityDelegate setSelectedCityStr:model.name];
    }
    THNCityCollectionViewCell *cell = (THNCityCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.name.textColor = [UIColor colorWithHexString:fineixColor];
    cell.bgImageView.image = [UIImage imageNamed:@"selectedCity"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
