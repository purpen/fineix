//
//  FBRollImages.m
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBRollImages.h"

@implementation FBRollImages

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.rollImageView];
        [_rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.48));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setRollimageView {
    NSArray *images = @[
                        [UIImage imageNamed:@"banner"],
                        [UIImage imageNamed:@"banner2"]
                        ];
    self.rollImageView.localizationImagesGroup = images;
}

- (SDCycleScrollView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[SDCycleScrollView alloc] init];
        _rollImageView.autoScrollTimeInterval = 3;
        _rollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _rollImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//        _rollImageView.placeholderImage = [UIImage imageNamed:@"special"];
        _rollImageView.delegate = self;
    }
    return _rollImageView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}

@end
