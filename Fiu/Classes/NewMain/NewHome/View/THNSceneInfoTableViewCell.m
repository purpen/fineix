//
//  THNSceneInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneInfoTableViewCell.h"
#import "THNSceneTagsCollectionViewCell.h"
#import "UILable+Frame.h"

static NSString *const sceneTagsCellId = @"SceneTagsCellId";

@interface THNSceneInfoTableViewCell () {
    NSMutableArray *_tagsMarr;
}

@end

@implementation THNSceneInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel
- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel {
    [self changeLineSpacing:contentModel.des forLable:self.content];
    CGSize size = [_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)];
    if (((size.height * 1.2) + 40) < 100) {
        self.defaultCellHigh = (size.height * 1.2) + 40;
    } else {
        self.defaultCellHigh = 100;
    }
    self.cellHigh = (size.height * 1.2) + 40;
    
    _tagsMarr = [NSMutableArray arrayWithArray:contentModel.tags];
    [self.tags reloadData];
}

- (void)changeLineSpacing:(NSString *)text forLable:(UILabel *)lable {
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *textDict = @{NSParagraphStyleAttributeName:paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    lable.attributedText = contentText;
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.graybackView];
    [_graybackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.tags];
    [_tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(_graybackView.mas_left).with.offset(10);
        make.right.equalTo(_graybackView.mas_right).with.offset(-10);
        make.bottom.equalTo(_graybackView.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_graybackView.mas_left).with.offset(10);
        make.right.equalTo(_graybackView.mas_right).with.offset(-10);
        make.top.equalTo(_graybackView.mas_top).with.offset(10);
        make.bottom.equalTo(_tags.mas_top).with.offset(-7);
    }];
    
//    [self addSubview:self.moreIcon];
//    [_moreIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(11, 11));
//        make.right.equalTo(_content.mas_right).with.offset(0);
//        make.bottom.equalTo(_content.mas_bottom).with.offset(-8);
//    }];
}

#pragma mark - init
- (UIView *)graybackView {
    if (!_graybackView) {
        _graybackView = [[UIView alloc] init];
        _graybackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _graybackView;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor colorWithHexString:@"#666666"];
        _content.numberOfLines = 0;
        [_content sizeToFit];
        _content.font = [UIFont systemFontOfSize:12];
    }
    return _content;
}

- (UIButton *)moreIcon {
    if (!_moreIcon) {
        _moreIcon = [[UIButton alloc] init];
        [_moreIcon setImage:[UIImage imageNamed:@"shouye_jiahao"] forState:(UIControlStateNormal)];
    }
    return _moreIcon;
}

- (UICollectionView *)tags {
    if (!_tags) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _tags = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 20)
                                   collectionViewLayout:flowLayout];
        _tags.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tags.delegate = self;
        _tags.dataSource = self;
        _tags.showsHorizontalScrollIndicator = NO;
        [_tags registerClass:[THNSceneTagsCollectionViewCell class] forCellWithReuseIdentifier:sceneTagsCellId];
    }
    return _tags;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tagsMarr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_tagsMarr.count) {
//        return CGSizeMake([self getTextFrame:_tagsMarr[indexPath.row]].width * 1.5, 20);
//    } else
        return CGSizeMake(30, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNSceneTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneTagsCellId
                                                                                      forIndexPath:indexPath];
//    if (_tagsMarr.count) {
//        [cell thn_setSceneTagsData:_tagsMarr[indexPath.row]];
//    }
    return cell;
}

- (CGSize)getTextFrame:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return textSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"搜索标签:%@", _tagsMarr[indexPath.row]]];
}

@end
