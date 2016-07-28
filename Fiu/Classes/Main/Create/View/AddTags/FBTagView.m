//
//  FBTagView.m
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTagView.h"
#import "FBTagItem.h"

#define kFBDefaultColor [UIColor colorWithRed:0.38 green:0.72 blue:0.91 alpha:1]
#define kFBTextColor [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1]

@interface FBTagView()<UITextFieldDelegate, FBTagViewDelegate>

@end

@implementation FBTagView

- (instancetype)init {
    self = [super init];
    self.tagFontSize = 14;
    self.tagSpace = 10;
    self.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tagTextPadding = UIEdgeInsetsMake(3, 5, 3, 5);
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(autoAddEdtingTag)]];
    return self;
}

- (void)addTag:(NSString *)tag {
    if([self isEmptyString:tag]) {
        return;
    }
    if([self isExistTag:tag]) {
        return;
    }
    CGRect frame = CGRectZero;
    if(self.subviews && self.subviews.count > 0) {
        frame = [self.subviews lastObject].frame;
    }
    
    FBTagItem * label = [self createTagWithStyle:(self.editable ? FBTagStyleEditable : FBTagStyleShow) tag:tag];
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width, label.frame.size.height);
    
    if(self.editable) {
        [self insertSubview:label belowSubview:[self.subviews lastObject]];
    } else {
        [self addSubview:label];
    }
}

- (void)addTags:(NSArray *)tags {
    for(NSString *tag in tags) {
        [self addTag:tag];
    }
}

- (void)removeTag:(NSString *)tagString {
    for(FBTagLabel *tag in self.subviews) {
        if([self stringIsEquals:tag.text to:tagString]) {
            [tag removeFromSuperview];
            [self.delegate FBTagView:self onRemove:tag];
        }
    }
}

- (void)removeTags:(NSArray *)tags {
    for(NSString *tag in tags) {
        [self removeTag:tag];
    }
}

- (void)selectTag:(NSString *)tag {
    [self.subviews indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(FBTagItem *obj, NSUInteger idx, BOOL *stop) {
        if([self stringIsEquals:obj.text to:tag]) {
            [obj setStyle:self.editable ? FBTagStyleEditSelected : FBTagStyleShowSelected];
            return YES;
        }
        return NO;
    }];
}

- (void)selectTags:(NSArray *)tags {
    for(NSString *tag in tags) {
        [self selectTag:tag];
    }
}

- (void)unSelectTag:(NSString *)tag {
    [self.subviews indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(FBTagLabel *obj, NSUInteger idx, BOOL *stop) {
        if([self stringIsEquals:obj.text to:tag]) {
            [obj setStyle:self.editable ? FBTagStyleEditable : FBTagStyleShow];
            return YES;
        }
        return NO;
    }];
}

- (void)unSelectTags:(NSArray *)tags {
    for(NSString *tag in tags) {
        [self unSelectTag:tag];
    }
}

- (void)setEditable:(BOOL)editable {
    if(_editable == editable) {
        return;
    }
    _editable = editable;
    
    // update sub tags style
    for(FBTagItem *tagItem in self.subviews) {
        [tagItem setStyle:_editable ? FBTagStyleEditable : FBTagStyleShow];
    }
    
    if(_editable) {
        FBTagItem *v = [self.subviews lastObject];
        if(!v || v.style != FBTagStyleEditing) {
            // if has no edit style tag, add one
            FBTagItem * label = [self createTagWithStyle:FBTagStyleEditing tag:@"输入标签"];
            label.label.placeholder = @"输入标签";
            label.text = nil;
            [self addSubview:label];
        }
    } else {
        FBTagLabel *v = [self.subviews lastObject];
        if(v && v.style == FBTagStyleEditing) {
            [v removeFromSuperview];
        }
    }
}

- (FBTagItem *)createTagWithStyle:(FBTagStyle)style tag:(NSString *)tag {
    FBTagItem *label = [[FBTagItem alloc] init];
//    label.backgroundColor = [UIColor orangeColor];
    label.tagviewDelegate = self;
    label.padding = self.tagTextPadding;
    label.text = tag;
    label.label.font = [UIFont systemFontOfSize:self.tagFontSize];
    [label sizeToFit];
    [label setStyle:style];
    return label;
}


- (void)layoutSubviews {
    [UIView beginAnimations:nil context:nil];
    CGFloat paddingRight = self.padding.right;
    CGFloat cellspace = 5;
    CGFloat y = self.padding.top;
    CGFloat x = self.padding.left;
    CGRect frame;
    for(UIView *tag in self.subviews) {
        frame = tag.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        
        if(frame.origin.x + frame.size.width + paddingRight > self.frame.size.width) {
            // 换行
            frame.origin.x = self.padding.left;
            frame.origin.y = frame.origin.y + frame.size.height + cellspace;
            
            y = frame.origin.y;
        }
        
        if(frame.origin.x + frame.size.width > self.frame.size.width - paddingRight) {
            frame.size.width = self.frame.size.width - paddingRight - frame.origin.x;
        }
        
        x = frame.origin.x + frame.size.width + cellspace;
        tag.frame = frame;
    }
    CGFloat containerHeight = frame.origin.y + frame.size.height + self.padding.bottom;
    CGRect containerFrame = self.frame;
    containerFrame.size.height = containerHeight;
    self.frame = containerFrame;
    if([self.delegate respondsToSelector:@selector(FBTagView:sizeChange:)]) {
        [self.delegate FBTagView:self sizeChange:self.frame];
    }
    [UIView commitAnimations];
}

