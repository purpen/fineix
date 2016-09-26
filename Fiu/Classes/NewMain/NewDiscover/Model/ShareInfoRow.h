//
//	ShareInfoRow.h
// on 26/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface ShareInfoRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger assetType;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) NSObject * coverId;
@property (nonatomic, strong) NSString * createdOn;
@property (nonatomic, strong) NSString * highContent;
@property (nonatomic, strong) NSString * highTitle;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * kindName;
@property (nonatomic, strong) NSString * oid;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSObject * tid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updatedOn;
@property (nonatomic, strong) NSString * userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
