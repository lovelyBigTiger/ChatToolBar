//
//  ZYChatInputToolBar.m
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import "ZYChatInputToolBar.h"
#import "Masonry.h"

#define DT_TOOLBAR_HEIGHT 532/2.f
static void * kJSQMessagesKeyValueObservingContext = &kJSQMessagesKeyValueObservingContext;

@interface ZYChatInputToolBar ()<ZYChatInputViewDelegate, ZYChatEmojiViewDelegate>
{
    double          animationDuration;
    CGRect          keyboardRect;
    BOOL            isObserving;
    ZYChatInputType currentInputType;
}

@end

@implementation ZYChatInputToolBar

- (void)dealloc
{
    [self removeKeyboardListener];
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)initWithFrame:(CGRect) frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50);
        self.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.clipsToBounds = YES;
        
        currentInputType   = ZYChatInputTypeNone;
        keyboardRect       = CGRectZero;
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.inputView = [[ZYChatInputView alloc] init];
    self.inputView.delegate = self;
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_inputView];
    
    self.emojiView = [[ZYChatEmojiView alloc] init];
    self.emojiView.delegate = self;
    self.emojiView.hidden = YES;
    [self addSubview:_emojiView];
    
    [self addKeyboardListener];
    [self addObserver];
}

- (void)supperViewWillAppear
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)superViewWillDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)resignFirstResponder
{
    [self inputBarAnimationWithRect:CGRectZero InputType:ZYChatInputTypeNone];
    [self.inputView updateEmojiButtonSelected:NO];
}

- (void)addKeyboardListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)addObserver
{
    if (isObserving) {
        return;
    }
    [self.inputView.textView addObserver:self
                              forKeyPath:NSStringFromSelector(@selector(contentSize))
                                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                 context:&kJSQMessagesKeyValueObservingContext];
    isObserving = YES;
}

- (void)removeObserver
{
    if (!isObserving) {
        return;
    }
    @try {
        [self.inputView.textView removeObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(contentSize))
                                        context:kJSQMessagesKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) { }
    
    isObserving = NO;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesKeyValueObservingContext) {
        
        if (object == self.inputView.textView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        
            CGFloat dy = newContentSize.height - oldContentSize.height;
            if (dy == 6) {
                return; //TODO: bug
            }
            if (dy < 0) {
                
            }
            [self adjustInputToolbarForTextViewContentSizeChange:dy];
        }
    }
}

- (void)adjustInputToolbarForTextViewContentSizeChange:(float)dy
{
    NSLog(@"%f",dy);
    
//    if (self.inputView.textView.contentSize.height + dy < 80) {
//        if (self.inputView.frame.size.height >= 50) {
//            self.inputView.frame =  CGRectMake(0, self.inputView.frame.origin.y , self.inputView.frame.size.width, self.inputView.frame.size.height + dy);
//            self.frame = CGRectMake(0, self.frame.origin.y - dy, self.frame.size.width, self.frame.size.height + dy);
//        }
//    } else {
    
//    CGFloat h = CGRectGetHeight(self.inputView.frame) + dy;
//
//    if (h <= 50) {
//        h = 50;
//    } else if (h >= 80) {
//        h = 80;
//    } else {
//        if (dy < 0 && self.inputView.textView.contentSize.height + dy >= 80 - 10) {
//            h = 80;
//        }
//    }
//
//    CGFloat view_y = CGRectGetHeight(self.superview.frame) - h;
//    CGFloat view_h = h;
//    CGFloat view_w = CGRectGetWidth(self.superview.frame);
//
//    if (currentInputType == ZYChatInputTypeFace) {
//        self.emojiView.hidden = NO;
//        view_h += CGRectGetHeight(self.emojiView.frame);
//        view_y -= CGRectGetHeight(self.emojiView.frame);
//
//        self.frame = CGRectMake(0, view_y, view_w, view_h);
//        self.emojiView.frame = CGRectMake(0.0f, h, view_w,
//                                          CGRectGetHeight(self.emojiView.frame));
//    } else if (currentInputType == ZYChatInputTypeText) {
//        self.emojiView.hidden = YES;
//        view_h += CGRectGetHeight(keyboardRect);
//        view_y -= CGRectGetHeight(keyboardRect);
//
//        self.frame = CGRectMake(0, view_y, view_w, view_h);
//    } else {
//        self.emojiView.hidden = YES;
//
//        self.frame = CGRectMake(0, view_y, view_w, view_h);
//    }
//    self.inputView.frame = CGRectMake(0, 0, view_w, h);
//
//    if ([self.delegate respondsToSelector:@selector(inputToolBar:didChangeY:)]) {
//        [self.delegate inputToolBar:self didChangeY:self.frame.origin.y];
//    }
//
//    [self.inputView.textView scrollRangeToVisible:(NSMakeRange(0, self.inputView.textView.text.length))];
//
//    [self layoutIfNeeded];
    
    [self updateAllFrameWith: dy];
}

