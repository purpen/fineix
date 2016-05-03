//
//	SceneInfoProduct.h
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface SceneInfoProduct : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end