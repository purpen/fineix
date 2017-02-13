//
//  CollectionViewHeaderView.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "CollectionViewHeaderView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = rgba(240, 240, 240, 0.8);
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 80, 20)];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
    }
    return self;
}

@end
