//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

- (void)dealloc
{
	_date = nil;
    _view = nil;
    self.avatar = nil;
    [self setMessage:nil];
}

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType
{
    return [[NSBubbleData alloc] initWithText:text date:date type:type contentType:contentType];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType
{
//    UIView * emotionView = [self assembleMessageAtIndex:text from:YES];//自定义表情 图文混排
    
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.textColor = type == BubbleTypeSystem ?[UIColor lightGrayColor]:(type == BubbleTypeMine ?[UIColor blackColor]:[UIColor whiteColor]);
    label.backgroundColor = [UIColor clearColor];

    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets contentType:contentType];
}

#pragma mark - Image bubble

//const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
//const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

const UIEdgeInsets imageInsetsMine = {0, 3, 5, 9};
const UIEdgeInsets imageInsetsSomeone = {0, 9, 5, 3};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType
{
    return [[NSBubbleData alloc] initWithImage:image date:date type:type contentType:contentType];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType
{

    CGSize size = image.size;
    if (size.width > 100)
    {
        size.height /= (size.width / 100);
        size.width = 100;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets contentType:contentType];
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  contentType:(BubbleContentType)contentType
{
    if ([NSValue valueWithUIEdgeInsets:insets] == [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]) {
        insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    }
    
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets contentType:contentType];
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets contentType:(BubbleContentType)contentType
{
    self = [super init];
    if (self)
    {
        _view = view;
        _date = date;
        _type = type;
        _insets = insets;
        _contentType = contentType;
    }
    return self;
}

#define BEGIN_FLAG @"["
#define END_FLAG @"]"

#pragma mark--
#pragma mark-- 图文混排
//图文混排
-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 216

-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
//            DLog(@"str--->%@",str);
//            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
//            {
//                if (upX >= (MAX_WIDTH-KFacialSizeWidth*2/3))
//                {
//                    upY = upY + KFacialSizeHeight;
//                    upX = 0;
//                    X = MAX_WIDTH;
//                    Y = upY;
//                }
//                DLog(@"str(image)---->%@",str);
//                
//                NSString *imageName = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch_rev" ofType:@"plist"]]valueForKey:str];
//                
//                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
//                
//                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
//                [returnView addSubview:img];
//                [img release];
//                upX=KFacialSizeWidth+upX;
//                if (X<MAX_WIDTH) X = upX;
//                
//                
//            } else {
                for (int j = 0; j < [str length]; j++) {
                    DLog(@"str length%d",[str length]);
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(MAX_WIDTH, CGFLOAT_MAX)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<MAX_WIDTH) {
                        X = upX;
                    }
                }
//            }
        }
    }
    
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y + KFacialSizeHeight); //@ 需要将该view的尺寸记下，方便以后使用
//    DLog(@"%.1f %.1f", X, Y);
    return returnView;
}


@end
