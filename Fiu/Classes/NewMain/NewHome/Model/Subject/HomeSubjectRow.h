//
//	HomeSubjectRow.h
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface HomeSubjectRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger attendCount;
@property (nonatomic, strong) NSString * bannerUrl;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger evt;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeLabel;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end