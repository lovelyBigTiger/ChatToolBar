//
//  ZYChatInputView.h
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYChatTextView;

typedef NS_ENUM(NSUInteger, ZYChatInputType){
    ZYChatInputTypeNone,
    ZYChatInputTypeText,
    ZYChatInputTypeGift,
    ZYChatInputTypeFace,
    ZYChatInputTypeSend
};

@protocol ZYChatInputViewDelegate <NSObject>

/**
 *  输入状态切换
 */
- (void)didSwitchInputType:(ZYChatInputType)type;

/**
 *  发送信息
 */
- (void)didSendWithMessage:(NSString *)text;

/**
 *  发送礼物
 */
- (void)didShowGiftView;

/**
 *  开始编辑
 */
- (void)inputTextViewDidBeginEditing:(ZYChatTextView *)textView;

/**
 *  结束编辑
 */
- (void)inputTextViewDidEndEditing:(ZYChatTextView *)textView;

@end

@interface ZYChatInputView : UIView

@property (nonatomic,weak)   id<ZYChatInputViewDelegate> delegate;

@property (nonatomic,strong) UIButton       *giftButton;

@property (nonatomic,strong) ZYChatTextView *textView;

@property (nonatomic,strong) UIButton       *emojiButton;

@property (nonatomic,strong) UIButton       *sendButton;

- (void)updateEmojiButtonSelected:(BOOL)selected;

@end
