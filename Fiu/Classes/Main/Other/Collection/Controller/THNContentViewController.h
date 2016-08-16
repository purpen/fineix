//
//  THNContentViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

typedef enum {
    CollectionTypeGood = 10,
    CollectionTypeSence = 12
} CollectionType;

@interface THNContentViewController : THNViewController

/**  */
@property (nonatomic, assign) CollectionType type;

@end
