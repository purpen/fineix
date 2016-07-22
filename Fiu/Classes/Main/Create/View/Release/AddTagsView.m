//
//  AddTagsView.m
//  Fiu
//
//  Created by FLYang on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddTagsView.h"
#import "TagFlowLayout.h"
#import "ChooseTagsCollectionViewCell.h"

@implementation AddTagsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setViewUI];
        
    }
    return self;
}

- (void)setDefaultTags:(NSMutableArray *)tags {
    if (tags.count > 0) {
        self.chooseTagMarr = tags;
        [self changeChooseTagViewFrame:tags];
    }
    [self.addTagWrite becomeFirstResponder];
    
    [self layoutIfNeeded];
}

- (void)changeChooseTagViewFrame:(NSMutableArray *)tags {
    CGFloat tagsViewW = 0.0f;
    
    for (NSUInteger idx = 0; idx < tags.count; ++ idx) {
        CGFloat tagTitleW = [tags[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        tagsViewW += (tagTitleW + 30);
    }
    
    NSInteger tagsLineN = tagsViewW/(SCREEN_WIDTH - 30);
    CGFloat tagsViewH = (tagsLineN + 1) * 30;
    
    [self.chooseCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tagsViewH));
    }];
    
    [self.chooseCollection reloadData];
}

#pragma mark -
- (void)setViewUI {
    [self addSubview:self.bgImgView];
    [self addSubview:self.vcTitle];
    [self addSubview:self.doneBtn];
    
    [self addSubview:self.chooseCollection];
    [_chooseCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 30));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(60);
    }];
    
    [self addSubview:self.addTagWrite];
    [_addTagWrite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 30));
        make.left.equalTo(self.mas_left).with.offset(20);
        make.top.equalTo(_chooseCollection.mas_bottom).with.offset(0);
    }];
}

- (UITextField *)addTagWrite {
    if (!_addTagWrite) {
        _addTagWrite = [[UITextField alloc] init];
        _addTagWrite.delegate = self;
        _addTagWrite.textColor = [UIColor whiteColor];
        _addTagWrite.font = [UIFont systemFontOfSize:12];
        _addTagWrite.returnKeyType = UIReturnKeyDone;
    }
    return _addTagWrite;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        if ([self.chooseTagMarr containsObject:textField.text]) {
            [SVProgressHUD showInfoWithStatus:@"不能包含重复的标签~"];
            
        } else {
            [self.chooseTagMarr addObject:textField.text];
            [self changeChooseTagViewFrame:self.chooseTagMarr];
            textField.text = @"";
        }
        
    } else if ([textField.text isEqualToString:@""]){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark 标签列表
- (UICollectionView *)chooseCollection {
    if (!_chooseCollection) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 5.0f;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _chooseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 30) collectionViewLayout:flowLayout];
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
    [self.chooseTagMarr removeObject:self.chooseTagMarr[indexPath.row]];
    [self changeChooseTagViewFrame:self.chooseTagMarr];
}

#pragma mark - 情景背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImage;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        effectView.alpha = 1.0f;
        [_bgImgView addSubview:effectView];
    }
    return _bgImgView;
}

- (UILabel *)vcTitle {
    if (!_vcTitle) {
        _vcTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _vcTitle.text = NSLocalizedString(@"addTagsBtn", nil);
        _vcTitle.font = [UIFont systemFontOfSize:16];
        _vcTitle.textColor = [UIColor whiteColor];
        _vcTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _vcTitle;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
        [_doneBtn setTitle:NSLocalizedString(@"Done", nil) forState:(UIControlStateNormal)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneBtn;
}

- (void)doneBtnClick {
    [self.addTagWrite resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(addTagsDone)]) {
        [_delegate addTagsDone];
    }
    self.alpha = 0;
}

#pragma mark -
- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}

@end
