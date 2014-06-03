//
//  PListSettingView.m
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "PListSettingView.h"
#import "UIButton+WebCache.h"
#define KCELLNUM 4


@implementation PListSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor yellowColor];
        [self initializeView];
    }
    return self;
}

-(void)initializeView
{

    for (int i = 0; i < KCELLNUM; i++) {
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(i*80, 0, 80, 80)];
//        [btnView setBackgroundColor:[UIColor clearColor]];
        btnView.tag = 100+i;
        [self addSubview:btnView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 60, 60)];
        btn.tag = 200+i;
        btn.layer.cornerRadius = 30.;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 2.0;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn setBackgroundImage:nil forState:UIControlStateSelected];
        [btn setTitle:@"空位" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [btn setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -80, 0)];
        btn.clipsToBounds = YES;
        btn.center = CGPointMake(btnView.frame.size.width/2, btnView.frame.size.height/2-10);
        [btn addTarget:self action:@selector(pListCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageview setTag:333];
        imageview.center = CGPointMake(btnView.frame.size.width/2, btnView.frame.size.height/2-10);
        [imageview setImage:[UIImage imageNamed:@"seat_ready@2x"]];
        [btnView addSubview:imageview];
        imageview.hidden = YES;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 80, 20)];
        [lable setTag:222];
        [lable setBackgroundColor:[UIColor clearColor]];
        [lable setTextColor:[UIColor lightGrayColor]];
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [btnView addSubview:lable];
        
    }
}

