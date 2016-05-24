//
//  AddTagViewController.h
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^ChooseTagsBlock)(NSMutableArray * tilte, NSMutableArray * ids);

@interface AddTagViewController : FBPictureViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource>

@pro_strong FBRequest           *   tagRequest;         //  标签
@pro_strong FBRequest           *   usedTagsRequest;    //  使用过的标签
@pro_strong FBRequest           *   hotTagsRequest;     //  热门标签

@pro_strong UIView              *   menuView;           //  导航菜单
@pro_strong UIView              *   categoryView;       //  分类菜单
@pro_strong UILabel             *   menuLine;
@pro_strong UILabel             *   categoryLine;
@pro_strong UIButton            *   menuBtn;
@pro_strong UIButton            *   categoryBtn;
@pro_strong UIView              *   noneView;
@pro_strong UIView              *   centerView;         
@pro_strong UICollectionView    *   chooseTagView;      //  选择的标签列表
@pro_strong UIButton            *   clearTagsBtn;       //  清除所选标签
@pro_strong UICollectionView    *   usedTagView;        //  使用过／热门的标签
@pro_strong UITableView         *   tagListTable;       //
@pro_strong UIButton            *   sureBtn;            //  确定按钮
@pro_strong UIScrollView        *   rollView;

@pro_strong ChooseTagsBlock         chooseTagsBlock;

@end
