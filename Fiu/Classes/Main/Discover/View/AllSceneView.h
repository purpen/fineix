//
//  AllSceneView.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface AllSceneView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UICollectionView        *   allSceneView;   //  全部的情景

@end
