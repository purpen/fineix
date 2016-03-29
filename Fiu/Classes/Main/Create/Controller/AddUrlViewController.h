//
//  AddUrlViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "AddUrlView.h"

@interface AddUrlViewController : FBPictureViewController <FBSearchDelegate, WebBtnSelectedDelegate>

@pro_strong FBSearchView                    *   searchGoods;        //  搜索框
@pro_strong AddUrlView                      *   addUrlView;         //  购物网站视图

@end
