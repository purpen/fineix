//
//  CommentView.h
//  parrot
//
//  Created by THN-Huangfei on 16/1/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const commentHeight;

@class CommentView;
@protocol CommentViewDelegate <NSObject>

@optional
- (void)commentTextViewDidBeginEditing:(CommentView *)commentView;
- (void)commentTextViewDidEndEditing:(CommentView *)commentView;

@end

@interface CommentView : UIView

@property (nonatomic, weak) id<CommentViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic, assign) NSInteger starInt;
@property (nonatomic, assign) NSInteger index;

@end
