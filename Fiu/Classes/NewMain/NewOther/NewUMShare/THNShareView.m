//
//  THNShareView.m
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNShareView.h"

@implementation THNShareView

+ (THNShareView *)shareView {
    static dispatch_once_t once;
    static THNShareView *shareView;
    dispatch_once(&once, ^ { shareView = [[THNShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]; });
    shareView.alpha = 0;
    return shareView;
}

+ (void)openShareView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:[self shareView]];
    
    [UIView animateWithDuration:.3 animations:^{
        [self shareView].alpha = 1;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_viewUI];
    }
    return self;
}

- (void)set_viewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    [self addSubview:self.shareCollectionView];
    [self changeCollectionViewFrame];
}

- (void)changeCollectionViewFrame {
    CGRect rectFrame = self.shareCollectionView.frame;
    rectFrame = CGRectMake(0, SCREEN_HEIGHT - (SCREEN_WIDTH/4 +40), SCREEN_WIDTH, SCREEN_WIDTH/4 +40);
    [UIView animateWithDuration:.3 animations:^{
        self.shareCollectionView.frame = rectFrame;
    }];
}

- (THNShareCollectionView *)shareCollectionView {
    if (!_shareCollectionView) {
        _shareCollectionView = [[THNShareCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH/4 +40)
                                                        collectionViewLayout:nil];
        _shareCollectionView.chooseShareAddress = ^ (NSInteger index) {
            NSLog(@"分享%zi", index);
        };
    }
    return _shareCollectionView;
}


@end
