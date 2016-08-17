//
//  THNContentViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

typedef enum {
    CollectionTypeGood = 10,
    CollectionTypeSence = 12
} CollectionType;

@interface THNContentViewController : FBViewController

/**  */
@property (nonatomic, assign) CollectionType type;

@end
