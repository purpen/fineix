//
//  FiuSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuSceneTableViewCell.h"
#import "FiuSceneCollectionViewCell.h"
#import "FiuSceneViewController.h"

@interface FiuSceneTableViewCell () {
    
    NSMutableArray      *   _fiuSceneListData;     //  情景Model
    NSMutableArray      *   _fiuSceneIdData;       //  情景Id
}

@end

@implementation FiuSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fiuSceneListData = [NSMutableArray array];
        _fiuSceneIdData = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sceneListView];
    }
    return self;
}

- (void)setFiuSceneList:(NSMutableArray *)dataMarr idMarr:(NSMutableArray *)idMarr {
    _fiuSceneListData = dataMarr;
    _fiuSceneIdData = idMarr;
    [self.sceneListView reloadData];
}

#pragma mark - 情景滑动列表
- (UICollectionView *)sceneListView {
    if (!_sceneListView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(150, 266.5);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 5.0;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _sceneListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266.5) collectionViewLayout:flowLayout];
        _sceneListView.delegate = self;
        _sceneListView.dataSource = self;
        _sceneListView.backgroundColor = [UIColor whiteColor];
        _sceneListView.showsVerticalScrollIndicator = NO;
        _sceneListView.showsHorizontalScrollIndicator = NO;
        [_sceneListView registerClass:[FiuSceneCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _sceneListView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fiuSceneListData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    FiuSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    cell.choose = self.choose;
    [cell setFiuSceneList:_fiuSceneListData[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.choose == NO) {
        FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
        fiuSceneVC.fiuSceneId = _fiuSceneIdData[indexPath.row];
        [self.nav pushViewController:fiuSceneVC animated:YES];
        
    } else if (self.choose == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getSelectFiuId" object:[NSString stringWithFormat:@"%zi", indexPath.row]];
    }
}


@end
