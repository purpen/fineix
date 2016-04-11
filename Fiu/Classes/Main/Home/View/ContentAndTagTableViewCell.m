//
//  ContentAndTagTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ContentAndTagTableViewCell.h"

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
- (void)setUI {
    NSString * str = @"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。它更是一条逼你拼命挣钱的鞭子，让你为它拉车犁地。家又是一个充满亲情的地方，就会有一种亲情感回荡心头。在风雨人生中，渐渐地形成了一种强烈的感觉：我爱家，更离不开家。";
    [self changeContentLabStyle:str];
    
    NSArray * titleArr = [NSArray arrayWithObjects:@"温暖", @"咖啡馆", @"极客潮人", @"世界地球日", @"天气好", @"有柳絮", nil];
    [self addTagButton:titleArr];
    
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
    
    self.tagView.contentSize = CGSizeMake(btnW + 60, 0);
}

//  标签的点击方法
- (void)tagBtnClick:(UIButton *)button {
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝ 点击了标签%zi", button.tag - buttonTag);
}




@end
