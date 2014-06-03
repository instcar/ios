//
//  CustomLineTableView.m
//  CarApp
//
//  Created by Mac_ZL on 14-5-20.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CustomLineTableView.h"
#import "CustomLineTableViewCell.h"
#import "Line.h"
@implementation CustomLineTableView
@synthesize record= _record;
@synthesize delegate = _delegate;
- (void)dealloc
{
    _record = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isHide = NO;
        _isConfirm = NO;
        _initframe = frame;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:164.0/255.0 blue:171.0/255.0 alpha:1.0];
        [self addSubview:lineView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.current_y_h, frame.size.width, frame.size.height -20) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.current_y_h, 320, 0.5)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:164.0/255.0 blue:171.0/255.0 alpha:1.0];
        [self addSubview:_bottomLineView];
        
        
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setFrame:CGRectMake(frame.size.width/2-8, _bottomLineView.current_y_h+10-8,16, 16)];
        [_arrowBtn setBackgroundImage:[UIImage imageNamed:@"ic_down@2x.png"] forState:UIControlStateNormal];
        [_arrowBtn addTarget:self action:@selector(arrowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_arrowBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Setter

- (void)setRecord:(NSMutableArray *)record
{
    _record = record;
    [_tableView reloadData];
}
#pragma mark - Public
- (void)hideTableView
{
    _isHide = YES;
    [self dismissAnimate:_isHide];
}
- (void)showTableView
{
    _isHide = NO;
    [self dismissAnimate:_isHide];
}
- (void)reloadTaleView
{
    [_tableView reloadData];
}
#pragma mark - Inter Function
-(void) dismissAnimate:(BOOL) isHide
{
   _arrowBtn.transform = CGAffineTransformMakeRotation(isHide?M_PI:2*M_PI);

  [UIView animateWithDuration:0.4 animations:^{
      if (isHide)
      {
          CGRect tmpFrame = _initframe;
          CGRect tmpBtnFrame = _arrowBtn.frame;
          
          tmpFrame.size.height = 20;
          tmpBtnFrame.origin.y -=_tableView.frame.size.height;
          
          [_tableView setFrame:CGRectMake(0, 0, _initframe.size.width, 0)];
          [_bottomLineView setFrame:CGRectMake(0, _tableView.current_y_h, 320, 0.5)];
          [_arrowBtn  setFrame:tmpBtnFrame];
         
          [self setFrame:tmpFrame];
      }
      else
      {
          CGRect tmpBtnFrame = _arrowBtn.frame;
          
          [_tableView setFrame:CGRectMake(0, 0.5, _initframe.size.width, _initframe.size.height -20)];
          [_bottomLineView setFrame:CGRectMake(0, _tableView.current_y_h, 320, 0.5)];
          tmpBtnFrame.origin.y += _tableView.frame.size.height;
          [_arrowBtn setFrame:tmpBtnFrame];
          
          [self setFrame:_initframe];
      }
  }];
}
-(void) showConfirmViewWithIndex:(int) _index
{
    _isConfirm = YES;
    _arrowBtn.transform = CGAffineTransformMakeRotation(M_PI);
    if ([_delegate respondsToSelector:@selector(lineTableViewDidAnimate:)])
    {
        [_delegate lineTableViewDidAnimate:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect tmpFrame = _initframe;
        CGRect tmpBtnFrame = _arrowBtn.frame;
        
        tmpFrame.size.height = 64;
        tmpBtnFrame.origin.y = 46;
        
        [_tableView setFrame:CGRectMake(0, 0, _initframe.size.width, 0)];
        [_bottomLineView setFrame:CGRectMake(0, 44, 320, 0.5)];
        [_arrowBtn  setFrame:tmpBtnFrame];
        
        [self setFrame:tmpFrame];
    }completion:^(BOOL finished)
     {
         __block typeof(self) bSelf = self;
         if (!_confirmView)
         {
             _confirmView = [[CustomLineTableViewCell alloc] initWithFrame:CGRectMake(0, 0, bSelf.frame.size.width, 44)];
             [_confirmView setIsHideBottomLine:YES];
             [bSelf addSubview:_confirmView];
         }
         else
         {
             [_confirmView setHidden:NO];
         }
         Line *line = [_record objectAtIndex:_index];
         _confirmView.name = line.name;
         _confirmView.index = _index + 1;
     }];
}
-(void) hideConfirmView
{
    _isConfirm = NO;
    _arrowBtn.transform = CGAffineTransformMakeRotation(2*M_PI);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect tmpBtnFrame = _arrowBtn.frame;

        [_tableView setFrame:CGRectMake(0, 0, _initframe.size.width, _initframe.size.height -20)];
        [_bottomLineView setFrame:CGRectMake(0, _tableView.current_y_h, 320, 0.5)];
        tmpBtnFrame.origin.y = _tableView.frame.size.height+2;
        [_arrowBtn setFrame:tmpBtnFrame];
        
        [self setFrame:_initframe];
        if (_confirmView)
        {
            [_confirmView setHidden:YES];
        }
    }];

}
#pragma mark - BtnPressed
- (void)arrowBtnPressed:(id) sender
{
    if (!_isConfirm)
    {
        _isHide = !_isHide;
        [self dismissAnimate:_isHide];
    }
    else
    {
        [self hideConfirmView];
    }
    if ([_delegate respondsToSelector:@selector(lineTableViewDidAnimate:)])
    {
        [_delegate lineTableViewDidAnimate:_isHide];
    }
    
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_record count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"LineTable";
    CustomLineTableViewCell *cell = (CustomLineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    Line *line = [_record objectAtIndex:indexPath.row];
    cell.name = line.name;
    cell.index = indexPath.row + 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showConfirmViewWithIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(lineDidSelectedAtrowIndex:)])
    {
        [_delegate lineDidSelectedAtrowIndex:indexPath.row];
    }
    
}

   

@end
