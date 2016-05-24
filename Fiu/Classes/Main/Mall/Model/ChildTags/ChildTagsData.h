//
//	ChildTagsData.h
// on 5/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "ChildTagsTag.h"

@interface ChildTagsData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSArray * tags;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end