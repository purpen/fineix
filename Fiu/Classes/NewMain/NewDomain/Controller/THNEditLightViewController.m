//
//  THNEditLightViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNEditLightViewController.h"
#import <TYAlertController/TYAlertController.h>
#import "THNLightspotTextAttachment.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface THNEditLightViewController () {
    CGFloat   _keyboardH;         //  弹出的键盘高度
}

/**
 更新内容的范围
 */
@property (nonatomic, assign) NSRange contentNewRange;

/**
 更新内容的文字
 */
@property (nonatomic , strong) NSString *contentNewText;

/**
 删除文字
 */
@property (nonatomic, assign) BOOL isDelete;

@end

@implementation THNEditLightViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self set_addNotification];
    [self setViewUI];
}

#pragma mark 输入监测的代理
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.attributedText.length > 0) {
        self.contentPlaceholder.hidden = YES;
    } else {
        self.contentPlaceholder.hidden = NO;
    }
    
    NSInteger textLength = textView.attributedText.length - self.contentAttributed.length;
    
    if (textLength > 0) {
        self.isDelete = NO;
        self.contentNewRange = NSMakeRange(textView.selectedRange.location - textLength, textLength);
        self.contentNewText = [textView.text substringWithRange:self.contentNewRange];
        
    } else {
        self.isDelete = YES;
    }
    
    [self thn_screeningInputHighlightingText:textView];
}

- (void)thn_screeningInputHighlightingText:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //  获取高亮部分
    UITextPosition *isHighlight = [textView positionFromPosition:selectedRange.start offset:0];
    //  没有高亮表示输入完成
    if (!isHighlight) {
        [self setContentInputBoxTextStyle:textView];
    }
}

#pragma mark 设置正文内容的文本样式
- (void)setContentInputBoxTextStyle:(UITextView *)textView {
    [self set_initAttributedString];
    
    if (self.isDelete) {
        return;
    }
    
    NSDictionary *attributesDict = [self set_attributesDictionary];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.contentNewText attributes:attributesDict];
    [self.contentAttributed replaceCharactersInRange:self.contentNewRange withAttributedString:attributedString];
    self.contentInputBox.attributedText = self.contentAttributed;
    self.contentInputBox.selectedRange = NSMakeRange(self.contentNewRange.location + self.contentNewRange.length, 0);
}

- (NSDictionary *)set_attributesDictionary {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    
    NSDictionary *attributesDict = @{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                                     };
    return attributesDict;
}

#pragma mark - 设置视图
- (void)setViewUI {
    [self.view addSubview:self.contentInputBox];

    [self.view addSubview:self.contentPlaceholder];
    [_contentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentInputBox);
        make.top.right.equalTo(_contentInputBox).with.offset(15);
        make.left.equalTo(_contentInputBox.mas_left).with.offset(19);
        make.height.mas_equalTo(@19);
    }];
}

- (UITextView *)contentInputBox {
    if (!_contentInputBox) {
        _contentInputBox = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _contentInputBox.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0f];
        _contentInputBox.textAlignment = NSTextAlignmentLeft;
        _contentInputBox.inputAccessoryView = self.accessoryView;
        _contentInputBox.font = [UIFont systemFontOfSize:14.0f];
        _contentInputBox.textColor = [UIColor colorWithHexString:@"#222222"];
        _contentInputBox.delegate = self;
        _contentInputBox.showsVerticalScrollIndicator = NO;
        _contentInputBox.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _contentInputBox;
}

- (UILabel *)contentPlaceholder {
    if (!_contentPlaceholder) {
        _contentPlaceholder = [[UILabel alloc] init];
        _contentPlaceholder.font = [UIFont systemFontOfSize:14.0f];
        _contentPlaceholder.textColor = [UIColor colorWithHexString:@"#666666" alpha:1.0f];
        _contentPlaceholder.textAlignment = NSTextAlignmentLeft;
        _contentPlaceholder.text = @"输入亮点文字";
    }
    return _contentPlaceholder;
}

