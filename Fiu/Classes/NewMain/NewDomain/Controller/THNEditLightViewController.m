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
#import <SDWebImage/UIImage+MultiFormat.h>

static NSInteger const MAX_IMAGE = 10;
static NSString *const URLUploadAsset = @"/common/upload_asset";
static NSString *const URLSceneSave = @"/scene_scene/save";

@interface THNEditLightViewController () {
    NSString *_domainId;          //  地盘id
    CGFloat   _keyboardH;         //  弹出的键盘高度
    NSInteger _currentIndex;      //  当前的位置
    NSInteger _insertLocation;    //  插入图片的位置
    NSInteger _deleteLenght;      //  删除的长度
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

/**
 保存更改的图片URL
 */
@property (nonatomic, strong) NSMutableArray *insertImageMarr;

/**
 保存图文数据的数组
 */
@property (nonatomic, strong) NSMutableArray *uploadDataMarr;

/**
 图片插入的位置
 */
@property (nonatomic, strong) NSMutableArray *insertIndexMarr;

/**
 保存图片元素的数组
 */
@property (nonatomic, strong) NSMutableArray *imageAttachmentMarr;

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
    
    _insertLocation = 0;
    _deleteLenght = 0;
    
    _domainId = self.infoData ? [NSString stringWithFormat:@"%zi", self.infoData.idField] : @"";
    
    [self set_addNotification];
    [self set_initAttributedString];
    [self setViewUI];
}

#pragma mark - 默认展示亮点
- (void)thn_setBrightSpotData:(NSArray *)model {
    [self thn_removeAllObjects];

    NSMutableArray *totalTextMarr = [NSMutableArray array];
    
    for (NSString *str in model) {
        //  文字内容
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
            [totalTextMarr addObject:textStr];
        }
        
        //  图片内容
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
            [totalTextMarr addObject:imageStr];
        }
    }

    NSString *totalText = [totalTextMarr componentsJoinedByString:@""];
    
    if (self.imageMarr.count > 0) {
        for (NSString *imageUrl in self.imageMarr) {
            NSInteger imageLocation = [totalText rangeOfString:imageUrl].location;
            [self.insertIndexMarr addObject:[NSString stringWithFormat:@"%zi", imageLocation]];
            totalText = [totalText stringByReplacingOccurrencesOfString:imageUrl withString:@"^"];
        }
    }
    
    [self.uploadDataMarr addObjectsFromArray:model];
    [self getAttributedStringWithString:totalText];
}

- (void)getAttributedStringWithString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"^" withString:@""];
    
    NSDictionary *attributesDict = [self set_attributesDictionary];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesDict];
    self.contentInputBox.attributedText = attributedString;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"图片加载中..."];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
            NSString *imageUrl = self.imageMarr[idx];
            
            THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
            attachment.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            attachment.imageURL = imageUrl;
            
            [self.insertImageMarr addObject:imageUrl];
            [self.imageAttachmentMarr addObject:attachment];
            
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedString insertAttributedString:imageAttributedString atIndex:[self.insertIndexMarr[idx] integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentInputBox.attributedText = attributedString;
                [self set_initAttributedString];
            });
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

#pragma mark 输入监测的代理
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.attributedText.length > 0) {
        self.contentPlaceholder.hidden = YES;
    } else {
        self.contentPlaceholder.hidden = NO;
    }
    
    NSInteger textLength = textView.attributedText.length - self.contentAttributed.length;
    NSInteger selectedLoc = textView.selectedRange.location;
    
    if (textLength > 0) {
        self.isDelete = NO;
        self.contentNewRange = NSMakeRange(textView.selectedRange.location - textLength, textLength);
        self.contentNewText = [textView.text substringWithRange:self.contentNewRange];
        
    } else {
        [self deleteImage:selectedLoc];
        self.isDelete = YES;
    }
    
    [self thn_screeningInputHighlightingText:textView];
}

#pragma mark - 删除指定位置的图片
- (void)deleteImage:(NSInteger)index {
    NSString *selecterIndex = [NSString stringWithFormat:@"%zi", index];
    if ([self.insertIndexMarr containsObject:selecterIndex]) {
        NSInteger arrIndex = [self.insertIndexMarr indexOfObject:selecterIndex];
        NSString *imageURL = [NSString stringWithFormat:@"[img]:!%@", [self.insertImageMarr objectAtIndex:arrIndex]];
        NSLog(@"4 删除的下标----- %zi", arrIndex);
        NSLog(@"5 删除的URL----- %@", imageURL);
        
        [self.uploadDataMarr removeObject:imageURL];
        [self.insertIndexMarr removeObject:selecterIndex];
        [self.insertImageMarr removeObjectAtIndex:arrIndex];
        [self.imageAttachmentMarr removeObjectAtIndex:arrIndex];
    }
    
    NSLog(@"6 数据数组------ %@", self.uploadDataMarr);
}

