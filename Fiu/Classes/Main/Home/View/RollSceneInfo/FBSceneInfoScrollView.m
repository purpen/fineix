//
//  FBSceneInfoScrollView.m
//  Fiu
//
//  Created by FLYang on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSceneInfoScrollView.h"
#import "GoodsInfoViewController.h"

@interface FBSceneInfoScrollView () {
    UIScrollView    *   _backgroundScrollView;
    UIView          *   _constraitView;
    UIImageView     *   _backgroundImageView;
    UIView          *   _foregroundContainerView;
    UIImageView     *   _topMaskImageView;
    BOOL                _rollDown;               //  是否下拉
    CGFloat             _lastContentOffset;      //  滚动的方向
}

@end

@implementation FBSceneInfoScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UITableView *)foregroundView {
    self = [super initWithFrame:frame];
    if (self) {
        self.showUserTagMarr = [NSMutableArray array];
        
        _backgroundImage = backgroundImage;
        _viewDistanceFromBottom = viewDistanceFromBottom;
        _foregroundView = foregroundView;
        _foregroundView.scrollEnabled = NO;
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [self createBackgroundView];
        [self createForegroundView];
        
        [self addSubview:self.showGoodsTagsView];
        self.showGoodsTagsView.alpha = 0;
    }
    return self;
}

#pragma mark - set
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect bound = CGRectOffset(frame, -frame.origin.x, -frame.origin.y);
    
    [_backgroundScrollView setFrame:bound];
    [_backgroundScrollView setContentSize:CGSizeMake(bound.size.width, bound.size.height + (SCREEN_HEIGHT / 2))];
    [_backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    [_constraitView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + (SCREEN_HEIGHT / 2))];
    
    [_foregroundContainerView setFrame:bound];
    [_foregroundScrollView setFrame:bound];
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(bound.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
}

- (void)setViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom {
    _viewDistanceFromBottom = viewDistanceFromBottom;

    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
}

#pragma mark - 
- (void)createBackgroundView {
    //background
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_backgroundScrollView setUserInteractionEnabled:NO];
    [_backgroundScrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT)];
    [self addSubview:_backgroundScrollView];
    
    _constraitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_backgroundScrollView addSubview:_constraitView];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_constraitView addSubview:_backgroundImageView];
    
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
}

- (void)createForegroundView {
    _foregroundContainerView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_foregroundContainerView];
    
    _foregroundScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_foregroundScrollView setDelegate:self];
    [_foregroundScrollView setShowsVerticalScrollIndicator:NO];
    [_foregroundScrollView setShowsHorizontalScrollIndicator:NO];
    [_foregroundContainerView addSubview:_foregroundScrollView];
    
    UITapGestureRecognizer *_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foregroundTapped:)];
    _tapRecognizer.delegate = self;
    [_foregroundScrollView addGestureRecognizer:_tapRecognizer];
    
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    [_foregroundScrollView addSubview:_foregroundView];
    
    [_foregroundScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
}

#pragma mark - 点击

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

- (void)foregroundTapped:(UITapGestureRecognizer *)tapRecognizer {
    for (UIView * view in _showGoodsTagsView.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString * title = [self.tagDataMarr[idx] valueForKey:@"title"];
        NSString * price = [NSString stringWithFormat:@"￥%.2f", [[self.tagDataMarr[idx] valueForKey:@"price"] floatValue]];
        UserGoodsTag * userTag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(btnX * SCREEN_WIDTH, (btnY * SCREEN_HEIGHT) * 0.873, 175, 32)];
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        if (price.length > 6) {
            userTag.price.font = [UIFont systemFontOfSize:9];
        }
        userTag.price.text = price;
        userTag.isMove = NO;
        [userTag setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateNormal)];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoodsInfo:)];
        [userTag addGestureRecognizer:tapGesture];
        [self.showGoodsTagsView addSubview:userTag];
        [self.showUserTagMarr addObject:userTag];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.leftBtn.alpha = 0;
        self.rightBtn.alpha = 0;
        self.showGoodsTagsView.alpha = 1;
    }];
}

