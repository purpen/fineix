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
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<26; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh _000%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<26; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh _000%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
