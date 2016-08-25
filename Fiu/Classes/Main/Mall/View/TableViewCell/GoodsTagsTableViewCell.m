//
//  GoodsTagsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/6/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsTagsTableViewCell.h"
#import "ChooseTagsCollectionViewCell.h"
#import "SearchViewController.h"

@implementation GoodsTagsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.chooseTagView];
        UILabel * botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 5)];
        botLine.backgroundColor = [UIColor colorWithHexString:cellBgColor];
        [self addSubview:botLine];
        
    }
    return self;
}

#pragma mark -
- (void)setGoodsTagsTitleData:(NSArray *)model {
    self.chooseTagMarr = [NSMutableArray arrayWithArray:model];
    [self.chooseTagView reloadData];
}

#pragma mark - 标签列表
- (UICollectionView *)chooseTagView {
    if (!_chooseTagView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _chooseTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) collectionViewLayout:flowLayout];
        _chooseTagView.backgroundColor = [UIColor whiteColor];
        _chooseTagView.delegate = self;
        _chooseTagView.dataSource = self;
        _chooseTagView.showsHorizontalScrollIndicator = NO;
        [_chooseTagView registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
    }
    return _chooseTagView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chooseTagMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
    [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(tagW + 30, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    [self.nav pushViewController:searchVC animated:YES];
}


@end
