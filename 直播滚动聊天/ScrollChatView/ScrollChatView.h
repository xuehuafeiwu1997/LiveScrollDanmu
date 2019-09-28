//
//  ScrollChatView.h
//  直播滚动聊天
//
//  Created by 许明洋 on 2019/9/28.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollChatView;

typedef void(^ShowContentBlock)(ScrollChatView * _Nullable view,NSInteger   index,NSString  * _Nonnull  text);

@protocol ScrollChatViewDelegate <NSObject>

- (void)ScrollViewChatTextView:(ScrollChatView *)view withIdex:(NSInteger)index withText:(NSString *)text;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ScrollChatView : UITableView
/**
 设置奇数行昵称颜色
 */
@property (nonatomic,retain) UIColor *oddNumberNickNameColor;
/**
 设置奇数行内容颜色
 */
@property (nonatomic,retain) UIColor *oddNumberContentColor;
/**
 设置偶数行昵称颜色
 */
@property (nonatomic,retain) UIColor *evenNumberNickNameColor;
/**
 设置偶数行内容颜色
 */
@property (nonatomic,retain) UIColor *evenNumberContentColor;
/**
 设置昵称颜色
 */
@property (nonatomic,retain) UIColor *reviewerNickNameColor;
/**
 设置滚动速度
 */
@property (nonatomic,assign) NSInteger speed;
/**
设置单元格中字体的颜色
*/
@property (nonatomic,retain) UIColor *color;
/**
 设置内容颜色
 */
@property (nonatomic,retain) UIColor *contentColor;
/**
 设置行间距
 */
@property (nonatomic,assign) CGFloat padding;
@property (nonatomic,retain) UIFont *font;
@property (nonatomic,retain) NSArray *dataList;
/**
 当前用户评论的内容
 */
@property (nonatomic,copy) NSString *currentText;

//申明协议
@property (nonatomic,weak) id<ScrollChatViewDelegate> yx_delegate;

//申明block
@property (nonatomic,copy) ShowContentBlock showContentBlock;
@end

NS_ASSUME_NONNULL_END
