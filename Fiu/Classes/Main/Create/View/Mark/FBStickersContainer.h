//
//  FBStickersContainer.h
//  Fiu
//
//  Created by FLYang on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FBSticker.h"
#import "FBFilters.h"

@class FBStickersContainer;

@protocol FBStickerContainerDelegate <NSObject>
@optional
- (void)didRemoveStickerContainer:(FBStickersContainer *)container;

@end


@interface FBStickersContainer : UIView

@pro_weak id <FBStickerContainerDelegate> delegate;

- (void)setupSticker:(NSString *)stickerUrl;

- (void)recoveryFromSticker:(FBSticker *)sticker;

- (FBSticker *)generateSticker;

@end
