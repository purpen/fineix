//
//  THNDomainImagesTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainImagesTableViewCell.h"
#import "THNDomainImageCollectionViewCell.h"
#import "THNSceneImageViewController.h"
#import "UIView+TYAlertView.h"

static NSString *const URLUploadImage = @"/common/upload_asset";
static NSString *const imageCellId = @"THNDomainImageCollectionViewCellId";

@interface THNDomainImagesTableViewCell () {
    NSString *_domainId;
}

@end

@implementation THNDomainImagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_networkUploadImageData:(UIImage *)image {
    [SVProgressHUD showWithStatus:@"正在上传" maskType:(SVProgressHUDMaskTypeBlack)];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *img64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.uploadImageRequest = [FBAPI postWithUrlString:URLUploadImage requestDictionary:@{@"id":_domainId, @"tmp":img64Str, @"type":@"1"} delegate:self];
    [self.uploadImageRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageSucceed" object:nil];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

- (void)thn_setDomainImages:(NSArray *)images withDomainId:(NSString *)domainId {
    _domainId = domainId;
    [self.imageUrlMarr removeAllObjects];
    [self.imageIdMarr removeAllObjects];
    
    for (THNDomainManageInfoNCover *imageModel in images) {
        [self.imageUrlMarr addObject:imageModel.url];
        [self.imageIdMarr addObject:imageModel.idField];
    }
    [self.imageCollection reloadData];
}

- (void)setCellViewUI {
    [self addSubview:self.titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.imageCollection];
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLable.text = @"地盘图片";
    }
    return _titleLable;
}

- (UICollectionView *)imageCollection {
    if (!_imageCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _imageCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 96) collectionViewLayout:flowLayout];
        _imageCollection.delegate = self;
        _imageCollection.dataSource = self;
        _imageCollection.backgroundColor = [UIColor whiteColor];
        _imageCollection.showsVerticalScrollIndicator = NO;
        _imageCollection.showsHorizontalScrollIndicator = NO;
        _imageCollection.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_imageCollection registerClass:[THNDomainImageCollectionViewCell class] forCellWithReuseIdentifier:imageCellId];
    }
    return _imageCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrlMarr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId
                                                                                   forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell thn_setAddImage:@"icon_domain_addImage"];
    } else {
        if (self.imageUrlMarr.count) {
            [cell thn_setDomainImage:self.imageUrlMarr[indexPath.row - 1]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self openImagePickerChooseHeader];
    } else {
        THNSceneImageViewController *sceneImageVC = [[THNSceneImageViewController alloc] init];
        sceneImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        sceneImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.vc presentViewController:sceneImageVC animated:YES completion:nil];
    }
}

#pragma mark - 打开相册
- (void)openImagePickerChooseHeader {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"上传地盘图片" message:@""];
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#666666"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"拍照" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self takePhoto];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"相册选择" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self openPhotoLibrary];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        //        NSLog(@"--- 取消 ---");
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self.vc presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.vc presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark 打开相册
- (void)openPhotoLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark 获取图片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_domainId.length > 0) {
        [self thn_networkUploadImageData:image];
    }
}

#pragma mark - 
- (NSMutableArray *)imageUrlMarr {
    if (!_imageUrlMarr) {
        _imageUrlMarr = [NSMutableArray array];
    }
    return _imageUrlMarr;
}

- (NSMutableArray *)imageIdMarr {
    if (!_imageIdMarr) {
        _imageIdMarr = [NSMutableArray array];
    }
    return _imageIdMarr;
}

@end
