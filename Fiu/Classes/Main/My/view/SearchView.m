//
//  SearchView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchView.h"
#import "SearchTF.h"
#import "UIColor+Extension.h"

@interface SearchView ()

/**  */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchTF];
        [self addSubview:self.cancelBtn];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineView];
    }
    return self;
}



-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5,[UIScreen mainScreen].bounds.size.width, 0.5)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

-(SearchTF *)searchTF{
    if (!_searchTF) {
        _searchTF = [[SearchTF alloc] initWithFrame:CGRectMake(15, 8, [UIScreen mainScreen].bounds.size.width - 30, 34)];
    }
    return _searchTF;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 35, 8, 35, 35);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#C7C7C7"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _cancelBtn;
}

@end