- (void)thn_screeningInputHighlightingText:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //  获取高亮部分
    UITextPosition *isHighlight = [textView positionFromPosition:selectedRange.start offset:0];
    //  没有高亮表示输入完成
    if (!isHighlight) {
        if (textView.text.length == 0) {
            [self dismissEditDoneButton];
        } else {
            [self showEditDoneButton];
        }
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
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *attributesDict = @{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                                     };
    return attributesDict;
}

#pragma mark - 清空数据
- (void)thn_removeAllObjects {
    [self.insertImageMarr removeAllObjects];
    [self.imageAttachmentMarr removeAllObjects];
    [self.uploadDataMarr removeAllObjects];
    [self.insertIndexMarr removeAllObjects];
}

#pragma mark - 设置视图
- (void)setViewUI {
    [self.navView addSubview:self.doneButton];
    
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
    if (self.imageAttachmentMarr.count >= MAX_IMAGE) {
        [SVProgressHUD showInfoWithStatus:@"图片数量不能超过十张"];
        return;
    }
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

#pragma mark 内容位置插入图片对象
- (void)insertImageOfTheTextView:(UITextView *)textView withImage:(UIImage *)image {
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        return;
    }
    
    [self.accessoryView thn_hiddenUploadImage:NO];
    
    THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
    attachment.image = image;
    
    [self addInsertImageLocation:textView.selectedRange.location withAttachment:attachment];
    
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
    [textView.textStorage insertAttributedString:imageAttributedString atIndex:textView.selectedRange.location];
    textView.selectedRange = NSMakeRange(textView.selectedRange.location + 1, 0);
    [self.contentInputBox becomeFirstResponder];
    
    [self showEditDoneButton];
    [self set_initAttributedString];
}

#pragma mark - 插入图片并保存位置
- (void)addInsertImageLocation:(NSInteger)location withAttachment:(THNLightspotTextAttachment *)attachment {
    NSString *locationStr = [NSString stringWithFormat:@"%zi", location];
    [self.insertIndexMarr addObject:locationStr];

    [self.insertIndexMarr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        } else if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else
            return NSOrderedSame;
    }];
    
    NSInteger marrIndex = [self.insertIndexMarr indexOfObject:locationStr];
    [self.imageAttachmentMarr insertObject:attachment atIndex:marrIndex];
    
    [self thn_networkUploadAsset:attachment.image saveIndex:marrIndex];
}

#pragma mark - 初始化字体样式
- (void)set_initAttributedString {
    self.contentAttributed = nil;
    
    self.contentAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentInputBox.attributedText];
    if (self.contentInputBox.textStorage.length > 0) {
        self.contentPlaceholder.hidden = YES;
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

#pragma mark - 调整输入框的高度
- (void)changeContentInputBoxHeight:(CGFloat)keyboardH {
    CGRect inputBoxFrame = self.contentInputBox.frame;
    inputBoxFrame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 70 - keyboardH);
    self.contentInputBox.frame = inputBoxFrame;
}

#pragma mark - 遍历获取文本内容中的图片以及位置
- (void)getTextAttachmentImageObject {
    [self.imageAttachmentMarr removeAllObjects];
    [self.insertIndexMarr removeAllObjects];
    [self.contentInputBox.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                    inRange:NSMakeRange(0, self.contentInputBox.attributedText.length)
                                                    options:NSAttributedStringEnumerationReverse
                                                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                                     if (value && [value isKindOfClass:[THNLightspotTextAttachment class]]) {
                                                         [self.imageAttachmentMarr addObject:value];
                                                         [self.insertIndexMarr addObject:[NSString stringWithFormat:@"%zi", range.location]];
                                                     }
                                                 }];
}

