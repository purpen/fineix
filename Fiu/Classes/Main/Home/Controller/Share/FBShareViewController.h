//
//  FBShareViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "Fiu.h"
#import "ShareStyleView.h"
#import "ShareViewController.h"

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UIView              *   topView;
@pro_strong UIButton            *   closeBtn;
@pro_strong UIButton            *   shareBtn;
@pro_strong UICollectionView    *   styleView;
@pro_strong NSDictionary        *   dataDict;

@pro_strong ShareStyleView      *   shareView;

@end
