//
//	NiceDomainRow.h
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface NiceDomainRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) NSInteger ordby;
@property (nonatomic, assign) NSInteger spaceId;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * webUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
