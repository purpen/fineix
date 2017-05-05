//
//  THNChildUserModel.h
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNChildUserModel : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) CGFloat addition;
@property (nonatomic, assign) CGFloat money;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
