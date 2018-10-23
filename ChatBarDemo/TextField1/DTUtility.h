//
//  DTUtility.h
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define DT_BOARD_HEITH 216

@interface DTUtility : NSObject

+ (UIColor *)colorWithHex:(NSString *)hex;

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
