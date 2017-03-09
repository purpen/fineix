//
//	THNDomainManageInfoUser.h
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNDomainManageInfoUser : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * expertInfo;
@property (nonatomic, strong) NSString * expertLabel;
@property (nonatomic, assign) NSInteger isExpert;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * nickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end