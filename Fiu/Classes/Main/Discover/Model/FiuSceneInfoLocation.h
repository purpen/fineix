//
//	FiuSceneInfoLocation.h
// on 26/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FiuSceneInfoLocation : NSObject

@property (nonatomic, strong) NSArray * coordinates;
@property (nonatomic, strong) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end