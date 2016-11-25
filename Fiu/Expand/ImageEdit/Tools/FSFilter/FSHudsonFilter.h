//
//  FSHudsonFilter.h
//  FSMeituApp
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageFourInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter5 : GPUImageFourInputFilter

@end

@interface FSHudsonFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@end