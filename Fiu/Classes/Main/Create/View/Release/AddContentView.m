//
//  AddContentView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddContentView.h"
#import "FBEditShareInfoViewController.h"
#import "TagFlowLayout.h"
#import "ChooseTagsCollectionViewCell.h"

@implementation AddContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.chooseText];
        [self addSubview:self.tagsView];
        
        UILabel * titleLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH - 15, 1)];
        titleLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        [self addSubview:titleLine];
        
        UILabel * contentLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 153, SCREEN_WIDTH - 15, 1)];
        contentLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        [self addSubview:contentLine];
    }
    return self;
}

#pragma mark - 场景标题
- (UITextField *)title {
    if (!_title) {
        _title = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 90, 44)];
        _title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"addTitle", nil)
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.7]}];
        _title.font = [UIFont systemFontOfSize:12];
        _title.clearButtonMode = UITextFieldViewModeWhileEditing;
        _title.delegate = self;
        _title.returnKeyType = UIReturnKeyDone;
        _title.textColor = [UIColor whiteColor];
    }
    return _title;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(EditBegin)]){
        [_delegate EditBegin];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - 选择语境
- (UIButton *)chooseText {
    if (!_chooseText) {
        _chooseText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 60, 44)];
        _chooseText.titleLabel.font = [UIFont systemFontOfSize:12];
        [_chooseText setTitle:NSLocalizedString(@"ChooseText", nil) forState:(UIControlStateNormal)];
        [_chooseText setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        [_chooseText addTarget:self action:@selector(goChooseText) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseText;
}

- (void)goChooseText {
    FBEditShareInfoViewController * chooseTextVC = [[FBEditShareInfoViewController alloc] init];
    chooseTextVC.bgImg = self.bgImage;
    [self.vc presentViewController:chooseTextVC animated:YES completion:nil];
    
    chooseTextVC.getEdtiShareText = ^ (NSString * title, NSString * des, NSArray * tagS) {
        [self.tagS removeAllObjects];
        self.title.text = title;
        self.content.text = des;
        self.content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        
        if (tagS.count > 10) {
            for (NSUInteger idx = 0; idx < 10; ++ idx) {
                [self.tagS addObject:tagS[idx]];
            }
        } else {
            self.tagS = [NSMutableArray arrayWithArray:tagS];
        }
        self.tagsColleciton.hidden = NO;
        self.chooseCollection.hidden = YES;
        [self.tagsColleciton reloadData];
        [self changeTagsViewFrame];
    };
}

#pragma mark 改变推荐标签的frame
- (void)changeTagsViewFrame {
    CGFloat tagsViewW = 0.0f;
    
    for (NSUInteger idx = 0; idx < self.tagS.count; ++ idx) {
        CGFloat tagTitleW = [self.tagS[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        tagsViewW += (tagTitleW + 30);
    }

    NSInteger tagsLineN = tagsViewW/(SCREEN_WIDTH - 40);
    CGFloat tagsViewH = (tagsLineN + 1) * 30;
    
    [self.tagsColleciton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tagsViewH));
    }];
}

#pragma mark - 场景描述
- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH - 15, 100)];
        _content.font = [UIFont systemFontOfSize:12];
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.7];
        _content.backgroundColor = [UIColor clearColor];
        _content.delegate = self;
        _content.returnKeyType = UIReturnKeyDefault;
    }
    return _content;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        _content.text = @"";
        _content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
    if ([_delegate respondsToSelector:@selector(EditBegin)]){
        [_delegate EditBegin];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:@""]) {
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.7];
        
    } else {
        _content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
}

#pragma mark - 标签视图
- (UIView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[UIView alloc] initWithFrame:CGRectMake(15, 154, SCREEN_WIDTH - 30, 70)];
        _tagsView.backgroundColor = [UIColor clearColor];
        
        [_tagsView addSubview:self.tagsIcon];
        [_tagsView addSubview:self.tagsColleciton];
        [_tagsColleciton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 30));
            make.top.equalTo(_tagsView.mas_top).with.offset(0);
            make.left.equalTo(_tagsView.mas_left).with.offset(30);
        }];
    }
    return _tagsView;
}

#pragma mark 图标
- (UIButton *)tagsIcon {
    if (!_tagsIcon) {
        _tagsIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        [_tagsIcon setImage:[UIImage imageNamed:@"icon_addTags"] forState:(UIControlStateNormal)];
    }
    return _tagsIcon;
}

#pragma mark 用户选择标签
- (void)getUserEditTags:(NSMutableArray *)tagsMarr {
    self.tagsColleciton.hidden = YES;
    self.chooseCollection.hidden = NO;
    [self addSubview:self.chooseCollection];
    [_chooseCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 30));
        make.top.equalTo(_tagsView.mas_top).with.offset(5);
        make.left.equalTo(_tagsView.mas_left).with.offset(25);
    }];
    
    self.chooseTagMarr = tagsMarr;
    [self.chooseCollection reloadData];
}

#pragma mark 推荐标签
- (UICollectionView *)tagsColleciton {
    if (!_tagsColleciton) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.max = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        _tagsColleciton = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 40, 30) collectionViewLayout:flowLayout];
        _tagsColleciton.backgroundColor = [UIColor clearColor];
        _tagsColleciton.delegate = self;
        _tagsColleciton.dataSource = self;
        _tagsColleciton.showsHorizontalScrollIndicator = NO;
        [_tagsColleciton registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendTagsCollectionViewCell"];
    }
    return _tagsColleciton;
}

- (UICollectionView *)chooseCollection {
    if (!_chooseCollection) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 5.0f;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        _chooseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 40, 30) collectionViewLayout:flowLayout];
        _chooseCollection.backgroundColor = [UIColor clearColor];
        _chooseCollection.delegate = self;
        _chooseCollection.dataSource = self;
        _chooseCollection.showsHorizontalScrollIndicator = NO;
        [_chooseCollection registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
    }
    return _chooseCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.tagsColleciton) {
        return self.tagS.count;
    } else if (collectionView == self.chooseCollection) {
        return self.chooseTagMarr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tagsColleciton) {
        ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendTagsCollectionViewCell" forIndexPath:indexPath];
        if (self.tagS.count) {
            [cell.tagBtn setTitle:self.tagS[indexPath.row] forState:(UIControlStateNormal)];
        }
        return cell;
    } else if (collectionView == self.chooseCollection) {
        ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
        [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
        cell.tagBtn.selected = YES;
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tagsColleciton) {
        CGFloat tagW = [self.tagS[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        return CGSizeMake(tagW + 30, 28);
        
    } else if (collectionView == self.chooseCollection) {
        CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        return CGSizeMake(tagW + 30, 28);
    }
    return CGSizeMake(0.01, 0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tagsColleciton) {
        ChooseTagsCollectionViewCell * cell = (ChooseTagsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell updateCellState:!cell.isSelected];
        if (cell.isSelected) {
            [self.chooseTagMarr addObject:self.tagS[indexPath.row]];
        }
        else{
            [self.chooseTagMarr removeObject:self.tagS[indexPath.row]];
        }
    }
}

#pragma mark -
- (NSMutableArray *)tagS {
    if (!_tagS) {
        _tagS = [NSMutableArray array];
    }
    return _tagS;
}

- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}

@end
