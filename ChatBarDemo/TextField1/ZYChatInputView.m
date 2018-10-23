//
//  ZYChatInputView.m
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import "ZYChatInputView.h"
#import "ZYChatTextView.h"
#import "DTUtility.h"
#import "Masonry.h"

#define DT_INPUTVIEW_HEIGHT 50.f

@interface ZYChatInputView ()<UITextViewDelegate>

@end

@implementation ZYChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, DT_SCREEN_WIDTH, DT_INPUTVIEW_HEIGHT);
        self.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
        [self setupInputView];
    }
    return self;
}

- (void)setupInputView
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DT_SCREEN_WIDTH, .5f)];
    topLine.backgroundColor = [DTUtility colorWithHex:@"#c4c4c5"];
    [self addSubview:topLine];
    
    [self addSubview:self.giftButton];
    [self addSubview:self.emojiButton];
    [self addSubview:self.sendButton];
    [self addSubview:self.textView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, DT_INPUTVIEW_HEIGHT - 1, DT_SCREEN_WIDTH, .5f)];
    bottomLine.backgroundColor = [DTUtility colorWithHex:@"#ddddde"];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomLine];
    
}
#pragma mark create UI

- (UIButton *)giftButton
{
    if (_giftButton == nil) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"gift"];
        
        [_giftButton setImage:imageNomorl forState:UIControlStateNormal];
        [_giftButton addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: _giftButton];
        [_giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.width.height.equalTo(@50);
        }];
    }
    return _giftButton;
}

- (ZYChatTextView *)textView
{
    if (_textView == nil) {
//        float DT_TEXTVIEW_HEIGHT = 36.f;
        float DT_TEXTVIEW_TO_TOP = 7.f;
        
        self.textView = [[ZYChatTextView alloc] init];
        _textView.delegate = self;
        
        [self addSubview: _textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.giftButton.mas_trailing);
            make.top.equalTo(self.mas_top).offset(DT_TEXTVIEW_TO_TOP);
            make.bottom.equalTo(self.mas_bottom).offset(-DT_TEXTVIEW_TO_TOP);
//            make.height.greaterThanOrEqualTo(@(DT_TEXTVIEW_HEIGHT));
//            make.height.lessThanOrEqualTo(@(2 * DT_TEXTVIEW_HEIGHT));
        }];
    }
    return _textView;
}

- (UIButton *)emojiButton
{
    if (_emojiButton == nil) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"emoji"];
        UIImage *imageHL = [UIImage imageNamed:@"emoji"];

        [_emojiButton setImage:imageNomorl forState:UIControlStateNormal];
        [_emojiButton setImage:imageHL forState:UIControlStateHighlighted];
        [_emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview: _emojiButton];
        [_emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textView.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.width.height.equalTo(@50);
        }];
    }
    return _emojiButton;
}

- (UIButton *)sendButton
{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"send"];
        UIImage *imageHL = [UIImage imageNamed:@"send"];

        [_sendButton setImage:imageNomorl forState:UIControlStateNormal];
        [_sendButton setImage:imageHL forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: _sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.emojiButton.mas_trailing);
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.width.height.equalTo(@50);
        }];
    }
    return _sendButton;
}

#pragma mark - actions

- (void)giftButtonClick:(UIButton *)sender
{
    self.emojiButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self.delegate didSwitchInputType:(ZYChatInputTypeGift)];
        
        if ([self.delegate respondsToSelector:@selector(didShowGiftView)]) {
            [self updateEmojiButtonSelected:NO];
            [self.delegate didShowGiftView];
            NSLog(@"点击送礼物");
        }
    }
}

- (void)emojiButtonClick:(UIButton *)sender
{
    [self bringSubviewToFront:self.textView];
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        if (sender.selected == YES) {
            [self.delegate didSwitchInputType:ZYChatInputTypeText];
            sender.selected = NO;
            [sender setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        }
        else{
            [self.delegate didSwitchInputType:ZYChatInputTypeFace];
            sender.selected = YES;
            [sender setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
            [sender setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        }
    }
}

- (void)sendButtonClick:(UIButton *)sender
{
    [self bringSubviewToFront:self.textView];
    self.emojiButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self updateEmojiButtonSelected:NO];
        [self.delegate didSwitchInputType:ZYChatInputTypeSend];
        
        if ([_textView hasText]) {
            if ([self.delegate respondsToSelector:@selector(didSendWithMessage:)]) {
                [self.delegate didSendWithMessage:[_textView.text copy]];
            }
            _textView.text = @"";
        }
    }
}

#pragma mark -

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.emojiButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self.delegate didSwitchInputType:ZYChatInputTypeText];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self.delegate didSwitchInputType:ZYChatInputTypeNone];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
            [self.delegate didSwitchInputType:ZYChatInputTypeSend];
        }
        
        if ([_textView hasText]) {
            if ([self.delegate respondsToSelector:@selector(didSendWithMessage:)]) {
                [self.delegate didSendWithMessage:[_textView.text copy]];
            }
            _textView.text = @"";
        }
        return NO;
    }
    return YES;
}

#pragma mark - private method

- (void)updateEmojiButtonSelected:(BOOL)selected {
    if (!selected) {
        _emojiButton.selected = NO;
        [_emojiButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_emojiButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    }
    else{
        _emojiButton.selected = YES;
        [_emojiButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_emojiButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }
}

@end
