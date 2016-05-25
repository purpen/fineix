//
//	ShareInfoData.h
// on 26/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "ShareInfoRow.h"

@interface ShareInfoData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSArray * rows;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end