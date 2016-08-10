//
//  HomeThemeTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeThemeTableViewCell.h"
#import "HomeThemeCollectionViewCell.h"

static NSString *const themeCollectionCellID = @"ThemeCollectionCellID";

@implementation HomeThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.themeCollectionView];
    }
    return self;
}

- (UICollectionView *)themeCollectionView {
    if (!_themeCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _themeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)
                                                  collectionViewLayout:flowLayout];
        _themeCollectionView.backgroundColor = [UIColor whiteColor];
        _themeCollectionView.delegate = self;
        _themeCollectionView.dataSource = self;
        _themeCollectionView.showsHorizontalScrollIndicator = NO;
        [_themeCollectionView registerClass:[HomeThemeCollectionViewCell class]
                 forCellWithReuseIdentifier:themeCollectionCellID];
    }
    return _themeCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return CGSizeMake(50, 70);
    } else
        return CGSizeMake(160, 70);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeThemeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:themeCollectionCellID
                                                                                   forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

@end
