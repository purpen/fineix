//
//  CategoryTagRollView.m
//  Fiu
//
//  Created by FLYang on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryTagRollView.h"

static const NSInteger tagRollBtnTag = 595;

@implementation CategoryTagRollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark -
- (void)setTagRollMarr:(NSArray *)title {
    [self addtagScrollView:title];
    [self addSubview:self.tagRollView];
}

#pragma mark - 商品分类标签
- (UIScrollView *)tagRollView {
    if (!_tagRollView) {
        _tagRollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tagRollView.showsVerticalScrollIndicator = NO;
        _tagRollView.showsHorizontalScrollIndicator = NO;
        _tagRollView.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    }
    return _tagRollView;
}

//  商品分类标签按钮
- (void)addtagScrollView:(NSArray *)tagMarr {
    
    CGFloat width = 0;
    CGFloat height = 8;
    
    for (NSUInteger idx = 0; idx < tagMarr.count; ++ idx) {
        UIButton * tagBtn = [[UIButton alloc] init];
        CGFloat btnLength = [[tagMarr objectAtIndex:idx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        [tagBtn setTitle:tagMarr[idx] forState:(UIControlStateNormal)];
        [tagBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [tagBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateSelected)];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Tag];
        tagBtn.layer.cornerRadius = 5;
        tagBtn.layer.borderWidth = 0.5f;
        tagBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        tagBtn.frame = CGRectMake(15 + width + (10 * idx), height, btnLength + 30, 29);
        width = tagBtn.frame.size.width + width;
        tagBtn.tag = tagRollBtnTag + idx;
        if (tagBtn.tag == tagRollBtnTag) {
            tagBtn.selected = YES;
            tagBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
            self.selectedBtn = tagBtn;
        }

        [tagBtn addTarget:self action:@selector(tagBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.tagRollView addSubview:tagBtn];
    }
    
    self.tagRollView.contentSize = CGSizeMake(width * 1.17, 0);
}

#pragma mark - 
- (void)tagBtnAction:(UIButton *)button {
    self.selectedBtn.selected = NO;
    self.selectedBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    button.selected = YES;
    button.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    self.selectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(tagBtnSelected:)]) {
        [self.delegate tagBtnSelected:(button.tag - tagRollBtnTag)];
    }
}


@end