#pragma mark - 调整输入框的高度
- (void)changeContentInputBoxHeight:(CGFloat)keyboardH {
    CGRect inputBoxFrame = self.contentInputBox.frame;
    inputBoxFrame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 70 - keyboardH);
    self.contentInputBox.frame = inputBoxFrame;
}

#pragma mark - 键盘工具操作
- (THNAccessoryView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[THNAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _accessoryView.delegate = self;
    }
    return _accessoryView;
}

#pragma mark 取消键盘响应
- (void)thn_writeInputBoxResignFirstResponder {
    [self.contentInputBox resignFirstResponder];
}

#pragma mark 内容插入图片
- (void)thn_writeInputBoxInsertImage {
    [self openImagePickerChoosePhoto];
}

- (void)openImagePickerChoosePhoto {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"插入图片" message:nil];
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"拍照" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self takePhoto];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"本地相册" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self openPhotoLibrary];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark 打开相册
- (void)openPhotoLibrary {
    [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 获取图片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self insertImageOfTheTextView:self.contentInputBox withImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 指定位置插入图片
- (void)insertImageOfTheTextView:(UITextView *)textView withImage:(UIImage *)image {
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        return;
    }
    
    THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
    attachment.image = image;
    
    NSAttributedString *imageAttributedString = [self insertImageDoneAutoReturn:[NSAttributedString attributedStringWithAttachment:attachment]];
    [textView.textStorage insertAttributedString:imageAttributedString atIndex:textView.selectedRange.location];
    textView.selectedRange = NSMakeRange(textView.selectedRange.location + 3, 0);
    
    [self set_initAttributedString];
}

#pragma mark - 插入图片后换行
- (NSAttributedString *)insertImageDoneAutoReturn:(NSAttributedString *)imageAttributedString {
    NSAttributedString *returnAttributedString = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:imageAttributedString];
    [attributedString appendAttributedString:returnAttributedString];
    [attributedString insertAttributedString:returnAttributedString atIndex:0];
    [attributedString addAttributes:[self set_attributesDictionary] range:NSMakeRange(0, 3)];
    return attributedString;
}

#pragma mark - 遍历获取文本内容中的图片数量
- (NSInteger)getTextAttachmentImageCount {
    [self.imageAttachmentMarr removeAllObjects];
    [self.contentInputBox.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                    inRange:NSMakeRange(0, self.contentInputBox.attributedText.length)
                                                    options:NSAttributedStringEnumerationReverse
                                                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                                     if (value && [value isKindOfClass:[THNLightspotTextAttachment class]]) {
                                                         [self.imageAttachmentMarr addObject:value];
                                                     }
                                                 }];
    return self.imageAttachmentMarr.count;
}

#pragma mark - 初始化字体样式
- (void)set_initAttributedString {
    self.contentAttributed = nil;
    
    self.contentAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentInputBox.attributedText];
    if (self.contentInputBox.textStorage.length > 0) {
        self.contentPlaceholder.hidden = YES;
        [self.contentInputBox becomeFirstResponder];
    } else {
        self.contentPlaceholder.hidden = NO;
    }
}

#pragma mark - 监测键盘是否启用
- (void)set_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thn_getKeyboardFrameHeightOfShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thn_getKeyboardFrameHeightOfHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘弹出
- (void)thn_getKeyboardFrameHeightOfShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardH = keyboardRect.size.height;
    
    [self changeContentInputBoxHeight:_keyboardH];
}

#pragma mark 键盘落下
- (void)thn_getKeyboardFrameHeightOfHide:(NSNotification *)aNotification {
    [self changeContentInputBoxHeight:0.0f];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"亮点";
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"编辑" image:@""];
}

#pragma mark -
- (NSMutableArray *)imageAttachmentMarr {
    if (!_imageAttachmentMarr) {
        _imageAttachmentMarr = [NSMutableArray array];
    }
    return _imageAttachmentMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
