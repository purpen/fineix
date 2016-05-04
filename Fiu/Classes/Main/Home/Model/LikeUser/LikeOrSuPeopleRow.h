//
//	LikeOrSuPeopleRow.h
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "LikeOrSuPeopleUser.h"

@interface LikeOrSuPeopleRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger event;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) LikeOrSuPeopleUser * user;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end