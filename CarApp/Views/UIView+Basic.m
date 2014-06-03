//
//  UIView+Basic.m
//  Picnote
//
//  Created by xiaoZ on 13-3-28.
//  Copyright (c) 2013年 Edwin Hao. All rights reserved.
//

#import "UIView+Basic.h"

@implementation UIView(Basic)

-(float)current_x{
    return self.frame.origin.x;
}
-(float)current_y{
    return self.frame.origin.y;
}
-(float)current_w{
    return self.frame.size.width;
}
-(float)current_h{
    return self.frame.size.height;
}
-(float)current_y_h{
    return self.frame.size.height + self.frame.origin.y;
}
-(float)current_x_w{
    return self.frame.size.width + self.frame.origin.x;
}
@end
