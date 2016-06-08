//
//  ContentAndTagTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ContentAndTagTableViewCell.h"
#import "SearchViewController.h"
#import "ChooseTagsCollectionViewCell.h"

@implementation ContentAndTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellViewUI];
        
    }
    return self;
}

#pragma mark -
- (void)setFiuSceneDescription:(FiuSceneInfoData *)model {
    [self changeContentLabStyle:model.des];
    self.chooseTagMarr = [NSMutableArray arrayWithArray:model.tagTitles];
    [self.chooseTagView reloadData];
}

- (void)setSceneDescription:(SceneInfoData *)model {
    [self changeContentLabStyle:model.des];
    self.chooseTagMarr = [NSMutableArray arrayWithArray:model.tagTitles];
    [self.chooseTagView reloadData];
}

#pragma mark - 创建视图UI
- (void)setCellViewUI {
    [self.contentView addSubview:self.contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 15));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self.contentView addSubview:self.chooseTagView];
    [_chooseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.top.equalTo(_contentLab.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
}

#pragma mark - 描述内容文字
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        _contentLab.font = [UIFont systemFontOfSize:Font_Content];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

//  内容文字的样式
- (void)changeContentLabStyle:(NSString *)str {
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    self.contentLab.attributedText = contentText;
    
    CGSize size = [_contentLab boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width , size.height + 20));
    }];
}

//  计算内容高度
- (void)getContentCellHeight:(NSString *)content {
    _contentLab.text = content;
    CGSize size = [_contentLab boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    self.cellHeight = size.height + 70;
}

#pragma mark - 标签列表
- (UICollectionView *)chooseTagView {
    if (!_chooseTagView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _chooseTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20) collectionViewLayout:flowLayout];
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
    searchVC.keyword = self.chooseTagMarr[indexPath.row];
    searchVC.searchType = 0;
    [self.nav pushViewController:searchVC animated:YES];
}

@end
