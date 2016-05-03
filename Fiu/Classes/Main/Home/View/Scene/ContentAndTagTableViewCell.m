//
//  ContentAndTagTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ContentAndTagTableViewCell.h"
#import "SearchViewController.h"

const static NSInteger buttonTag = 421;

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
    [self addTagButton:model.tagTitles];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentLab.frame.size.height + self.tagView.frame.size.height);
}

- (void)setSceneDescription:(SceneInfoData *)model {
    [self changeContentLabStyle:model.des];
    [self addTagButton:model.tagTitles];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentLab.frame.size.height + self.tagView.frame.size.height);
}

#pragma mark - 创建视图UI
- (void)setCellViewUI {
    [self.contentView addSubview:self.contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 15));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self.contentView addSubview:self.tagView];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        make.top.equalTo(_contentLab.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
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

#pragma mark - 标签视图
- (UIScrollView *)tagView {
    if (!_tagView) {
        _tagView = [[UIScrollView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.showsVerticalScrollIndicator = NO;
        _tagView.showsHorizontalScrollIndicator = NO;
    }
    return _tagView;
}

#pragma mark - 添加标签 
- (void)addTagButton:(NSArray *)titleArr {
    CGFloat btnW = 0;
    CGFloat btnH = 10;
    
    for (NSUInteger idx = 0; idx < titleArr.count; ++idx) {
        CGFloat tagBtnWidth = [[titleArr objectAtIndex:idx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        
        UIButton * tagBtn = [[UIButton alloc] init];
        [tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_gray"] forState:(UIControlStateNormal)];
        [tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_yellow"] forState:(UIControlStateHighlighted)];
        [tagBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
        [tagBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
        [tagBtn setTitleColor:[UIColor colorWithHexString:titleColor alpha:1] forState:(UIControlStateNormal)];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Tag];
        tagBtn.frame = CGRectMake(btnW + (10 * idx), btnH, tagBtnWidth + 25, 20);
        btnW = tagBtn.frame.size.width + btnW;
        tagBtn.tag = buttonTag + idx;
        
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tagView addSubview:tagBtn];
    }
    
    self.tagView.contentSize = CGSizeMake(btnW * 1.15, 0);
}

//  标签的点击方法
- (void)tagBtnClick:(UIButton *)button {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.keyword = self.titleArr[button.tag - buttonTag];
    searchVC.searchType = 0;
    [self.nav pushViewController:searchVC animated:YES];
}




@end
