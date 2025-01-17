//
//	CommentUser.h
// on 23/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface CommentUser : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * bigAvatarUrl;
@property (nonatomic, strong) NSString * homeUrl;
@property (nonatomic, strong) NSString * mediumAvatarUrl;
@property (nonatomic, strong) NSString * miniAvatarUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * smallAvatarUrl;
@property (nonatomic, assign) NSInteger symbol;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end