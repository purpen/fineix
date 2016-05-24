//
//  AXModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AXModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) NSNumber *user_type;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 是否隐藏时间 */
@property (nonatomic, assign, getter=isHideTime) BOOL hideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end

