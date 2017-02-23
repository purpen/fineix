//
//  CollectionViewHeaderView.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "CollectionViewHeaderView.h"
#import "Masonry.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface CollectionViewHeaderView ()

@end

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.backgroundColor = rgba(240, 240, 240, 0.8);
        self.backgroundColor = [UIColor whiteColor];
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(0);
        }];
        
        self.leftLineView = [[UIView alloc] init];
        self.leftLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [self addSubview:self.leftLineView];
        [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.title.mas_left).mas_offset(-5);
            make.centerY.mas_equalTo(self.title.mas_centerY).mas_offset(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(15);
        }];
        
        self.rightLineView = [[UIView alloc] init];
        self.rightLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [self addSubview:self.rightLineView];
        [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(self.title.mas_centerY).mas_offset(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(15);
        }];
    }
    return self;
}

@end
