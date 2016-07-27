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

@interface AddContentView ()

@pro_strong TagFlowLayout * chooseFlowLayout;

@end

@implementation AddContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setViewUI];
        
    }
    return self;
}

- (void)setDefaultChooseTags:(NSMutableArray *)chooseMarr {
    self.chooseTagMarr = chooseMarr;
}

- (void)getUserEditTags:(NSMutableArray *)tagsMarr {
    self.tagS = tagsMarr;
    [self.tagsColleciton reloadData];
}

#pragma mark - 
- (void)setViewUI {
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.topBtn];
    [self addSubview:self.botBtn];
    
    [self addSubview:self.chooseText];
    [_chooseText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(100);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_chooseText.mas_top).with.offset(0);
        make.right.equalTo(_chooseText.mas_left).with.offset(0);
    }];
    
    UILabel * titleLine = [[UILabel alloc] init];
    titleLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    [self addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 1));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_title.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(_title.mas_bottom).with.offset(7);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * contentLine = [[UILabel alloc] init];
    contentLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    [self addSubview:contentLine];
    [contentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 1));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_content.mas_bottom).with.offset(5);
    }];

    [self addSubview:self.tagsView];
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 70));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_content.mas_bottom).with.offset(0);
    }];
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

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [_topBtn addTarget:self action:@selector(closeViewAndSetData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _topBtn;
}

- (UIButton *)botBtn {
    if (!_botBtn) {
        _botBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_HEIGHT - 300))];
        [_botBtn addTarget:self action:@selector(closeViewAndSetData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _botBtn;
}

- (void)closeViewAndSetData {
    self.getEditContentAndTags(self.title.text, self.content.text, self.chooseTagMarr);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self.title resignFirstResponder];
        [self.content resignFirstResponder];
    }];
}

#pragma mark - 场景标题
- (UITextField *)title {
    if (!_title) {
        _title = [[UITextField alloc] init];
        _title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"addTitle", nil)
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.7]}];
        _title.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _title.clearButtonMode = UITextFieldViewModeWhileEditing;
        _title.delegate = self;
        _title.returnKeyType = UIReturnKeyDone;
        _title.textColor = [UIColor whiteColor];
    }
    return _title;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.title) {
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.title) {
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.title) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - 选择语境
- (UIButton *)chooseText {
    if (!_chooseText) {
        _chooseText = [[UIButton alloc] init];
        _chooseText.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
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
        _content = [[UITextView alloc] init];
        _content.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
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
        _tagsView = [[UIView alloc] init];
        _tagsView.backgroundColor = [UIColor clearColor];

        [_tagsView addSubview:self.tagsIcon];
        
        [_tagsView addSubview:self.tagsColleciton];
        [_tagsColleciton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.top.equalTo(_tagsView.mas_top).with.offset(6);
            make.left.equalTo(_tagsView.mas_left).with.offset(30);
            make.right.equalTo(_tagsView.mas_right).with.offset(0);
        }];
        
    }
    return _tagsView;
}

#pragma mark 图标
- (UIButton *)tagsIcon {
    if (!_tagsIcon) {
        _tagsIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
        [_tagsIcon setImage:[UIImage imageNamed:@"icon_addTags"] forState:(UIControlStateNormal)];
    }
    return _tagsIcon;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagS.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendTagsCollectionViewCell" forIndexPath:indexPath];
    if (self.tagS.count) {
        [cell.tagBtn setTitle:self.tagS[indexPath.row] forState:(UIControlStateNormal)];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagW = [self.tagS[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(tagW + 30, 28);
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
