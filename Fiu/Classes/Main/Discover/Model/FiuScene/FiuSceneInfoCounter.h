//
//	FiuSceneInfoCounter.h
// on 27/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FiuSceneInfoCounter : NSObject

@property (nonatomic, assign) NSInteger alertCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, assign) NSInteger noticeCount;
@property (nonatomic, assign) NSInteger peopleCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end