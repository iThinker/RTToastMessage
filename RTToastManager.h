//
//  RTToastManager.h
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTToastMessage;

@interface RTToastManager : NSObject {
    CGRect _minFrame;
    CGRect _maxFrame;
    __weak UIWindow *_window;
    UIView *_backgroundView;
    UIView *_toastView;
    UIView *_messageView;
    NSMutableArray *_messages; // array of RTToastMessage instances
    NSTimer *_hidingTimer;
    NSTimeInterval _duration;
}

+ (RTToastManager *)sharedManager;

- (id)initInWindow:(UIWindow *)window;

- (void)showMessage:(RTToastMessage *)message;
- (void)showMessageWithText:(NSString *)text;
- (void)showMessageWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
