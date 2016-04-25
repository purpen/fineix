//
//  ScenceMessageView.h
//  fineix
//
//  Created by FLYang on 16/3/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface ScenceMessageView : UIView <UITextFieldDelegate, UITextViewDelegate>

@pro_strong UIView              *   topView;
@pro_strong UIView              *   bottomView;
@pro_strong UIImageView         *   imageView;        //    场景照片
@pro_strong UITextView          *   content;          //    场景描述内容
@pro_strong UITextField         *   title;            //    场景标题

@end
