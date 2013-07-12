//
//  RTToastManager.h
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

//  This code is distributed under the terms and conditions of the MIT license. 
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
