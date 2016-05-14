//
//  FiuTagTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuTagTableViewCell.h"
#import "SearchViewController.h"

static const NSInteger  rollTagBtnTag = 97;

@implementation FiuTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tagTitleArr = [NSMutableArray array];
        
        [self addSubview:self.tagRollView];
        [_tagRollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 90));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - “品”
- (void)setMallHotTagsData:(NSMutableArray *)model {
    self.type = 2;
    for (HotTagsRow * tag in model) {
        [self.tagTitleArr addObject:tag.titleCn];
    }
    [self addTagButton:self.tagTitleArr];
}

#pragma mark - “景”
- (void)setHotTagsData:(NSMutableArray *)model {
    self.type = 1;
    for (HotTagsRow * tag in model) {
        [self.tagTitleArr addObject:tag.titleCn];
    }
    [self addTagButton:self.tagTitleArr];
}

#pragma mark - 标签视图
- (UIScrollView *)tagRollView {
    if (!_tagRollView) {
        _tagRollView = [[UIScrollView alloc] init];
        _tagRollView.backgroundColor = [UIColor whiteColor];
        _tagRollView.showsVerticalScrollIndicator = NO;
        _tagRollView.showsHorizontalScrollIndicator = NO;
    }
    return _tagRollView;
}

#pragma mark - 添加标签
- (void)addTagButton:(NSArray *)titleArr {
    CGFloat btnW = 0;
    CGFloat btnH = 15;
    CGFloat titleW = 0;
    
    for (NSUInteger jdx = 0; jdx < titleArr.count; ++ jdx) {
        CGFloat tagBtnWidth = [[titleArr objectAtIndex:jdx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        
        titleW += tagBtnWidth + 35;
    }

    self.tagRollView.contentSize = CGSizeMake(titleW / 1.9 , 0);
    
    for (NSUInteger idx = 0; idx < titleArr.count; ++ idx) {
        CGFloat tagBtnWidth = [[titleArr objectAtIndex:idx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        
        UIButton * tagBtn = [[UIButton alloc] init];
        [tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_gray"] forState:(UIControlStateNormal)];
        [tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_yellow"] forState:(UIControlStateHighlighted)];
        [tagBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
        [tagBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
        [tagBtn setTitleColor:[UIColor colorWithHexString:titleColor alpha:1] forState:(UIControlStateNormal)];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Tag];
        tagBtn.tag = rollTagBtnTag + idx;
        
        tagBtn.frame = CGRectMake(btnW + 10, btnH, tagBtnWidth + 25, 20);
        //  长度超出屏幕自动折行
        if((btnW + 10 + tagBtnWidth + 25) > (titleW / 1.9)) {
            btnW = 0;
            btnH = btnH + tagBtn.frame.size.height + 10;
            tagBtn.frame = CGRectMake(btnW + 10, btnH, tagBtnWidth + 25, 20);
        }
        btnW = tagBtn.frame.size.width + tagBtn.frame.origin.x;
        
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.tagRollView addSubview:tagBtn];
    }

}

//  标签的点击方法
- (void)tagBtnClick:(UIButton *)button {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.keyword = self.tagTitleArr[button.tag - rollTagBtnTag];
    searchVC.searchType = self.type;
    [self.nav pushViewController:searchVC animated:YES];
}



@end