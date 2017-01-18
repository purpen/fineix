//
//	THNAllinaceContact.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNAllinaceContact : NSObject

@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * position;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
