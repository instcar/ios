//
//  PassengerControl.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "PassengerControl.h"

#define KMaxPassengerNum 4
#define KPassengerImgWidth 20
#define KPassengerImgHeight 30

@implementation PassengerControl

-(void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [bgImageView setImage:[UIImage imageNamed:@"btn_empty@2x"]];
        [self addSubview:bgImageView];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(self.bounds.size.width-45, 0, 45, 45);
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_b_normal@2x"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_b_pressed@2x"] forState:UIControlStateHighlighted];
        [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setShowsTouchWhenHighlighted:YES];
        [self addSubview:_addBtn];
        
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subBtn.frame = CGRectMake(0, 0, 45, 45);
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"btn_reduce_b_normal@2x"] forState:UIControlStateNormal];
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"btn_reduce_b_pressed@2x"] forState:UIControlStateHighlighted];
        [_subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
        [_subBtn setShowsTouchWhenHighlighted:YES];
        [self addSubview:_subBtn];
        
        //seatConstain
        UIView * seatConstaion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _size.width * _allNum, _size.height)];
        seatConstaion.tag = 50000;
        seatConstaion.center = bgImageView.center;
        [self addSubview:seatConstaion];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame NormalImage:(UIImage *)normalImgae SelectImage:(UIImage *)selectImage indexs:(int)indexs size:(CGSize)size
{
    _normalImage = normalImgae;
    _selectImage = selectImage;
    _allNum = indexs;
    _size = size;
    return  [self initWithFrame:frame];
}

-(void)reloadView
{
    UIView *seatConstain = [self viewWithTag:50000];
    
    //清空容器
    for (UIView *sub in seatConstain.subviews) {
        [sub removeFromSuperview];
    }
    
    for (int i = 0; i < _allNum; i++) {
        
        float x = i*_size.width;
        
        UIImageView *passImg = [[UIImageView alloc]init];
        passImg.image =  i < _currentNum ? _selectImage:_normalImage;
        passImg.frame = CGRectMake(x, 0, _size.width, _size.height);
        passImg.contentMode = UIViewContentModeScaleAspectFit;
        [seatConstain addSubview:passImg];
    }
}

-(void)addAction:(UIButton *)sender
{
    if (_currentNum < _allNum) {
        _currentNum ++;
    }
    [self reloadView];
}

-(void)subAction:(UIButton *)sender
{
    if (_currentNum > 0) {
        _currentNum --;
    }
    [self reloadView];
}

-(void)setCurrentNum:(int)currentNum
{
    if (currentNum) {
        _currentNum = currentNum;
    }
    [self reloadView];
}

@end
