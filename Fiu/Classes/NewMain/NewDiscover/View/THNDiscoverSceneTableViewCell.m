//
//  THNDiscoverSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverSceneTableViewCell.h"
#import "THNDiscoverSceneCollectionViewCell.h"

static NSString *const SceneListCellId = @"sceneListCellId";

@interface THNDiscoverSceneTableViewCell ()

@pro_strong NSMutableArray *imageMarr;

@end

@implementation THNDiscoverSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)userModel {
    [self.imageMarr addObject:userModel.coverUrl];
    [self.sceneList reloadData];
}

#pragma mark - setCellUI
- (void)setCellUI {
    [self addSubview:self.sceneList];
}

#pragma mark - init
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ((SCREEN_WIDTH - 45)/2)*1.21)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsHorizontalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor whiteColor];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
    }
    return _sceneList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                   forIndexPath:indexPath];
    if (_imageMarr.count) {
        [cell thn_setSceneData:self.imageMarr[indexPath.row]];
    }
    return cell;
}

#pragma mark - NSMutableArray
- (NSMutableArray *)imageMarr {
    if (!_imageMarr) {
        _imageMarr = [NSMutableArray array];
    }
    return _imageMarr;
}

@end
