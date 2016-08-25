//
//  BrandListModel.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandListModel : NSObject

@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * kindLabel;
@property (nonatomic, assign) NSInteger selfRun;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * bannerUrl;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * stick;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger usedCount;
@property (nonatomic, strong) NSString * mark;
@property (nonatomic, strong) NSString * content;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
