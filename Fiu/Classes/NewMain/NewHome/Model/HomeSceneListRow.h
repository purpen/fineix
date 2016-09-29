//
//	HomeSceneListRow.h
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "HomeSceneListLocation.h"
#import "HomeSceneListProduct.h"
#import "HomeSceneListUser.h"
#import "HomeSceneListComments.h"

@interface HomeSceneListRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, assign) NSInteger isCheck;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, assign) NSInteger isFavorite;
@property (nonatomic, strong) HomeSceneListLocation * location;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSArray * product;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, strong) NSString * sceneTitle;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger usedCount;
@property (nonatomic, strong) HomeSceneListUser * user;
@property (nonatomic, strong) NSArray * comments;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger viewCount;
/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *prize;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
