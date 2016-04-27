//
//	CommentData.h
// on 27/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "CommentRow.h"

@interface CommentData : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, strong) NSString * pager;
@property (nonatomic, assign) NSInteger prevPage;
@property (nonatomic, strong) NSArray * rows;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalRows;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end