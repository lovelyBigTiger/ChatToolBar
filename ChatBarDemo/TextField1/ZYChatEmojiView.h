//
//  ZYChatEmojiView.h
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYChatEmojiViewDelegate <NSObject>

/**
 *  点击了某个表情
 *
 *  @param face 表情文字
 */
- (void)emojiViewDidSelected:(NSString *)face;

/**
 *  删除表情
 */
- (void)emojiViewDidDelete;

/**
 *  发送信息
 */
- (void)emojiViewSendMessage;

@end

@interface ZYChatEmojiView : UIView

@property (nonatomic,weak) id<ZYChatEmojiViewDelegate> delegate;

@end
