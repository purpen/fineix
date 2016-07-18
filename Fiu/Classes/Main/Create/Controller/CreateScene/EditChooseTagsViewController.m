//
//  EditChooseTagsViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditChooseTagsViewController.h"

static NSInteger EditorViewTag = 1;
static NSInteger SelectViewTag = 2;

@interface EditChooseTagsViewController ()

@end

@implementation EditChooseTagsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tagEditor];
}

#pragma mark - 编辑标签视图
- (FBTagView *)tagEditor {
    if (!_tagEditor) {
        _tagEditor = [[FBTagView alloc] init];
        _tagEditor.editable = YES;
        _tagEditor.delegate = self;
        _tagEditor.tag = EditorViewTag;
        _tagEditor.backgroundColor = [UIColor whiteColor];
        [_tagEditor addTags:[self.chooseTags copy]];
        _tagEditor.frame = CGRectMake(0, 50, SCREEN_WIDTH, 0);
    }
    return _tagEditor;
}

#pragma mark - delegate functions
- (void)FBTagView:(FBTagView *)tagview onSelect:(FBTagLabel *)tagLabel {
    if(tagview.tag == SelectViewTag) {
        if(tagLabel.style == FBTagStyleShowSelected) {
            [self.tagEditor removeTag:tagLabel.text];
            [tagview unSelectTag:tagLabel.text];
        } else {
            [self.tagEditor addTag:tagLabel.text];
            [tagview selectTag:tagLabel.text];
        }
    }
}

- (void)FBTagView:(FBTagView *)tagview onRemove:(FBTagLabel *)tagLabel {
    if(tagview.tag == EditorViewTag) {
        [self.tagForSelect unSelectTag:tagLabel.text];
    }
}

#pragma mark - 设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"editTagsVC", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCloseBtn];
    [self addDoneButton];
    [self.doneBtn setTitle:NSLocalizedString(@"Done", nil) forState:(UIControlStateNormal)];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(editTagsDone) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)editTagsDone {
    self.getAddTags([self.tagEditor allTags]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
