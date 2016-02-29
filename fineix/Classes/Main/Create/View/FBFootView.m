//
//  FBFootView.m
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBFootView.h"

const static NSInteger btnTag = 100;

@implementation FBFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.buttonView];
    }
    return self;
}

//  设置按钮视图
- (UIScrollView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _buttonView.bounces = NO;
        _buttonView.showsHorizontalScrollIndicator = NO;
        _buttonView.showsVerticalScrollIndicator = NO;
    }
    return _buttonView;
}

- (void)addFootViewButton {
    for (NSUInteger idx = 0; idx < self.titleArr.count; idx ++) {
        UIButton * toolBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx * SCREEN_WIDTH/self.titleArr.count, 0, SCREEN_WIDTH/self.titleArr.count, 53.0f)];
        [toolBtn setTitle:self.titleArr[idx] forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:[UIColor colorWithHexString:color alpha:1] forState:(UIControlStateSelected)];
        toolBtn.backgroundColor = [UIColor colorWithHexString:@"#010101" alpha:1];
        toolBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        toolBtn.tag = btnTag + idx;
        
        if (toolBtn.tag == btnTag) {
            toolBtn.selected = YES;
            self.seletedBtn = toolBtn;
        }
        
        [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.buttonView addSubview:toolBtn];
    }
}

- (void)toolBtnClick:(UIButton *)button {
    self.seletedBtn.selected = NO;
    button.selected = YES;
    self.seletedBtn = button;
    
    //  改变导航条的位置
    CGRect lineRect = self.line.frame;
    lineRect.origin.x = (SCREEN_WIDTH/self.titleArr.count) * (button.tag - btnTag);
    [UIView animateWithDuration:.2 animations:^{
        self.line.frame = lineRect;
    }];
    
    if ([_delegate respondsToSelector:@selector(buttonDidSeletedWithIndex:)]) {
        [_delegate buttonDidSeletedWithIndex:(button.tag - btnTag)];
    }
    
}

//  设置导航条
- (void)showLineWithButton {
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 53.0f, SCREEN_WIDTH/self.titleArr.count, 2.0f)];
    self.line.backgroundColor = [UIColor colorWithHexString:color alpha:1];
    [self.buttonView addSubview:self.line];
}

@end
