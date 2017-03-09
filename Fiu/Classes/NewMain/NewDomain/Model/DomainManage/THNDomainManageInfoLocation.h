//
//	THNDomainManageInfoLocation.h
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNDomainManageInfoLocation : NSObject

@property (nonatomic, strong) NSArray * coordinates;
@property (nonatomic, strong) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end