//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    
    UIButton *_addGoodBtn;//赞一个
    UIButton *_shareBtn;//分享
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    /*
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    
    //定制的按钮
    _addGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addGoodBtn.frame = CGRectMake(self.bounds.size.width - 2*btnWidth - 40 + 20, 7.5, btnWidth - 15, btnWidth - 15);
    _addGoodBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_addGoodBtn setImage:[UIImage imageNamed:@"Action_FavFriend@2x"] forState:UIControlStateNormal];
    [_addGoodBtn setImage:[UIImage imageNamed:@"Action_FavFriend@2x"] forState:UIControlStateHighlighted];
    [_addGoodBtn addTarget:self action:@selector(addGoodAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addGoodBtn];
    
    //定制的按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 10, 7.5, btnWidth - 15, btnWidth - 15);
    _shareBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_shareBtn setImage:[UIImage imageNamed:@"Action_Share@2x"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"Action_Share@2x"] forState:UIControlStateHighlighted];
    [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];
     */
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)shareAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MJPhotoToolbarShareAction:)]) {
        [self.delegate MJPhotoToolbarShareAction:self.currentPhotoIndex];
    }
}

- (void)addGoodAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MJPhotoToolbarShareAction:)]) {
        [self.delegate MJPhotoToolbarAddGoodAction:self.currentPhotoIndex];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
