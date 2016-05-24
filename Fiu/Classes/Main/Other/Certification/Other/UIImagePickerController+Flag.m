//
//  UIImagePickerController+Flag.m
//  Fiu
//
//  Created by THN-Dong on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UIImagePickerController+Flag.h"
#import <objc/runtime.h>

@implementation UIImagePickerController (Flag)

static char flagKey;
-(void)setFlag:(NSNumber *)flag{
    objc_setAssociatedObject(self,&flagKey , flag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSNumber *)flag{
    return objc_getAssociatedObject(self, &flagKey);
}

@end