- (NSArray *)allTags {
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for(FBTagItem *tagItem in self.subviews) {
        if(tagItem.style != FBTagStyleEditing) {
            [tags addObject:tagItem.text];
        }
    }
    return tags;
}

- (void)autoAddEdtingTag {
    FBTagItem *tag = [self.subviews lastObject];
    if(tag.style == FBTagStyleEditing) {
        NSString *tagString = tag.text;
        if(![self isEmptyString:tagString]) {
            [self addTag:tagString];
            tag.text = nil;
        }
    }
}

#pragma mark - self delegate

// default style, if user don't implement style deledate
- (void)FBTagView:(FBTagView *)tag editableStyle:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:editableStyle:)]) {
        [self.delegate FBTagView:self editableStyle:tagLabel];
    } else {
        tagLabel.backgroundColor = [UIColor whiteColor];
        tagLabel.textColor = kFBDefaultColor;
        tagLabel.layer.borderColor = [kFBDefaultColor CGColor];
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.cornerRadius = tagLabel.frame.size.height / 2;
    }
}
- (void)FBTagView:(FBTagView *)tag editingStyle:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:editableStyle:)]) {
        [self.delegate FBTagView:self editingStyle:tagLabel];
    } else {
        tagLabel.backgroundColor = [UIColor clearColor];
        tagLabel.textColor = [UIColor blackColor];
        tagLabel.layer.borderColor = [[UIColor clearColor] CGColor];
        tagLabel.layer.borderWidth = 0;
        tagLabel.layer.cornerRadius = 0;
    }
}
- (void)FBTagView:(FBTagView *)tag editSelectedStyle:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:editableStyle:)]) {
        [self.delegate FBTagView:self editSelectedStyle:tagLabel];
    } else {
        tagLabel.backgroundColor = kFBDefaultColor;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.layer.borderColor = [kFBDefaultColor CGColor];
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.cornerRadius = tagLabel.frame.size.height / 2;
    }
}
- (void)FBTagView:(FBTagView *)tag showSelectedStyle:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:editableStyle:)]) {
        [self.delegate FBTagView:self showSelectedStyle:tagLabel];
    } else {
        tagLabel.backgroundColor = kFBDefaultColor;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.layer.borderColor = [kFBDefaultColor CGColor];
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.cornerRadius = tagLabel.frame.size.height / 2;
    }
}
- (void)FBTagView:(FBTagView *)tag showStyle:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:editableStyle:)]) {
        [self.delegate FBTagView:self showStyle:tagLabel];
    } else {
        tagLabel.backgroundColor = [UIColor whiteColor];
        tagLabel.textColor = kFBTextColor;
        tagLabel.layer.borderColor = [kFBTextColor CGColor];
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.cornerRadius = 10;
    }
}
// default style end

- (void)FBTagView:(FBTagView *)tag deleteOnEmpty:(FBTagLabel *)tagLabel {
    if(self.subviews.count == 1) {
        return;
    }
    FBTagLabel *selectedTag = [self.subviews objectAtIndex:self.subviews.count - 2];
    if(selectedTag.style == FBTagStyleEditable) {
        selectedTag.style = FBTagStyleEditSelected;
    } else if(selectedTag.style == FBTagStyleEditSelected) {
        NSString *tagString = selectedTag.text;
        [self removeTag:tagString];
        if([self.delegate respondsToSelector:@selector(FBTagView:onRemove:)]) {
            [self.delegate FBTagView:self onRemove:tagLabel];
        }
    }
}

- (void)FBTagView:(FBTagView *)tagview returnOnNotEmpty:(FBTagLabel *)tagLabel {
    [self autoAddEdtingTag];
}

- (void)FBTagView:(FBTagView *)tagview onSelect:(FBTagLabel *)tagLabel {
    if([self.delegate respondsToSelector:@selector(FBTagView:onSelect:)]) {
        [self.delegate FBTagView:self onSelect:tagLabel];
    }
}

- (void)FBTagView:(FBTagView *)tagview onRemove:(FBTagLabel *)tagLabel {
    [self removeTag:tagLabel.text];
    if([self.delegate respondsToSelector:@selector(FBTagView:onRemove:)]) {
        [self.delegate FBTagView:self onRemove:tagLabel];
    }
}

#pragma mark - Tool Functions

- (BOOL)isExistTag:(NSString *)tag {
    if(!self.subviews || self.subviews.count == 0) {
        return NO;
    }
    __block BOOL isExist = NO;
    NSUInteger len = self.editable ? (self.subviews.count - 1) : self.subviews.count;
    [[self.subviews subarrayWithRange:NSMakeRange(0, len)] indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(FBTagLabel *obj, NSUInteger idx, BOOL *stop) {
        isExist = [self stringIsEquals:obj.text to:tag];
        return isExist;
    }];
    return isExist;
}

- (BOOL)isEmptyString:(NSString *)string {
    if(!string){
        return NO;
    }
    string = [string stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string.length == 0;
}

- (BOOL)stringIsEquals:(NSString *)string to:(NSString *)string2 {
    return [string isEqualToString:string2];
}


@end
