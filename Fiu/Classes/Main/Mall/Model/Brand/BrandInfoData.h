//
//	BrandInfoData.h
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface BrandInfoData : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * bannerUrl;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger usedCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end