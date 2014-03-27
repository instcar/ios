//
//  FaceToolBar.m
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//

#import "FaceToolBar.h"

@implementation FaceToolBar
@synthesize theSuperView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化为NO
        keyboardIsShow=NO;
        faceboardIsShow = NO;
        extendboardIsShow = NO;
        
        keyboardHideTransitionDuration = Time;
        keyboardTransitionHideAnimationCurve = UIViewAnimationCurveEaseOut;
        
        self.theSuperView=superView;
        //默认toolBar在视图最下方
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,superView.bounds.size.height - toolBarHeight,superView.bounds.size.width,toolBarHeight)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
        [toolBar setBackgroundImage:[[UIImage imageNamed:@"tab_bar"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
        [toolBar setBarStyle:UIBarStyleBlack];
       
        //可以自适应高度的文本输入框
        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(8, 5, 220, 35)];
//        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [textView setFont:[UIFont fontWithName:kFangZhengFont size:18]];
        [textView.internalTextView setReturnKeyType:UIReturnKeySend];
        textView.delegate = self;
        textView.maximumNumberOfLines=4;
        [toolBar addSubview:textView];
        [textView release];
        
        //音频按钮
//        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
//        [voiceButton setBackgroundImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
//        [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
//        voiceButton.frame = CGRectMake(5,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
//        [toolBar addSubview:voiceButton];
        
        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_normal@2x"] forState:UIControlStateNormal];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_hold@2x"] forState:UIControlStateHighlighted];
        [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        faceButton.frame = CGRectMake(toolBar.bounds.size.width - 80.0f,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        [toolBar addSubview:faceButton];
        
        //add按钮
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_normal@2x"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_hold@2x"] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(disExtendView) forControlEvents:UIControlEventTouchUpInside];
        [addButton setShowsTouchWhenHighlighted:NO];
        addButton.frame = CGRectMake(toolBar.bounds.size.width - 40.0f,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        [toolBar addSubview:addButton];
        
        //默认背景
        UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height, toolBar.frame.size.width, keyboardHeight)];
        backGroundView.tag = 10000;
        backGroundView.backgroundColor = [UIColor flatWhiteColor];
        [toolBar addSubview:backGroundView];
        [backGroundView release];
        
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [superView addSubview:toolBar];
        [toolBar release];
        
        //创建表情键盘
        faceAllView = [[FaceAllView alloc]initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];
        faceAllView.delegate = self;
        [superView addSubview:faceAllView];
        [faceAllView release];
        
        //格外的键盘
        extendView = [[ExtendView alloc]initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];
        extendView.delegate = self;
        [extendView loadExtendView:1 size:CGSizeMake(80, 80) row:2 column:4];
        [superView addSubview:extendView];
        [extendView release];
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}


#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = toolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    toolBar.frame = r;
    
    CGRect bgFrame = [toolBar viewWithTag:10000].frame;
    bgFrame.origin.y = r.size.height;
    [toolBar viewWithTag:10000].frame = bgFrame;
    
    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
        DLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
    }
    if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
        [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:toolBar.frame.origin.y];
    }
}

//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    [self sendAction];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
//    NSLog(@"文本的长度%d",textView.text.length);
}



#pragma mark -
#pragma mark ActionMethods  发送sendAction 音频 voiceChange  显示表情 disFaceKeyboard
-(void)sendAction{
    if (textView.text.length>0) {
        NSLog(@"点击发送");
        if ([self.faceToolBarDelegate respondsToSelector:@selector(sendTextAction:)])
        {
            [self.faceToolBarDelegate sendTextAction:textView.text];
        }
        [textView clearText];
    }
}

-(void)voiceChange{
    [self dismissKeyBoard];
}

