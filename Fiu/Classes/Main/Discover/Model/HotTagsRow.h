//
//	HotTagsRow.h
// on 27/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface HotTagsRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger childrenCount;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, assign) NSInteger leftRef;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger rightRef;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, strong) NSString * titleCn;
@property (nonatomic, strong) NSString * titleEn;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeStr;
@property (nonatomic, assign) NSInteger usedCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end