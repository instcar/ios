//
//  ProfilePhotoFirstCustomCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-8.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ProfilePhotoFirstCustomCell.h"
#import "UIButton+WebCache.h"

@implementation ProfilePhotoFirstCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:NO];
        [self.contentView setClipsToBounds:NO];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.photoImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.photoImgView setImageEdgeInsets:UIEdgeInsetsMake(40, 40, 0, 0)];
        [self.photoImgView setFrame:CGRectMake(5, 10, 95, 95)];
//        [self.photoImgView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
//        [self.photoImgView.layer setShadowOpacity:1.0];
//        [self.photoImgView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.photoImgView.bounds] CGPath]];
        [self.photoImgView.layer setCornerRadius:2.0];
        [self.photoImgView.layer setMasksToBounds:YES];
        [self.photoImgView.layer setBorderWidth:0.5];
        [self.photoImgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.photoImgView setContentMode:UIViewContentModeScaleAspectFit];
        [self.photoImgView setBackgroundColor:[UIColor whiteColor]];
        [self.photoImgView setHidden:NO];
        
        [self.photoImgView addTarget:self action:@selector(photoImgViewAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.photoImgView];
        
        self.userSingleInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 10, 320-115, 95)];
        [self.userSingleInfoImageView setImage:[[UIImage imageNamed:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self.userSingleInfoImageView.layer setCornerRadius:2.0];
        [self.userSingleInfoImageView.layer setMasksToBounds:YES];
        [self.userSingleInfoImageView.layer setBorderWidth:0.5];
        [self.userSingleInfoImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.userSingleInfoImageView setHidden:NO];
        [self.contentView addSubview:self.userSingleInfoImageView];
        
        _alisLableView = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 150, 15)];
        [_alisLableView setBackgroundColor:[UIColor clearColor]];
        [_alisLableView setTextAlignment:NSTextAlignmentLeft];
        [_alisLableView setTextColor:[UIColor lightGrayColor]];
        [_alisLableView setFont:[UIFont boldSystemFontOfSize:12]];
        [_alisLableView setHidden:NO];
        [_alisLableView setText:@"昵称:"];
        [self.userSingleInfoImageView addSubview:_alisLableView];
        
        _sexLableView = [[UILabel alloc]init];
        [_sexLableView setFrame:CGRectMake(15, 60, 150, 15)];
        [_sexLableView setBackgroundColor:[UIColor clearColor]];
        [_sexLableView setTextColor:[UIColor lightGrayColor]];
        [_sexLableView setFont:[UIFont boldSystemFontOfSize:12]];
        [_sexLableView setHidden:NO];
        [_sexLableView setText:@"性别:"];
        [self.userSingleInfoImageView addSubview:_sexLableView];
        
        _ageLableView = [[UILabel alloc]init];
        [_ageLableView setFrame:CGRectMake(15, 75, 150, 15)];
        [_ageLableView setBackgroundColor:[UIColor clearColor]];
        [_ageLableView setTextColor:[UIColor lightGrayColor]];
        [_ageLableView setFont:[UIFont boldSystemFontOfSize:12]];
        [_ageLableView setHidden:NO];
        [_ageLableView setText:@"年龄:"];
        [self.userSingleInfoImageView addSubview:_ageLableView];
        
        //暂时不显示
        self.detailInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 10, 320-110, 95)];
        [self.detailInfoImageView setImage:[[UIImage imageNamed:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self.detailInfoImageView.layer setCornerRadius:2.0];
        [self.detailInfoImageView.layer setMasksToBounds:YES];
        [self.detailInfoImageView.layer setBorderWidth:0.5];
        [self.detailInfoImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.detailInfoImageView setHidden:YES];
        [self.contentView addSubview:self.detailInfoImageView];
        
        UILabel *xyLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 70, 15)];
        [xyLable setBackgroundColor:[UIColor clearColor]];
        [xyLable setTextAlignment:NSTextAlignmentLeft];
        [xyLable setTextColor:[UIColor lightGrayColor]];
        [xyLable setFont:[UIFont boldSystemFontOfSize:12]];
        [xyLable setHidden:NO];
        [xyLable setText:@"信誉度"];
        [self.detailInfoImageView addSubview:xyLable];
        
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 195-20, 30)];
        [self.scoreLabel setBackgroundColor:[UIColor clearColor]];
        [self.scoreLabel setTextAlignment:NSTextAlignmentLeft];
        [self.scoreLabel setTextColor:[UIColor orangeColor]];
        [self.scoreLabel setFont:[UIFont boldSystemFontOfSize:26]];
        [self.scoreLabel setHidden:NO];
        [self.scoreLabel setText:@"0.0%"];
        [self.detailInfoImageView addSubview:self.scoreLabel];
        
        self.goodLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 70, 15)];
        [self.goodLabel setBackgroundColor:[UIColor clearColor]];
        [self.goodLabel setTextAlignment:NSTextAlignmentLeft];
        [self.goodLabel setTextColor:[UIColor lightGrayColor]];
        [self.goodLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.goodLabel setHidden:NO];
        [self.goodLabel setText:@"好评 (0.0%) "];
        [self.detailInfoImageView addSubview:self.goodLabel];
        
        self.mediumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 70, 15)];
        [self.mediumLabel setBackgroundColor:[UIColor clearColor]];
        [self.mediumLabel setTextAlignment:NSTextAlignmentLeft];
        [self.mediumLabel setTextColor:[UIColor lightGrayColor]];
        [self.mediumLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.mediumLabel setText:@"中评 (0.0%) "];
        [self.mediumLabel setHidden:NO];
        
        [self.detailInfoImageView addSubview:self.mediumLabel];
        
        self.poorLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, 70, 15)];
        [self.poorLable setBackgroundColor:[UIColor clearColor]];
        [self.poorLable setTextAlignment:NSTextAlignmentLeft];
        [self.poorLable setTextColor:[UIColor lightGrayColor]];
        [self.poorLable setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.poorLable setText:@"差评 (0.0%) "];
        [self.poorLable setHidden:NO];
        [self.detailInfoImageView addSubview:self.poorLable];
        
        self.goodProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.goodProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.goodProgressView setFrame:CGRectMake(85, 45+7, 195-20-50-20,15)];
        [self.detailInfoImageView addSubview:self.goodProgressView];
        
        self.mediumProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.mediumProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.mediumProgressView setFrame:CGRectMake(85, 60+7, 195-20-50-20, 15)];
        [self.detailInfoImageView addSubview:self.mediumProgressView];
        
        self.poorProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.poorProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.poorProgressView setFrame:CGRectMake(85, 75+7, 195-20-50-20, 15)];
        [self.detailInfoImageView addSubview:self.poorProgressView];
        
    }
    
    return self;
}

- (void)setData:(People *)data
{
    if (data) {
        _data = data;
        if (![data.headpic isEqualToString:@"image"]) {
            [self.photoImgView setBackgroundImageWithURL:[NSURL URLWithString:data.headpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_b"]];
        }
        
        [_alisLableView setText:[NSString stringWithFormat:@"昵称: %@",([_data.name  isEqualToString:@""]?@"暂无":_data.name)]];
        NSString *sex = nil;
        switch ([_data.sex intValue]) {
            case 0:
                sex = @"女";
                break;
            case 1:
                sex = @"男";
                break;
            case 2:
                sex = @"保密";
                break;
            default:
                break;
        }
        [_sexLableView setText:[NSString stringWithFormat:@"性别: %@",sex]];
        [_ageLableView setText:[NSString stringWithFormat:@"年龄: %d",_data.age]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)Editing
{
      _Editing = Editing;
     [self loadView];
}

- (void)photoImgViewAction:(UIButton *)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(photoImgViewAction:)]) {
        [self.deleagte photoImgViewAction:self];
    }
}

- (void)loadView
{
    if (_Editing) {
        [self.photoImgView setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
        [self.photoImgView setHighlighted:YES];
    }
    else
    {
        [self.photoImgView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}



@end
