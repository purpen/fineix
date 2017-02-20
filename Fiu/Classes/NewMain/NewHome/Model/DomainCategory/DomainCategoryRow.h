//
//	DomainCategoryRow.h
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface DomainCategoryRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSObject * appCoverUrl;
@property (nonatomic, strong) NSString * backUrl;
@property (nonatomic, assign) NSInteger domain;
@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger orderBy;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, strong) NSArray * subCategories;
@property (nonatomic, assign) NSInteger subCount;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger totalCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
