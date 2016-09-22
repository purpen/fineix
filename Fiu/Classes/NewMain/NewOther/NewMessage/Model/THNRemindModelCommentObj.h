//
//  THNRemindModelCommentObj.h
//  Fiu
//
//  Created by FLYang on 16/9/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNRemindModelCommentObj : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * coverUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
