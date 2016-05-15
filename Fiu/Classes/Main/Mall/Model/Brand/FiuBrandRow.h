//
//	FiuBrandRow.h
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "FiuBrandId.h"

@interface FiuBrandRow : NSObject

@property (nonatomic, strong) FiuBrandId * idField;
@property (nonatomic, assign) NSInteger brandsSizeType;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * stick;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger usedCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end