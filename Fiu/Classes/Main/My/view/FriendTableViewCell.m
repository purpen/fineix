//
//  FriendTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "Fiu.h"
#import "FiuSceneCollectionViewCell.h" 
#import "FiuSceneRow.h"
#import "FindSceneModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "POP.h"
#import "THNMacro.h"
#import "THNSceneDetalViewController.h"

@interface FriendTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation FriendTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
        
        
        [self.contentView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.top.mas_equalTo(self.mas_top).with.offset(12);
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nameLbael];
        [_nameLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
            make.height.mas_equalTo(12);
            make.right.mas_equalTo(self.mas_right).with.offset(-30);
        }];
        
        [self.contentView addSubview:self.idTagsImageView];
        [_idTagsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLbael.mas_bottom).with.offset(4/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.follow];
        [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72/667.0*SCREEN_HEIGHT, 26/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(_headImageView.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.imageCollectionView];
        [_imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(11);
            make.right.mas_equalTo(self.mas_right).with.offset(0);
        }];
        
        [self.contentView addSubview:self.levelLabel];
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLbael.mas_bottom).with.offset(3);
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.follow.mas_left).with.offset(5);
            make.height.mas_equalTo(10);
        }];
        
        [self.contentView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_idTagsImageView.mas_right).with.offset(2/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(_idTagsImageView.mas_centerY);
        }];
    }
    return self;
}

-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _levelLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _levelLabel.font = [UIFont systemFontOfSize:9];
        }
        _levelLabel.textColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    return _levelLabel;
}

-(UILabel *)userLevelLabel{
    if (!_userLevelLabel) {
        _userLevelLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _userLevelLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _userLevelLabel.font = [UIFont systemFontOfSize:9];
        }
        _userLevelLabel.textColor = [UIColor lightGrayColor];
    }
    return _userLevelLabel;
}


-(UICollectionView *)imageCollectionView{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3.0, SCREEN_WIDTH / 3.0);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        [_imageCollectionView registerClass:[FiuSceneCollectionViewCell class] forCellWithReuseIdentifier:@"FiuSceneCollectionViewCell"];
    }
    return _imageCollectionView;
}

- (UIButton *)follow {
    if (!_follow) {
        _follow = [UIButton buttonWithType:UIButtonTypeCustom];
        _follow.layer.masksToBounds = YES;
        _follow.layer.cornerRadius = 5.0f;
        _follow.layer.borderColor = [UIColor whiteColor].CGColor;
        _follow.layer.borderWidth = 0.5f;
        [_follow setTitle:NSLocalizedString(@"User_follow", nil) forState:(UIControlStateNormal)];
        [_follow setTitle:NSLocalizedString(@"User_followDone", nil) forState:(UIControlStateSelected)];
        [_follow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_follow setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _follow.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_follow addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _follow;
}

//- (void)followClick:(UIButton *)button {
//    if (button.selected == NO) {
//        button.selected = YES;
//        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
//        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
//        scaleAnimation.springBounciness = 10.f;
//        scaleAnimation.springSpeed = 10.0f;
//        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
//        button.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
//        button.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
//        
//    } else if (button.selected == YES) {
//        button.selected = NO;
//        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
//        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
//        scaleAnimation.springBounciness = 10.f;
//        scaleAnimation.springSpeed = 10.0f;
//        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
//        button.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6].CGColor;
//        button.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
//    }
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sceneAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FiuSceneCollectionViewCell";
    FiuSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    FindSceneModel *model = self.sceneAry[indexPath.section];
    FiuSceneRow *model1 = [[FiuSceneRow alloc] init];
    
    model1.title = model.title;
    model1.coverUrl = model.cober;
    model1.address = model.address;
    cell.model = model1;
    cell.locationIcon.hidden = YES;
    
    return cell;
}

-(UIImageView *)idTagsImageView{
    if (!_idTagsImageView) {
        _idTagsImageView = [[UIImageView alloc] init];
    }
    return _idTagsImageView;
}

-(UILabel *)nameLbael{
    if (!_nameLbael) {
        _nameLbael = [[UILabel alloc] init];
        if (IS_iOS9) {
            _nameLbael.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        } else {
            _nameLbael.font = [UIFont systemFontOfSize:11];
        }
        _nameLbael.textColor = [UIColor colorWithWhite:1 alpha:1];
    }
    return _nameLbael;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 16/667.0*SCREEN_HEIGHT;
    }
    return _headImageView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
    FindSceneModel *model = self.sceneAry[indexPath.section];
    vc.sceneDetalId = [NSString stringWithFormat:@"%@",model.id];
    [self.navi pushViewController:vc animated:YES];
}

@end
