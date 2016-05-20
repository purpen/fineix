//
//  FBShareViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "Fiu.h"

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UIView              *   topView;
@pro_strong UIButton            *   closeBtn;
@pro_strong UIButton            *   shareBtn;
@pro_strong UICollectionView    *   styleView;

@end
