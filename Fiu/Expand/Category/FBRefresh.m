//
//  FBRefresh.m
//  Fiu
//
//  Created by FLYang on 16/6/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBRefresh.h"

@implementation FBRefresh

- (void)prepare{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_000%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_000%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
