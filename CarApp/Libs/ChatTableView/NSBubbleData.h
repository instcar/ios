//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>

@class CommonMessage;

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1,
    BubbleTypeSystem = 2,//系统提醒
} NSBubbleType;


typedef enum
{
    BubbleContentText = 0,
    BubbleContentImage = 1,
    BubbleContentLocation = 2,
    BubbleContentSystem = 3,
}BubbleContentType;

@protocol NSBubbleDataDelegate;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, retain) NSDate *date;
//@property (nonatomic, assign) CLLocationCoordinate2D locate;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, retain) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, copy) NSString * avatar; //头像的图片地址
@property (readonly, nonatomic) BubbleContentType contentType;
@property (retain, nonatomic) CommonMessage *message;
@property (assign, nonatomic) long uid;
@property (assign, nonatomic) long fid;
@property (assign, nonatomic) long roomid;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type contentType:(BubbleContentType)contentType;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets contentType:(BubbleContentType)contentType;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets contentType:(BubbleContentType)contentType;

@end

