//
//  MallMenuTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallMenuTableViewCell.h"
#import "MallMenuCollectionViewCell.h"
#import "GoodsCategoryViewController.h"

@implementation MallMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleMarr = [NSMutableArray array];
        self.idMarr = [NSMutableArray array];
        self.tagTitleMarr = [NSMutableArray array];
        self.tagIdMarr = [NSMutableArray array];
        
        [self addSubview:self.menuView];
    }
    return self;
}

#pragma mark -
- (void)setCategoryData:(NSMutableArray *)category {
    for (CategoryRow * row in category) {
        [self.titleMarr addObject:row];
        [self.idMarr addObject:[NSString stringWithFormat:@"%zi", row.idField]];
        
        self.tagTitleMarr = [[self.titleMarr valueForKey:@"sceneTags"] valueForKey:@"titleCn"];
        self.tagIdMarr = [[self.titleMarr valueForKey:@"sceneTags"] valueForKey:@"idField"];
        
    }
    [self.menuView reloadData];
}

#pragma mark - 滑动列表
- (UICollectionView *)menuView {
    if (!_menuView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(60, 105);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105) collectionViewLayout:flowLayout];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.showsVerticalScrollIndicator = NO;
        _menuView.showsHorizontalScrollIndicator = NO;
        [_menuView registerClass:[MallMenuCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _menuView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    MallMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setCategoryData:self.titleMarr[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * titleMarr = [NSMutableArray arrayWithArray:[self.titleMarr valueForKey:@"title"]];
    [titleMarr insertObject:@"全部" atIndex:0];
    
    GoodsCategoryViewController * goodsCategoryVC = [[GoodsCategoryViewController alloc] init];
    //  分类标题&id
    goodsCategoryVC.categoryTitleArr = titleMarr;
    goodsCategoryVC.categoryId = self.idMarr[indexPath.row];
    //  分类标签标题&id
    goodsCategoryVC.tagTitleArr = self.tagTitleMarr[indexPath.row];
    goodsCategoryVC.categoryTagId = self.tagIdMarr[indexPath.row];
    //  更新菜单按钮位置
    [goodsCategoryVC.categoryMenuView updateMenuBtnState:indexPath.row + 1];
    [goodsCategoryVC.goodsCategoryView changeContentOffSet:indexPath.row + 1];
    
    [self.nav pushViewController:goodsCategoryVC animated:YES];
}


@end
