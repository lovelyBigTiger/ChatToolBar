//
//  ZYChatInputToolBar.h
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZYChatInputView.h"
#import "ZYChatEmojiView.h"
#import "ZYChatTextView.h"
#import "DTUtility.h"

@class ZYChatInputToolBar;

@protocol ZYChatInputToolBarDelegate <NSObject>

@optional

/**
 *  点击了发送按钮
 *
 *  @param text 要发送的文字
 */
- (void)didSendMessage:(NSString *)text;

/**
 *  开始输入
 *
 *  @param textView 输入文本框
 */
- (void)inputTextViewDidBeginEditing:(ZYChatTextView *)textView;

/**
 *  结束输入
 *
 *  @param textView 输入文本框
 */
- (void)inputTextViewDidEndEditing:(ZYChatTextView *)textView;

/**
 *  文本框高度变化
 *
 *  @param textView 输入文本框
 *  @param height   变化的高度
 */
- (void)inputTextView:(ZYChatTextView *)textView didChangeHeight:(float)height;


/**
 *  工具条 Y 坐标变化
 *
 *  @param toolBar 工具条对象
 *  @param y       y 坐标
 */
- (void)inputToolBar:(ZYChatInputToolBar *)toolBar didChangeY:(float)y;


@end


@interface ZYChatInputToolBar : UIView

@property (nonatomic,strong) id<ZYChatInputToolBarDelegate> delegate;

@property (nonatomic,strong) ZYChatInputView *inputView;

@property (nonatomic,strong) ZYChatEmojiView *emojiView;

- (void)resignFirstResponder;

- (void)supperViewWillAppear;

- (void)superViewWillDisappear;

@end