- (void)openGoodsInfo:(UIGestureRecognizer *)button {
    NSInteger index = [self.showUserTagMarr indexOfObject:button.view];
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = self.goodsIds[index];
    [self.nav pushViewController:goodsInfoVC animated:YES];
}

- (UIButton *)showGoodsTagsView {
    if (!_showGoodsTagsView) {
        _showGoodsTagsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_showGoodsTagsView setImage:_backgroundImage forState:(UIControlStateNormal)];
        [_showGoodsTagsView addTarget:self action:@selector(closeShowUserTag) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showGoodsTagsView;
}

- (void)closeShowUserTag {
    [self.showUserTagMarr removeAllObjects];
    [UIView animateWithDuration:.3 animations:^{
        self.leftBtn.alpha = 1;
        self.rightBtn.alpha = 1;
        self.showGoodsTagsView.alpha = 0;
    }];
}

#pragma mark -
- (void)setSceneInfoData:(SceneInfoData *)model {
    self.tagDataMarr = [NSMutableArray arrayWithArray:model.product];
    [self setUserTagBtn];
    self.goodsIds = [NSMutableArray arrayWithArray:[model.product valueForKey:@"idField"]];
}

#pragma mark - 创建用户添加商品按钮
- (void)setUserTagBtn {
    self.userTagMarr = [NSMutableArray array];
    
    for (UIView * view in _backgroundImageView.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString * title = [self.tagDataMarr[idx] valueForKey:@"title"];
        NSString * price = [NSString stringWithFormat:@"￥%.2f", [[self.tagDataMarr[idx] valueForKey:@"price"] floatValue]];
        UserGoodsTag * userTag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(btnX * SCREEN_WIDTH, (btnY * SCREEN_HEIGHT) * 0.873, 175, 32)];
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        if (price.length > 6) {
            userTag.price.font = [UIFont systemFontOfSize:9];
        }
        userTag.price.text = price;
        userTag.title.hidden = YES;
        userTag.price.hidden = YES;
        userTag.isMove = NO;
        [userTag setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        
        [_backgroundImageView addSubview:userTag];
        [self.userTagMarr addObject:userTag];
    }
}

#pragma mark - Delegate
#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (_lastContentOffset < scrollView.contentOffset.y) {
        _rollDown = YES;
    }else{
        _rollDown = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ratio = (scrollView.contentOffset.y + _foregroundScrollView.contentInset.top)/(_foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom);
    ratio = ratio<0?0:ratio;
    ratio = ratio>1?1:ratio;
    
    [_backgroundScrollView setContentOffset:CGPointMake(0, ratio * (SCREEN_HEIGHT / 2))];
    
    if (_rollDown == YES) {
        [UIView animateWithDuration:.4 animations:^{
            self.leftBtn.alpha = 0;
            self.rightBtn.alpha = 0;
            self.logoImg.alpha = 0;
        }];
        
    } else if (_rollDown == NO) {
        [UIView animateWithDuration:.4 animations:^{
            self.leftBtn.alpha = 1;
            self.rightBtn.alpha = 1;
            self.logoImg.alpha = 1;
        }];
    }
    
    if (scrollView.contentOffset.y > 0) {
        _foregroundView.scrollEnabled = YES;
    } else if (scrollView.contentOffset.y <= 0) {
        _foregroundView.scrollEnabled = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint point = * targetContentOffset;
    CGFloat ratio = (point.y + _foregroundScrollView.contentInset.top)/(_foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom);
    
    if (ratio > 0 && ratio < 1) {
        if (velocity.y == 0) {
            ratio = ratio > .5?1:0;
        }else if(velocity.y > 0){
            ratio = ratio > .1?1:0;
        }else{
            ratio = ratio > .9?1:0;
        }
        targetContentOffset->y = ratio * _foregroundView.frame.origin.y - _foregroundScrollView.contentInset.top;
    }
}


@end