#pragma mark -keyboard
- (void)keyboardWillHide:(NSNotification *)notification
{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.superview.frame)) {
        [self inputBarAnimationWithRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                               duration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                                  curve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]
                              InputType:ZYChatInputTypeText];
    }
}

#pragma mark - messageView animation

- (void)inputBarAnimationWithRect:(CGRect)rect InputType:(ZYChatInputType)type {
    [self inputBarAnimationWithRect:rect duration:0.25 curve:UIViewAnimationCurveEaseInOut InputType:type];
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

- (void)inputBarAnimationWithRect:(CGRect)rect
                         duration:(float)duration
                            curve:(UIViewAnimationCurve)curve
                        InputType:(ZYChatInputType)type
{
    currentInputType = type;
    keyboardRect     = rect;
    
    
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:[self animationOptionsForCurve:curve]
                     animations:^{
                         
                         [self updateAllFrameWith:0];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark DTInputViewDelegate

- (void)inputTextViewDidEndEditing:(ZYChatTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:textView];
    }
}

- (void)inputTextViewDidBeginEditing:(ZYChatTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:textView];
    }
}

- (void)didSendWithMessage:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendMessage:)]) {
        [self.delegate didSendMessage:text];
    }
}

/**
 *  输入状态切换
 */
- (void)didSwitchInputType:(ZYChatInputType)type
{
    switch (type) {
        case ZYChatInputTypeText:
        {
            [self.inputView.textView becomeFirstResponder];
            break;
        }
            
        case ZYChatInputTypeFace:
        {
            [self.inputView.textView resignFirstResponder];
            [self inputBarAnimationWithRect:self.emojiView.frame InputType:ZYChatInputTypeFace];
            break;
        }
            
        default:
        {
            [self.inputView.textView resignFirstResponder];
            [self inputBarAnimationWithRect:CGRectZero InputType:ZYChatInputTypeGift];
        }
            break;
    }
}

#pragma mark -

#pragma mark DTEmojiViewDelegate

- (void)emojiViewSendMessage
{
    if ([_inputView.textView hasText]) {
        [self didSendWithMessage: [_inputView.textView.text copy]];
        _inputView.textView.text = @"";
    }
    [self didSwitchInputType:(ZYChatInputTypeSend)];
}

- (void)emojiViewDidSelected:(NSString *)face
{
    self.inputView.textView.text = [self.inputView.textView.text stringByAppendingString:face];
    [self.inputView.textView scrollRangeToVisible:(NSMakeRange(0, self.inputView.textView.text.length))];
}

- (void)emojiViewDidDelete
{
    NSString *text = self.inputView.textView.text;
    if (text.length>0) {
        NSString *newStr = nil;
        if (text.length > 3) {
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else  if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-4]]) {
                newStr=[text substringToIndex:text.length-4];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        } else if (text.length > 2) {
            
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        } else if (text.length > 1) {
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        } else {
            
        }
        self.inputView.textView.text=newStr;
    }
}

#pragma mark - notification

- (void)textViewTextDidEndEditingNotification:(NSNotification *)noti
{
    if ([noti.object isEqual:self.inputView.textView]) {
        [self resignFirstResponder];
    }
}

#pragma mark - private method

- (void)updateAllFrameWith:(CGFloat)dy {
    
    CGFloat h = CGRectGetHeight(self.inputView.frame) + dy;
    
    if (h <= 50) {
        h = 50;
    } else if (h >= 80) {
        h = 80;
    } else {
        if (dy < 0 && self.inputView.textView.contentSize.height + dy >= 80 - 10) {
            h = 80;
        }
    }
    
    CGFloat view_y = CGRectGetHeight(self.superview.frame) - h;
    CGFloat view_h = h;
    CGFloat view_w = CGRectGetWidth(self.superview.frame);
    
    if (currentInputType == ZYChatInputTypeFace) {
        self.emojiView.hidden = NO;
        view_h += CGRectGetHeight(self.emojiView.frame);
        view_y -= CGRectGetHeight(self.emojiView.frame);
        
        self.frame = CGRectMake(0, view_y, view_w, view_h);
        self.emojiView.frame = CGRectMake(0.0f, h, view_w,
                                          CGRectGetHeight(self.emojiView.frame));
    } else if (currentInputType == ZYChatInputTypeText) {
        self.emojiView.hidden = YES;
        view_h += CGRectGetHeight(keyboardRect);
        view_y -= CGRectGetHeight(keyboardRect);
        
        self.frame = CGRectMake(0, view_y, view_w, view_h);
    } else {
        self.emojiView.hidden = YES;
        
        self.frame = CGRectMake(0, view_y, view_w, view_h);
    }
    self.inputView.frame = CGRectMake(0, 0, view_w, h);
    
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didChangeY:)]) {
        [self.delegate inputToolBar:self didChangeY:self.frame.origin.y];
    }
    
    [self.inputView.textView scrollRangeToVisible:(NSMakeRange(0, self.inputView.textView.text.length))];
    
    [self layoutIfNeeded];
}

@end
