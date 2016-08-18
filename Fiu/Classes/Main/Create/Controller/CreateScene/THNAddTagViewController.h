//
//  THNAddTagViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

typedef void(^GetAddTagsDataBlock)(NSString *text, NSString *actionTag);

@interface THNAddTagViewController : FBPictureViewController <
    FBPictureViewControllerDelegate,
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBRequest *hotTagsRequest;
@pro_strong FBRequest *usedTagsRequest;
@pro_strong FBRequest *searchRequest;
@pro_strong UITextField *tagsTextField;
@pro_strong UITableView *tagsList;
@pro_strong UITableView *searchList;
@pro_copy GetAddTagsDataBlock getAddTagsDataBlock;

@end
