//
//  THNShareView.h
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNShareCollectionView.h"

@interface THNShareView : UIView 

@property (nonatomic, strong) THNShareCollectionView *shareCollectionView;

+ (void)openShareView;

@end
