//
//  THNSceneImageScrollView.m
//  Fiu
//
//  Created by FLYang on 16/9/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageScrollView.h"

@interface THNSceneImageScrollView ()<UIScrollViewDelegate> {
    CGSize _imageSize;
}
@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation THNSceneImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
}

- (void)displayImage:(UIImage *)image {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.clipsToBounds = NO;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
    frame.size.height = self.bounds.size.width;
    frame.size.width = self.bounds.size.width;
    self.imageView.frame = frame;
    [self configureForImageSize:self.imageView.bounds.size];
}

- (void)networkDisplayImage:(NSString *)imageUrl {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    self.zoomScale = 1.0;
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView downloadImage:imageUrl place:[UIImage imageNamed:@""]];
    self.imageView.clipsToBounds = NO;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
    frame.size.height = self.bounds.size.width;
    frame.size.width = self.bounds.size.width;
    self.imageView.frame = frame;
    [self configureForImageSize:self.imageView.bounds.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 2.0;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
