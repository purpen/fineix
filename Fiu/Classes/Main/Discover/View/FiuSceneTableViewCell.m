//
//  FiuSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuSceneTableViewCell.h"
#import "FiuSceneCollectionViewCell.h"

@implementation FiuSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sceneListView];
    }
    return self;
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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    FiuSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setUI];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"打开最Fiu的情景 ＝＝＝＝＝＝＝＝ %zi", indexPath.row);
}


@end
