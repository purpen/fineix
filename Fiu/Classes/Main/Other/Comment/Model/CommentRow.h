//
//	CommentRow.h
// on 23/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "CommentReplyComment.h"
#import "CommentUser.h"

@interface CommentRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, assign) NSInteger inventedLoveCount;
@property (nonatomic, assign) NSInteger isReply;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) CommentReplyComment * replyComment;
@property (nonatomic, strong) NSString * replyId;
@property (nonatomic, assign) NSInteger replyUserId;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger subType;
@property (nonatomic, strong) NSString * targetId;
@property (nonatomic, strong) NSObject * targetUser;
@property (nonatomic, assign) NSInteger targetUserId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, strong) CommentUser * user;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end