-(void)reloadView
{
    for (int i = 0; i < KCELLNUM; i++) {
        UIView *btnView = [self viewWithTag:100+i];
        UIButton *btn = (UIButton *)[btnView viewWithTag:200+i];        
        UILabel *titleLable = (UILabel *)[btnView viewWithTag:222];
        UIImageView *image = (UIImageView *)[btnView viewWithTag:333];
        
        [btn setImage:nil forState:UIControlStateNormal];
        
        //判断按钮显示
        if (_personArray == nil || [_personArray count]<=0 ||i >= [_personArray count]) {
            [image setHidden:YES];
            btn.userInteractionEnabled = NO;
            //座位空
            if (i >= [_personArray count] && i <= _seatNum-1) {
                [btn setImage:[UIImage imageNamed:@"seat_empty@wx.png"] forState:UIControlStateNormal];
                [btn setTitle:@"空位" forState:UIControlStateNormal];
                [titleLable setText:@"空位"];
            }
            
            //座位关闭
            if (i >= [_personArray count] && i > _seatNum-1) {
                [btn setImage:[UIImage imageNamed:@"seat_close@2x.png"] forState:UIControlStateNormal];
                [btn setTitle:@"关闭" forState:UIControlStateNormal];

                [titleLable setText:@"已关闭"];
            }
        }
        else
        {
            btn.userInteractionEnabled = _canEdit;
            /*
            if (i==0 && [[[_personArray objectAtIndex:0]valueForKey:@"id"]longValue]==self.roomMaster.ID) {
                [image setImage:[UIImage imageNamed:@"seat_owners@2x"]];
            }*/

            [btn setImageWithURL:[NSURL URLWithString:[[_personArray objectAtIndex:i] valueForKey:@"headpic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
            [image setHidden:NO];
            People *user = [_personArray objectAtIndex:i];
            [titleLable setText:user.name];
        }
        
    }
}

-(void)setPersonArray:(NSArray *)personArray RoomMaster:(People *)roomMaster Seats:(int)seatNum
{
    self.personArray = personArray;
    self.seatNum = seatNum;
    self.roomMaster = roomMaster;
    [self reloadView];
}

-(void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    [self setEditRefreshView];
}

-(void)setEditRefreshView
{
    for (int i = 0; i < KCELLNUM; i++) {
        UIView *btnView = [self viewWithTag:100+i];
        UIButton *btn = (UIButton *)[btnView viewWithTag:200+i];
        btn.userInteractionEnabled = _canEdit;
    }
}

-(void)pListCellAction:(UIButton *)sender
{
    DLog(@"点击了乘员:%d",sender.tag-200);
    int index = sender.tag - 200;
    UIView *btnView = [self viewWithTag:100+sender.tag-200];
    UILabel *titleLable = (UILabel *)[btnView viewWithTag:222];
    
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"空位"])
    {
        _seatNum --;
        [sender setImage:[UIImage imageNamed:@"seat_add@2x.png"] forState:UIControlStateNormal];
        [sender setTitle:@"关闭" forState:UIControlStateNormal];
        [titleLable setText:@"打开座位"];

    }
    else if([title isEqualToString:@"关闭"])
    {
        _seatNum ++;
        [sender setImage:[UIImage imageNamed:@"seat_close@2x.png"] forState:UIControlStateNormal];
        [sender setTitle:@"空位" forState:UIControlStateNormal];
        [titleLable setText:@"关闭座位"];
    }
    /*
    if(self.delegate && [self.delegate respondsToSelector:@selector(PListSettingViewDelegate:index:event:)])
    {
        int index = sender.tag - 200;
        
        [self.delegate PListSettingViewDelegate:self index:index event:kPListEventNull];
        
        //判断按钮显示
//        if (self.personArray == nil || [self.personArray count]<=0 ||index >= [self.personArray count]) {
            
           //座位空
//            if (index >= [self.personArray count] && index <= self.seatNum-1) {
//            
//                [self.delegate PListSettingViewDelegate:self index:index event:kPListEventClose];
//            }
//            
//            //座位关闭
//            if (index >= [self.personArray count] && index > self.seatNum-1) {
//
//                [self.delegate PListSettingViewDelegate:self index:index event:kPListEventOpened];
//            }
//        }
//        else
//        {
//            [self.delegate PListSettingViewDelegate:self index:index event:kPListEventNull];
//        }
    }*/
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
 * 添加函数 By Liang Zhao
 */
#pragma mark - FunctionSeatMode
-(void)enterEditSeatMode
{
    for (int i = 0; i < KCELLNUM; i++)
    {
        UIView *btnView = [self viewWithTag:100+i];
        UIButton *btn = (UIButton *)[btnView viewWithTag:200+i];
     
        
        UILabel *titleLable = (UILabel *)[btnView viewWithTag:222];
        UIImageView *image = (UIImageView *)[btnView viewWithTag:333];
        
        [btn setImage:nil forState:UIControlStateNormal];
        
        //判断按钮显示
        if (_personArray == nil || [_personArray count]<=0 ||i >= [_personArray count]) {
            [image setHidden:YES];
            btn.userInteractionEnabled = YES;
            //座位空
            if (i >= [_personArray count] && i <= _seatNum-1) {
                [btn setImage:[UIImage imageNamed:@"seat_close@2x.png"] forState:UIControlStateNormal];
                [titleLable setText:@"关闭座位"];
            }
            
            //座位关闭
            if (i >= [_personArray count] && i > _seatNum-1) {
                [btn setImage:[UIImage imageNamed:@"seat_add@2x.png"] forState:UIControlStateNormal];
                [titleLable setText:@"打开座位"];
            }
        }
        else
        {
            btn.userInteractionEnabled = NO;
            if (i==0 && [[[_personArray objectAtIndex:0]valueForKey:@"id"]longValue]==[[self.roomMaster valueForKey:@"id"]longValue]) {
                [image setImage:[UIImage imageNamed:@"seat_owners@2x"]];
            }
            
            [btn setImageWithURL:[NSURL URLWithString:[[_personArray objectAtIndex:i] valueForKey:@"headpic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
            [image setHidden:NO];
            [titleLable setText:[[_personArray objectAtIndex:i] valueForKey:@"username"]];
        }
    }

}
- (void) addUser
{
    
}
- (void) deleteUser
{
    
}
    
@end