-(void)disExtendView
{
    //如果直接点击表情，通过toolbar的位置来判断
    if ((toolBar.frame.origin.y== self.theSuperView.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight)) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
            if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight];
            }
        }];
        [UIView animateWithDuration:Time animations:^{
            [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }completion:^(BOOL finished) {
            extendboardIsShow = YES;
        }];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        //判断表情键盘是否显示
        if(faceboardIsShow)
        {
            [UIView animateWithDuration:Time animations:^{
                [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
                
            }completion:^(BOOL finished) {
                faceboardIsShow = NO;
                [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_normal@2x"] forState:UIControlStateNormal];
                [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_hold@2x"] forState:UIControlStateHighlighted];
            }];
            [UIView animateWithDuration:Time animations:^{
                [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
                if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                    [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight];

                }
            }completion:^(BOOL finished) {
                extendboardIsShow = YES;
                [addButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
                [addButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
            }];
        }
        else
        {
            [UIView animateWithDuration:Time animations:^{
                [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
                
            } completion:^(BOOL finished) {
                extendboardIsShow = NO;
//                [addButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];

            }];
            [textView becomeFirstResponder];
        }
        
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
            if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height];

            }
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }completion:^(BOOL finished) {
            extendboardIsShow = YES;
            [addButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
            [addButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
        }];
        [textView resignFirstResponder];
    }
}

-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if ((toolBar.frame.origin.y== self.theSuperView.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight)) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
            if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight];
            }
        }];
        [UIView animateWithDuration:Time animations:^{
            [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }completion:^(BOOL finished) {
            faceboardIsShow = YES;
        }];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
        return;
    }
    
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        if (extendboardIsShow) {
            
            [UIView animateWithDuration:Time animations:^{
                [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
                
            } completion:^(BOOL finished) {
                extendboardIsShow = NO;
                [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_normal@2x"] forState:UIControlStateNormal];
                [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_hold@2x"] forState:UIControlStateNormal];
            }];
            
            [UIView animateWithDuration:Time animations:^{
                [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
                if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                    [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight];
                }
            }completion:^(BOOL finished) {
                faceboardIsShow = YES;
                [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
                [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
            }];
            
        }
        else{
            [UIView animateWithDuration:Time animations:^{
                [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
            }completion:^(BOOL finished) {
                faceboardIsShow = NO;
//                [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];

            }];
            [textView becomeFirstResponder];
        }
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
            if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
                [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height];
            }
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }completion:^(BOOL finished) {
            faceboardIsShow = YES;
            [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal@2x"] forState:UIControlStateNormal];
            [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_hold@2x"] forState:UIControlStateHighlighted];
        }];
        
        [textView resignFirstResponder];
    }
    
}

#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    
    [UIView beginAnimations:@"keyboardHide" context:nil];
    [UIView setAnimationDuration:keyboardHideTransitionDuration];
    [UIView setAnimationCurve:keyboardTransitionHideAnimationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:Time animations:^{
        [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
        [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
        //有一个视图显示的时候才电泳代理，默认时候不调用
        if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]&&(faceboardIsShow||extendboardIsShow||keyboardIsShow)) {
            [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:self.theSuperView.frame.size.height-toolBarHeight];
        }
    }completion:^(BOOL finished) {
        faceboardIsShow = NO;
        extendboardIsShow = NO;
    }];

    [textView resignFirstResponder];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_normal@2x"] forState:
     UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_hold@2x"] forState:
     UIControlStateHighlighted];
    [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_normal@2x"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_hold@2x"] forState:UIControlStateHighlighted];
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    
    //键盘显示，设置toolbar的frame跟随键盘的frame
    
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];

    [UIView beginAnimations:@"keyboardShow" context:nil];
    [UIView setAnimationDuration:keyboardTransitionDuration];
    [UIView setAnimationCurve:keyboardTransitionAnimationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
//    NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyboardEndFrameWindow));
    if (toolBar.frame.size.height>44) {
        toolBar.frame = CGRectMake(0, keyboardEndFrameWindow.origin.y-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
        //处理表情视图和格外视图的影藏
        if (faceboardIsShow) {
            [UIView animateWithDuration:Time animations:^{
                [faceAllView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
            }completion:^(BOOL finished) {
                faceboardIsShow = NO;
            }];
        }
        if (extendboardIsShow) {
            [UIView animateWithDuration:Time animations:^{
                [extendView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
            }completion:^(BOOL finished) {
                extendboardIsShow = NO;
            }];
        }
        if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
            [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:keyboardEndFrameWindow.origin.y-toolBar.frame.size.height];
        }
    }else{
        toolBar.frame = CGRectMake(0, keyboardEndFrameWindow.origin.y-44,  self.theSuperView.bounds.size.width,toolBarHeight);
        if (self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(faceToolbarOrgYChangered:withHeight:)]) {
            [self.faceToolBarDelegate faceToolbarOrgYChangered:self withHeight:keyboardEndFrameWindow.origin.y-44];
        }
    }

    [UIView commitAnimations];
    
    
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_normal@2x"] forState:
     UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ic_emoji_hold@2x"] forState:
     UIControlStateHighlighted];
    [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_normal@2x"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"ic_add_hold@2x"] forState:UIControlStateHighlighted];
    
    keyboardIsShow=YES;
    [pageControl setHidden:YES];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    keyboardIsShow=NO;
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    keyboardHideTransitionDuration = keyboardTransitionDuration;
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    keyboardTransitionHideAnimationCurve = keyboardTransitionAnimationCurve;
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
//    NSLog(@"进代理了");
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (textView.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr=[textView.text substringToIndex:textView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[textView.text substringFromIndex:textView.text.length-1]);
                newStr=[textView.text substringToIndex:textView.text.length-1];
            }
            textView.text=newStr;
        }
        NSLog(@"删除后更新%@",textView.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",textView.text,str];
        [textView setText:newStr];
//        NSLog(@"点击其他后更新%f,%@",str.length,textView.text);
    }
    NSLog(@"出代理了");
}

#pragma mark -
#pragma mark faceallviewDelegate
-(void)faceAllView:(FaceAllView *)faceAllView sendAction:(UIBarButtonItem *)sender
{
    [self sendAction];
}

-(void)selectedExtendView:(int)index
{
    if(self.faceToolBarDelegate && [self.faceToolBarDelegate respondsToSelector:@selector(extendViewselectedExtendView:)])
    {
        [self.faceToolBarDelegate extendViewselectedExtendView:index];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [super dealloc];
}

@end
