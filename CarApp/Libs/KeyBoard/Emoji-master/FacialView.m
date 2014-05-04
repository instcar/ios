//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//        faces=[EmojiEmoticons allEmoticons];
        faces=[Emoji allEmoji];
//        faces=[EmojiPictographs allPictographs];
    }
    return self;
}

-(void)loadFacialView:(int)page size:(CGSize)size row:(int)row column:(int)column
{
	//row number
	for (int i=0; i<row; i++) {
		//column numer
		for (int y=0; y<column; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            if (i==row-1&&y==column-1) {
                [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
                
            }else{
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [faces objectAtIndex:i*3+y+(page*19)]forState:UIControlStateNormal];
                button.tag=i*3+y+(page*19);
                
            }
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag==10000) {
        [delegate selectedFacialView:@"删除"];
    }else{
        NSString *str=[faces objectAtIndex:bt.tag];
        [delegate selectedFacialView:str];
    }	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
- (void)dealloc {

}
@end
