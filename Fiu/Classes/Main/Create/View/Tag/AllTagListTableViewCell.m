//
//  AllTagListTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllTagListTableViewCell.h"
#import "UsedTagCollectionViewCell.h"
#import "TagFlowLayout.h"

@implementation AllTagListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tagListData = [NSMutableArray array];
        self.titleData = [NSMutableArray array];
        self.tagIdData = [NSMutableArray array];
        [self setCellUI];
        
    }
    return self;
}

#pragma mark - 
- (void)setAllTagListData:(NSString *)title withTagList:(NSMutableArray *)tagList withTagId:(NSMutableArray *)tagId {
    self.titleLab.text = title;
    self.tagListData = tagList;
    self.tagIdData = tagId;
    [self.tagListView reloadData];
}

#pragma mark - 
- (void)setCellUI {
    [self addSubview:self.titleLab];
    
    [self addSubview:self.tagListView];
}

#pragma mark - 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 20)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _titleLab;
}

#pragma mark - 标签列表
- (UICollectionView *)tagListView {
    if (!_tagListView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        
        _tagListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 68) collectionViewLayout:flowLayout];
        _tagListView.delegate = self;
        _tagListView.dataSource = self;
        _tagListView.backgroundColor = [UIColor whiteColor];
        _tagListView.showsVerticalScrollIndicator = NO;
        _tagListView.scrollEnabled = NO;
        [_tagListView registerClass:[UsedTagCollectionViewCell class] forCellWithReuseIdentifier:@"AllTagCollectionViewCell"];

    }
    return _tagListView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagListData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UsedTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllTagCollectionViewCell" forIndexPath:indexPath];
    cell.tagLab.text = self.tagListData[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagW = [self.tagListData[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    
    return CGSizeMake(tagW + 35, 29);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.getTagDataBlock(self.tagListData[indexPath.row], self.tagIdData[indexPath.row]);
}

@end
