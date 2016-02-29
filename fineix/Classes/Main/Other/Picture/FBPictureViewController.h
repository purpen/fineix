//
//  FBPictureViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"
#import "Masonry.h"

@interface FBPictureViewController : UIViewController

@pro_strong UIScrollView    *   navRollView;    //  顶部滚动栏
@pro_strong NSMutableArray  *   navTitleArr;    //  顶部标题数组
@pro_strong UIButton        *   cancelBtn;      //  取消按钮
@pro_strong UIButton        *   backBtn;        //  返回按钮
@pro_strong UIButton        *   doneBtn;        //  完成发布按钮

//  添加导航视图
- (void)addNavView:(NSArray *)titleArr;

@end
