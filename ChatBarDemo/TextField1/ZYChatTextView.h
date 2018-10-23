//
//  ZYChatTextView.h
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYChatTextView : UITextView

/**
 *  默认文字，当输入框没有文字时
 */
@property (copy, nonatomic) NSString *placeHolder;

/**
 *  默认文字的颜色
 */
@property (strong, nonatomic) UIColor *placeHolderTextColor;

/**
 *  是否有内容，空格不算
 */
- (BOOL)hasText;

@end
