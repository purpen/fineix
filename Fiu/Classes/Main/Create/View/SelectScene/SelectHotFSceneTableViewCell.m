//
//  SelectHotFSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectHotFSceneTableViewCell.h"
#import "SelectAllFSceneCollectionViewCell.h"
#import "FiuSceneInfoData.h"

@implementation SelectHotFSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dataMarr = [NSMutableArray array];
        [self addSubview:self.allSceneView];
        
    }
    return self;
}

- (void)setSelectHotFSceneData:(NSMutableArray *)data {
    self.dataMarr = data;
    
    if (data.count%2 > 0) {
        CGFloat viewH = ((SCREEN_WIDTH - 15)/2 * 1.77) * (data.count/2) + ((SCREEN_WIDTH - 15)/2 * 1.77);
        self.allSceneView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewH + 20);
    } else {
        CGFloat viewH = ((SCREEN_WIDTH - 15)/2 * 1.77) * (data.count/2);
        self.allSceneView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewH + 20);
    }
    
    [self.allSceneView reloadData];
}

- (void)getCellHeiht:(NSMutableArray *)marr {
    if (marr.count%2 > 0) {
        self.cellHeight = ((SCREEN_WIDTH - 15)/2 * 1.77) * (marr.count/2) + ((SCREEN_WIDTH - 15)/2 * 1.77);
    } else {
        self.cellHeight = ((SCREEN_WIDTH - 15)/2 * 1.77) * (marr.count/2);
    }
}

#pragma mark - 情景列表
- (UICollectionView *)allSceneView {
    if (!_allSceneView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _allSceneView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _allSceneView.delegate = self;
        _allSceneView.dataSource = self;
        _allSceneView.backgroundColor = [UIColor whiteColor];
        _allSceneView.showsVerticalScrollIndicator = NO;
        _allSceneView.showsHorizontalScrollIndicator = NO;
        _allSceneView.scrollEnabled = NO;
        [_allSceneView registerClass:[SelectAllFSceneCollectionViewCell class] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
        
    }
    return _allSceneView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
    SelectAllFSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setAllFiuSceneListData:self.dataMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //  to:  "SelectSceneViewController.h"
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getSelectId" object:[NSString stringWithFormat:@"%zi", indexPath.row]];
}


@end
