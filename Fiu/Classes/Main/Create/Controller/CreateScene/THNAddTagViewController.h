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

@property (nonatomic, strong) FBRequest *hotTagsRequest;
@property (nonatomic, strong) FBRequest *usedTagsRequest;
@property (nonatomic, strong) FBRequest *searchRequest;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITableView *tagsList;
@property (nonatomic, strong) UITableView *searchList;
@property (nonatomic, copy) GetAddTagsDataBlock getAddTagsDataBlock;

@end