#pragma mark - 拆分编辑后的文字
- (void)thn_splitTextAndImageDoneUpload {
    //[self.uploadDataMarr removeAllObjects];
    [self.contentInputBox resignFirstResponder];
    
    NSString *totalText = self.contentInputBox.text;
    
    if (self.imageAttachmentMarr.count == 0) {
        [self.uploadDataMarr addObject:[NSString stringWithFormat:@"[text]:!%@", totalText]];
        
    } else {
        NSInteger beginLocation = -1, textLength = 0, totalLength = self.contentInputBox.attributedText.length;
        
        for (NSInteger idx = self.insertIndexMarr.count; idx > 0; -- idx) {
            
            NSInteger imageLocation = [self.insertIndexMarr[idx - 1] integerValue];
            NSInteger textlocation = imageLocation - 1;
            textLength = textlocation - beginLocation;
            
            NSLog(@"textLength --- %zi,  ==%zi",textLength, totalLength - textLength);
            
            NSLog(@"imageLocation --- %zi,  textlocation === %zi, totalLength === %zi", imageLocation, textlocation, totalLength);
            
            NSString *text = [NSString stringWithFormat:@"[text]:!%@" ,[totalText substringWithRange:NSMakeRange(beginLocation + 1, textLength)]];
            
            beginLocation = imageLocation;
            
            [self.uploadDataMarr addObject:text];
        }
    }
}

#pragma mark - 上传图片
- (void)thn_networkUploadAsset:(UIImage *)image saveIndex:(NSInteger)index {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    NSString *img64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    self.uploadRequest = [FBAPI postWithUrlString:URLUploadAsset requestDictionary:@{@"type":@"2", @"id":_domainId, @"tmp":img64Str} delegate:self];
    [self.uploadRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *data = [result valueForKey:@"data"];
        NSString *uploadImageUrl = data[@"filepath"][@"huge"];
        if (uploadImageUrl.length) {
            [self.insertImageMarr insertObject:uploadImageUrl atIndex:index];
        }
        
        [self.accessoryView thn_hiddenUploadImage:YES];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 发布更新的内容
- (void)thn_networlUploadLightData:(NSMutableArray *)dataMarr {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataMarr options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.saveRequest = [FBAPI postWithUrlString:URLSceneSave requestDictionary:@{@"id":_domainId, @"bright_spot":json} delegate:self];
    [self.saveRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:(SVProgressHUDMaskTypeBlack)];
            [self dismissEditDoneButton];
            [self.contentInputBox resignFirstResponder];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败" maskType:(SVProgressHUDMaskTypeBlack)];
        NSLog(@"-- %@ --", [error localizedDescription]);
    }];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"亮点";
}

#pragma mark -
- (NSMutableArray *)imageAttachmentMarr {
    if (!_imageAttachmentMarr) {
        _imageAttachmentMarr = [NSMutableArray array];
    }
    return _imageAttachmentMarr;
}

- (NSMutableArray *)textMarr {
    if (!_textMarr) {
        _textMarr = [NSMutableArray array];
    }
    return _textMarr;
}

- (NSMutableArray *)imageMarr {
    if (!_imageMarr) {
        _imageMarr = [NSMutableArray array];
    }
    return _imageMarr;
}

- (NSMutableArray *)imageIndexMarr {
    if (!_imageIndexMarr) {
        _imageIndexMarr = [NSMutableArray array];
    }
    return _imageIndexMarr;
}

- (NSMutableArray *)insertImageMarr {
    if (!_insertImageMarr) {
        _insertImageMarr = [NSMutableArray array];
    }
    return _insertImageMarr;
}

- (NSMutableArray *)uploadDataMarr {
    if (!_uploadDataMarr) {
        _uploadDataMarr = [NSMutableArray array];
    }
    return _uploadDataMarr;
}

- (NSMutableArray *)insertIndexMarr {
    if (!_insertIndexMarr) {
        _insertIndexMarr = [NSMutableArray array];
    }
    return _insertIndexMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 发布按钮
- (void)showEditDoneButton {
    self.doneButton.hidden = NO;
}

- (void)dismissEditDoneButton {
    self.doneButton.hidden = YES;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 54, 20, 44, 44)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_doneButton setTitle:@"发布" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _doneButton.hidden = YES;
    }
    return _doneButton;
}

- (void)doneButtonClick:(UIButton *)button {
    if ([_domainId isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"获取地盘信息失败，请重试"];
        return;
    }
    
    //[self thn_splitTextAndImageDoneUpload];
    
//    NSLog(@"发布的数据 ====== %@", self.uploadDataMarr);
    NSLog(@"图片URL====== %@", self.insertImageMarr);
    NSLog(@"插入元素====== %@", self.imageAttachmentMarr);
    NSLog(@"图片位置====== %@", self.insertIndexMarr);

}


@end
