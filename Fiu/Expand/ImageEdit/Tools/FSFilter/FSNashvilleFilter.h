//
//  FSNashvilleFilter.h
//  FSMeituApp
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageThreeInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter1 : GPUImageTwoInputFilter



@end

@interface FSNashvilleFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource ;
}

@end