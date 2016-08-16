//
//  FBImageScrollView.m
//  Fiu
//
//  Created by FLYang on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBImageScrollView.h"
#define rad(angle) ((angle) / 180.0 * M_PI)

@interface FBImageScrollView () <UIScrollViewDelegate> {
    CGSize _imageSize;
}
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation FBImageScrollView

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

- (UIImage *)capture {
    CGRect visibleRect = [self _calcVisibleRectForCropArea];
    CGAffineTransform rectTransform = [self _orientationTransformedRectOfImage:self.imageView.image];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    CGImageRef ref = CGImageCreateWithImageInRect([self.imageView.image CGImage], visibleRect);
    UIImage* cropped = [[UIImage alloc] initWithCGImage:ref scale:self.imageView.image.scale orientation:self.imageView.image.imageOrientation] ;
    CGImageRelease(ref);
    ref = NULL;
    return cropped;
}

static CGRect FBScaleRect(CGRect rect, CGFloat scale) {
    return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}

- (CGRect)_calcVisibleRectForCropArea {
    CGFloat sizeScale = self.imageView.image.size.width / self.imageView.frame.size.width;
    sizeScale *= self.zoomScale;
    CGRect visibleRect = [self convertRect:self.bounds toView:self.imageView];
    return visibleRect = FBScaleRect(visibleRect, sizeScale);
}

- (CGAffineTransform)_orientationTransformedRectOfImage:(UIImage *)img {
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}


- (void)displayImage:(UIImage *)image {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.clipsToBounds = NO;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
    if (image.size.height > image.size.width) {
        frame.size.width = self.bounds.size.width;
        frame.size.height = (self.bounds.size.width / image.size.width) * image.size.height;
    } else {
        frame.size.height = self.bounds.size.height;
        frame.size.width = (self.bounds.size.height / image.size.height) * image.size.width;
    }
    self.imageView.frame = frame;
    [self configureForImageSize:self.imageView.bounds.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    
    //to center
    if (imageSize.width > imageSize.height) {
        self.contentOffset = CGPointMake(imageSize.width/4, 0);
    } else if (imageSize.width < imageSize.height) {
        self.contentOffset = CGPointMake(0, imageSize.height/4);
    }
    
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
