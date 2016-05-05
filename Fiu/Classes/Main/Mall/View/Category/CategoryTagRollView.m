//
//  CategoryTagRollView.m
//  Fiu
//
//  Created by FLYang on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryTagRollView.h"
#import "ChildTagsCollectionViewCell.h"

@implementation CategoryTagRollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tagCollectionView];
    }
    return self;
}

#pragma mark -
- (void)setTagRollMarr:(NSMutableArray *)model {
    self.titleMarr = [NSMutableArray arrayWithArray:[model valueForKey:@"titleCn"]];
    [self.tagCollectionView reloadData];
}

#pragma mark - 商品分类标签
- (UICollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) collectionViewLayout:flowLayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.showsHorizontalScrollIndicator = NO;
        _tagCollectionView.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        [_tagCollectionView registerClass:[ChildTagsCollectionViewCell class] forCellWithReuseIdentifier:@"TagCollectionViewCell"];
    }
    return _tagCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChildTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    cell.titleLab.text = self.titleMarr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     CGFloat titleW = [[self.titleMarr objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(titleW + 20, 29);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagBtnSelected:)]) {
        [self.delegate tagBtnSelected:(indexPath.row)];
    }

}

@end
