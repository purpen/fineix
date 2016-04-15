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

#pragma mark -
- (void)setMallUI {
    self.searchType = 3;
    self.titleArr = [NSArray arrayWithObjects:@"魅族", @"iPhone6s", @"小米Note", @"一加", @"云马智行车", @"造梦者空气净化器", @"极客潮人", @"世界地球日", @"天气好", @"有柳絮",@"温暖", @"咖啡馆",@"防丢器", @"魅族", @"iPhone6s", @"小米Note", @"一加", @"云马智行车", @"造梦者空气净化器",@"防丢器",  nil];
    [self addTagButton:self.titleArr];
}

#pragma mark -
- (void)setUI {
    self.searchType = 1;
    self.titleArr = [NSArray arrayWithObjects:@"温暖", @"咖啡馆", @"极客潮人", @"世界地球日", @"天气好", @"有柳絮",@"温暖", @"咖啡馆", @"极客潮人", @"世界地球日", @"天气好", @"有柳絮",@"温暖", @"咖啡馆", @"极客潮人",  nil];
    [self addTagButton:self.titleArr];
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
    searchVC.keyword = self.titleArr[button.tag - rollTagBtnTag];
    searchVC.searchType = self.searchType;
    [self.nav pushViewController:searchVC animated:YES];
}


@end
