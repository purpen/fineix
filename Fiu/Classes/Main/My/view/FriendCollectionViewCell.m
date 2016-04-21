//
//  FriendCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FriendCollectionViewCell.h"
#import "Fiu.h"

@implementation FriendCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.bgImageView];
    }
    return self;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.frame = self.frame;
    }
    return _bgImageView;
}

-(void)setUI{
    _bgImageView.image = [UIImage imageNamed:@"friendBg"];
}

@end
