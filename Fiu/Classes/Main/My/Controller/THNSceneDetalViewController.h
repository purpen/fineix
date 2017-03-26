//
//  THNSceneDetalViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.


//

#import "FBViewController.h"

@protocol THNSceneDetalViewControllerDelegate <NSObject>

-(void)updatScenceNum:(NSInteger)num andDeleteReferenceNo:(NSInteger)reference;

@end

@interface THNSceneDetalViewController : FBViewController

/**  */
@property(nonatomic,copy) NSString *sceneDetalId;
@property(nonatomic,assign) NSInteger referenceNo;
@property(nonatomic,weak) id<THNSceneDetalViewControllerDelegate> sceneDelegate;

@end
