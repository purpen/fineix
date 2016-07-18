//
//  FBTagView.h
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBTagView;
@class FBTagLabel;

typedef NS_ENUM(NSInteger, FBTagStyle) {
    FBTagStyleEditable,     // tag editor can edit, normal status
    FBTagStyleEditing,      // tag editor can edit, input status
    FBTagStyleEditSelected, // tag editor can edit, select status
    FBTagStyleShow,         // tag editor can't edit, normal status
    FBTagStyleShowSelected  // tag editor can't edit, select stauts
};

@protocol FBTagViewDelegate <NSObject>
@optional

- (void)FBTagView:(FBTagView *)tagview sizeChange:(CGRect)newSize;

- (void)FBTagView:(FBTagView *)tagview onSelect:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview onRemove:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview editableStyle:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview editingStyle:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview editSelectedStyle:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview showStyle:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview showSelectedStyle:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview deleteOnEmpty:(FBTagLabel *)tagLabel;

- (void)FBTagView:(FBTagView *)tagview returnOnNotEmpty:(FBTagLabel *)tagLabel;
@end

#pragma mark - FBTagView

@interface FBTagView : UIView

//@property(nonatomic, strong) FBTagItem * itemLable;
@property(nonatomic, assign) BOOL editable;
@property(nonatomic, assign) CGFloat tagSpace;
@property(nonatomic, assign) CGFloat tagFontSize;
@property(nonatomic) UIEdgeInsets padding;
@property(nonatomic) UIEdgeInsets tagTextPadding;

@property(nonatomic, assign) id<FBTagViewDelegate> delegate;

- (void)addTag:(NSString *)tag;
- (void)addTags:(NSArray *)tags;

- (void)removeTag:(NSString *)tag;
- (void)removeTags:(NSArray *)tags;

- (void)selectTag:(NSString *)tag;
- (void)selectTags:(NSArray *)tags;

- (void)unSelectTag:(NSString *)tag;
- (void)unSelectTags:(NSArray *)tags;

- (void)autoAddEdtingTag;
- (NSArray *)allTags;

@end
