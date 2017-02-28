//
//  THNQingjingCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQingjingCollectionViewCell.h"
#import "Fiu.h"
#import "THNDiPanZhuanTiCollectionViewCell.h"
#import "THNQingJingFenLeiCollectionViewCell.h"
#import "THNSceneDetalViewController.h"
#import "CollectionCategoryModel.h"
#import "THNViewController.h"
#import "DiscoverCategoryViewController.h"

@interface THNQingjingCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation THNQingjingCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 15.0f;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
        self.collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        }];
        [_collectionView registerClass:[THNDiPanZhuanTiCollectionViewCell class] forCellWithReuseIdentifier:THNDIPANZhuanTiCollectionViewCell];
        [_collectionView registerClass:[THNQingJingFenLeiCollectionViewCell class] forCellWithReuseIdentifier:THNQINGJingFenLeiCollectionViewCell];
    }
    return self;
}

-(void)setModelAry:(NSArray *)modelAry{
    _modelAry = modelAry;
    [self.collectionView reloadData];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsMake(20*SCREEN_HEIGHT/667.0, 25*SCREEN_HEIGHT/667.0, 0, 25*SCREEN_HEIGHT/667.0);
    } else if (section == 0) {
        return UIEdgeInsetsMake(0, 25*SCREEN_HEIGHT/667.0, 0, 25*SCREEN_HEIGHT/667.0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else {
        return self.modelAry.count - 2;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(120*SCREEN_HEIGHT/667.0, 135/2.0*SCREEN_HEIGHT/667.0);
    } else if (indexPath.section == 1) {
        return CGSizeMake(60*SCREEN_HEIGHT/667.0,
                          60*SCREEN_HEIGHT/667.0);
    }
    return CGSizeMake(((SCREEN_WIDTH - 80 - 4 - 4) / 3)*SCREEN_HEIGHT/667.0,
                      ((SCREEN_WIDTH - 80 - 4 - 4) / 3 + 30)*SCREEN_HEIGHT/667.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 18*SCREEN_HEIGHT/667.0;
    } else if (section == 0) {
        return 3*SCREEN_HEIGHT/667.0;
    }
    return 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        THNDiPanZhuanTiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNDIPANZhuanTiCollectionViewCell forIndexPath:indexPath];
        StickModel *model = self.modelAry[indexPath.row];
        cell.model = model;
        return cell;
    }
    THNQingJingFenLeiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THNQINGJingFenLeiCollectionViewCell forIndexPath:indexPath];
    Pro_categoryModel *model = self.modelAry[indexPath.row + 2];
    cell.pModel = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StickModel *model = self.modelAry[indexPath.row];
        THNViewController *vc1 = [[THNViewController alloc] init];
        NSLog(@"sdsadasbdasdbsab  %@",model.web_url);
        [vc1 thn_tiaoZhuanLanMuWeiWithType:[model.type integerValue] andId:model.web_url andDelegate:self andNav:self.nav];
    } else {
        Pro_categoryModel *model = self.modelAry[indexPath.row+2];
        DiscoverCategoryViewController *categoryVC = [[DiscoverCategoryViewController alloc] init];
        categoryVC.vcTitle = model.title;
        categoryVC.categoryId = model._id;
        [self.nav pushViewController:categoryVC animated:YES];
    }
}

@end
