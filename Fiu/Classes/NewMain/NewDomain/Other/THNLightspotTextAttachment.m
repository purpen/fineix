//
//  THNLightspotTextAttachment.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNLightspotTextAttachment.h"
#import "THNMacro.h"

@implementation THNLightspotTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {

    return CGRectMake(15, 0, SCREEN_WIDTH - 30, 180);
}

@end
