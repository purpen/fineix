//
//  FiuHeaderTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/6/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuHeaderWatchTableViewCell.h"
#import "UIImage+MultiFormat.h"
#import "LMSpringboardItemView.h"
#import "LMSpringboardView.h"
#import "HomePageViewController.h"
#import "GoodsBrandViewController.h"

@interface FiuHeaderWatchTableViewCell () {
    NSInteger           _type;  //  0:用户 1:品牌
    NSArray         *   _headerImgMarr;
    NSArray         *   _headerIdMarr;
}

@end

@implementation FiuHeaderWatchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:cellBgColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setHeaderImage:(NSArray *)img withId:(NSArray *)ids withType:(NSInteger)type {
    _headerImgMarr = img;
    _headerIdMarr = ids;
    _type = type;
    
    if (![self.subviews containsObject:_springboard]) {
        _springboard = [[LMSpringboardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        _springboard.backgroundColor = [UIColor colorWithHexString:cellBgColor];
        _springboard.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        NSMutableArray * itemViews = [NSMutableArray array];
        
        for(NSUInteger idx = 0; idx < img.count; ++ idx) {
            LMSpringboardItemView * item = [[LMSpringboardItemView alloc] init];
            [item.icon downloadImage:img[idx] place:[UIImage imageNamed:@""]];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenUserHomePage:)];
            [item addGestureRecognizer:tap];
            [itemViews addObject:item];
        }
        _springboard.itemViews = itemViews;
        
        [self addSubview:_springboard];
    }
}


- (void)OpenUserHomePage:(UITapGestureRecognizer*)sender {
    NSInteger index = [_springboard.itemViews indexOfObject:sender.view];
    if (_type == 0) {
            HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
            peopleHomeVC.isMySelf = NO;
            peopleHomeVC.type = @2;
            peopleHomeVC.userId = _headerIdMarr[index];
            [self.nav pushViewController:peopleHomeVC animated:YES];
    
    } else if (_type == 1) {
        GoodsBrandViewController * brandVC = [[GoodsBrandViewController alloc] init];
        brandVC.brandId = _headerIdMarr[index];
        [self.nav pushViewController:brandVC animated:YES];
    }
}


@end
