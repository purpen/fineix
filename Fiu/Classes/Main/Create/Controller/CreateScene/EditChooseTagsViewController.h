//
//  EditChooseTagsViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FBTagView.h"
#import "FBTagItem.h"

typedef void(^GetAddTags)(NSArray * tags);

@interface EditChooseTagsViewController : FBPictureViewController <FBTagViewDelegate>

//@pro_strong UITextField
@pro_strong NSMutableArray      *   chooseTags;
@pro_strong FBTagView           *   tagEditor;
@pro_strong FBTagView           *   tagForSelect;
@pro_copy GetAddTags    getAddTags;

@end
