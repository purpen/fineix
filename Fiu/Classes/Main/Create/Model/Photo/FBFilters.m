//
//  FBFilters.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBFilters.h"

@interface FBFilters ()

@property (nonatomic, strong, readwrite) UIImage *filterImg;

@end

@implementation FBFilters

- (instancetype)initWithImage:(UIImage *)image filterName:(NSString *)name {
    self = [super init];
    if (self) {
        //  转换格式
        CIImage *ciImg = [[CIImage alloc] initWithCGImage:image.CGImage];
        
        //  创建滤镜
        CIFilter *filter = [CIFilter filterWithName:name
                                      keysAndValues:kCIInputImageKey,ciImg ,nil];
        
        [filter setDefaults];
        
        //  绘制内容
        CIContext *context = [CIContext contextWithOptions:nil];
        
        //  渲染输出
        CIImage *outFilterImg = filter.outputImage;
        
        //  CGImage句柄
        CGImageRef cgImg = [context createCGImage:outFilterImg fromRect:outFilterImg.extent];
        
        _filterImg = [UIImage imageWithCGImage:cgImg scale:image.scale orientation:image.imageOrientation];
        
        // 释放CGImage句柄
        CGImageRelease(cgImg);
    }
    return self;
}

@end
