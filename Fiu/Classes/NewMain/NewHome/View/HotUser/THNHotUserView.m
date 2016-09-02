//
//  THNHotUserView.m
//  Fiu
//
//  Created by FLYang on 16/9/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHotUserView.h"
#import "THNHotUserCollectionViewCell.h"
#import "HomePageViewController.h"

static NSString *const hotUserCellId = @"HotUserCellId";

@interface THNHotUserView () {
    NSInteger _index;
}

@end

@implementation THNHotUserView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:@"#444444"];
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[THNHotUserCollectionViewCell class] forCellWithReuseIdentifier:hotUserCellId];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotUserMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNHotUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotUserCellId forIndexPath:indexPath];
    if (self.hotUserMarr.count) {
        [cell setHotUserListData:self.hotUserMarr[indexPath.row]];
        __weak __typeof(self)weakSelf = self;
        cell.colseTheHotUserBlock = ^(NSString *userId) {
            [weakSelf removeTheHotUserInfo:userId];
        };
        
        cell.followHotUserBlock = ^(NSString *userId) {
            [weakSelf changeHotUserFollow:userId];
        };
        
        cell.cancelFollowHotUserBlock = ^(NSString *userId) {
            [weakSelf changeHotUserCancelFollow:userId];
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = self.hotUserIdMarr[indexPath.row];
    userHomeVC.type = @2;
    [self.nav pushViewController:userHomeVC animated:YES];
}

- (void)removeTheHotUserInfo:(NSString *)userId {
    _index = [self.hotUserIdMarr indexOfObject:userId];
    [self.hotUserMarr removeObjectAtIndex:_index];
    [self.hotUserIdMarr removeObjectAtIndex:_index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_index inSection:0];
    [self deleteItemsAtIndexPaths:@[indexPath]];
    
    if (self.hotUserMarr.count == 0) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotUserListData" object:nil];
    }
}

- (void)changeHotUserFollow:(NSString *)userId {
    _index = [self.hotUserIdMarr indexOfObject:userId];
    [self.hotUserMarr[_index] setValue:@"1" forKey:@"isFollow"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"followHotUser" object:userId];
}

- (void)changeHotUserCancelFollow:(NSString *)userId {
    _index = [self.hotUserIdMarr indexOfObject:userId];
    [self.hotUserMarr[_index] setValue:@"0" forKey:@"isFollow"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelFollowHotUser" object:userId];
}

- (void)thn_setHotUserListData:(NSMutableArray *)hotUserMarr {
    [self.hotUserIdMarr removeAllObjects];
    self.hotUserMarr = hotUserMarr;
    for (HotUserListUser *model in hotUserMarr) {
        [self.hotUserIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    }
    [self reloadData];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)hotUserMarr {
    if (!_hotUserMarr) {
        _hotUserMarr = [NSMutableArray array];
    }
    return _hotUserMarr;
}

- (NSMutableArray *)hotUserIdMarr {
    if (!_hotUserIdMarr) {
        _hotUserIdMarr = [NSMutableArray array];
    }
    return _hotUserIdMarr;
}

@end
