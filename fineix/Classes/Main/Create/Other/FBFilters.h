//
//  FBFilters.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fineix.h"

@interface FBFilters : NSObject

@property (nonatomic, strong, readonly) UIImage         *   filterImg;      

- (instancetype)initWithImage:(UIImage *)image filterName:(NSString *)name;

@end
