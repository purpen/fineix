//
//  ShowContentView.m
//  Fiu
//
//  Created by FLYang on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShowContentView.h"
#import "TagFlowLayout.h"
#import "ChooseTagsCollectionViewCell.h"

@interface ShowContentView ()

@pro_strong TagFlowLayout * chooseFlowLayout;

@end

@implementation ShowContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setViewUI];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editContentData:)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

- (void)setAddTags:(NSMutableArray *)addTags {
    if (addTags.count > 0) {
        self.chooseTagMarr = addTags;
        [self.chooseCollection reloadData];
    }
}

- (void)editContentData:(UIGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(EditContentData)]) {
        [_delegate EditContentData];
    }
    [self removeFromSuperview];
}

- (void)setEditContentData:(NSString *)title withDes:(NSString *)des withTags:(NSMutableArray *)tags {
    [self titleTextStyle:title];
    [self desTitleStyle:des];
    self.chooseTagMarr = tags;
    [self.chooseCollection reloadData];
}

#pragma mark -
- (void)setViewUI {
    [self addSubview:self.tagsIcon];
    [_tagsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.addTagBtn];
    [_addTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.right.equalTo(self.mas_right).with.offset(0);
        make.centerY.equalTo(_tagsIcon);
    }];
    
    [self addSubview:self.chooseCollection];
    [_chooseCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(_tagsIcon.mas_right).with.offset(0);
        make.centerY.equalTo(_tagsIcon);
        make.right.equalTo(_addTagBtn.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.desText];
    [_desText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 70));
        make.bottom.equalTo(_tagsIcon.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    [self addSubview:self.titleText];
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 56));
        make.bottom.equalTo(_desText.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
}

#pragma mark - 标题文字
- (UILabel *)titleText {
    if (!_titleText) {
        _titleText = [[UILabel alloc] init];
        _titleText.numberOfLines = 2;
        _titleText.textColor = [UIColor whiteColor];
    }
    return _titleText;
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    if ([title length] < 8) {
        _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:40];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
        }];
    } else if ([title length] >= 8 && [title length] < 13) {
        _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:26];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 36));
        }];
    } else if ([title length] >= 13) {
        _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:20];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 52));
        }];
    }
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]] ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.titleText.attributedText = titleText;
}

#pragma mark 描述内容
- (UITextView *)desText {
    if (!_desText) {
        _desText = [[UITextView alloc] init];
        _desText.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _desText.backgroundColor = [UIColor clearColor];
        _desText.editable = NO;
        _desText.returnKeyType = UIReturnKeyDefault;
    }
    return _desText;
}

//  描述内容的样式
- (void)desTitleStyle:(NSString *)des {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    NSDictionary * attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                  NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12]};
    self.desText.attributedText = [[NSAttributedString alloc] initWithString:des attributes:attributes];
    
    CGSize tagTitleSize = [des boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    
    if (tagTitleSize.height < 70.0f) {
        [self.desText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(tagTitleSize.height * 1.4));
        }];
    } else {
        [self.desText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@70);
        }];
    }
}

#pragma mark 标签图标
- (UIButton *)tagsIcon {
    if (!_tagsIcon) {
        _tagsIcon = [[UIButton alloc] init];
        [_tagsIcon setImage:[UIImage imageNamed:@"icon_addTags"] forState:(UIControlStateNormal)];
    }
    return _tagsIcon;
}

#pragma mark 添加标签
- (UIButton *)addTagBtn {
    if (!_addTagBtn) {
        _addTagBtn = [[UIButton alloc] init];
        _addTagBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [_addTagBtn setTitle:NSLocalizedString(@"addTagsBtn", nil) forState:(UIControlStateNormal)];
        [_addTagBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        [_addTagBtn addTarget:self action:@selector(goAddTags) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addTagBtn;
}

- (void)goAddTags {
    if ([_delegate respondsToSelector:@selector(BeginAddTag)]) {
        [_delegate BeginAddTag];
    }
}

#pragma mark 标签列表
- (UICollectionView *)chooseCollection {
    if (!_chooseCollection) {
        self.chooseFlowLayout = [[TagFlowLayout alloc] init];
        self.chooseFlowLayout.minimumLineSpacing = 1.0f;
        self.chooseFlowLayout.minimumInteritemSpacing = 5.0f;
        [self.chooseFlowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        self.chooseFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _chooseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 80, 30) collectionViewLayout:self.chooseFlowLayout];
        _chooseCollection.backgroundColor = [UIColor clearColor];
        _chooseCollection.delegate = self;
        _chooseCollection.dataSource = self;
        _chooseCollection.showsHorizontalScrollIndicator = NO;
        [_chooseCollection registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
    }
    return _chooseCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chooseTagMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
    [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
    cell.tagBtn.selected = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(tagW + 30, 28);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -
- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}

@end
