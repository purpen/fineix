//
//  FBSceneInfoScrollView.m
//  Fiu
//
//  Created by FLYang on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSceneInfoScrollView.h"

@interface FBSceneInfoScrollView () {
    UIScrollView    *   _backgroundScrollView;
    UIView          *   _constraitView;
    UIImageView     *   _backgroundImageView;
    UIImageView     *   _blurredBackgroundImageView;
    UIView          *   _foregroundContainerView;
    UIImageView     *   _topMaskImageView;
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
- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView {
    self = [super initWithFrame:frame];
    if (self) {

        _backgroundImage = backgroundImage;
        _blurredBackgroundImage = backgroundImage;
        _viewDistanceFromBottom = viewDistanceFromBottom;
        _foregroundView = foregroundView;
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [self createBackgroundView];
        [self createForegroundView];
    }
    return self;
}

- (void)scrollVerticallyToOffset:(CGFloat)offsetY {
    [_foregroundScrollView setContentOffset:CGPointMake(_foregroundScrollView.contentOffset.x, offsetY)];
}

#pragma mark - set
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect bound = CGRectOffset(frame, -frame.origin.x, -frame.origin.y);
    
    [_backgroundScrollView setFrame:bound];
    [_backgroundScrollView setContentSize:CGSizeMake(SCREEN_WIDTH + 0, SCREEN_HEIGHT + (SCREEN_HEIGHT / 2))];
    [_backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    [_constraitView setFrame:CGRectMake(0, 0, SCREEN_WIDTH + 0, SCREEN_HEIGHT + (SCREEN_HEIGHT / 2))];
    
    [_foregroundContainerView setFrame:bound];
    [_foregroundScrollView setFrame:bound];
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(bound.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
}

- (void)setViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom {
    _viewDistanceFromBottom = viewDistanceFromBottom;

    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
}

#pragma mark - 
- (void)createBackgroundView {
    //background
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_backgroundScrollView setUserInteractionEnabled:NO];
    [_backgroundScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + (SCREEN_HEIGHT / 2))];
    [self addSubview:_backgroundScrollView];
    
    _constraitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + (SCREEN_HEIGHT / 2))];
    [_backgroundScrollView addSubview:_constraitView];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_constraitView addSubview:_backgroundImageView];
    
    _blurredBackgroundImageView = [[UIImageView alloc] initWithImage:_blurredBackgroundImage];
    [_blurredBackgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_blurredBackgroundImageView setAlpha:0];
    [_constraitView addSubview:_blurredBackgroundImageView];
    
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
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
    [_foregroundScrollView addGestureRecognizer:_tapRecognizer];
    
    
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    [_foregroundScrollView addSubview:_foregroundView];
    
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
}

#pragma mark - 点击
- (void)foregroundTapped:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tappedPoint = [tapRecognizer locationInView:_foregroundScrollView];
    NSLog(@"%f", tappedPoint.y);
    if (tappedPoint.y < _foregroundScrollView.frame.size.height) {
        CGFloat ratio = _foregroundScrollView.contentOffset.y == -_foregroundScrollView.contentInset.top? 1:0;
        [_foregroundScrollView setContentOffset:CGPointMake(0, ratio * _foregroundView.frame.origin.y - _foregroundScrollView.contentInset.top) animated:YES];
    }
}


#pragma mark - Delegate
#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ratio = (scrollView.contentOffset.y + _foregroundScrollView.contentInset.top)/(_foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom);
    ratio = ratio<0?0:ratio;
    ratio = ratio>1?1:ratio;
    
    [_backgroundScrollView setContentOffset:CGPointMake(0, ratio * (SCREEN_HEIGHT / 2))];
    
    [_blurredBackgroundImageView setAlpha:ratio];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint point = *targetContentOffset;
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
