//
//  ScrollChatTextModel.h
//  直播滚动聊天
//
//  Created by 许明洋 on 2019/9/28.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollChatTextModel : NSObject

@property (nonatomic,assign) NSInteger yx_height;
@property (nonatomic,copy) NSString *yx_content;

@end

NS_ASSUME_NONNULL_END
