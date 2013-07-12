//
//  RTToastMessage.h
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

extern NSTimeInterval const RTToastMessageDefaultDuration;

typedef enum {
    RTToastMessageTransitionMoveInFromRight = 0,
    RTToastMessageTransitionMoveInFromLeft,
    RTToastMessageTransitionMoveInFromTop,
    RTToastMessageTransitionMoveInFromBottom,
    //UIView supported transitions
    RTToastMessageTransitionFlipFromLeft = UIViewAnimationOptionTransitionFlipFromLeft,
    RTToastMessageTransitionFlipFromRight = UIViewAnimationOptionTransitionFlipFromRight,
    RTToastMessageTransitionFlipFromTop = UIViewAnimationOptionTransitionFlipFromTop,
    RTToastMessageTransitionFlipFromBottom = UIViewAnimationOptionTransitionFlipFromBottom,
    RTToastMessageTransitionCurlUp = UIViewAnimationOptionTransitionCurlUp,
    RTToastMessageTransitionCurlDown = UIViewAnimationOptionTransitionCurlDown,
    RTToastMessageTransitionCrossDissolve = UIViewAnimationOptionTransitionCrossDissolve
} RTToastMessageTransitionType;

@interface RTToastMessage : NSObject <UIAppearance, NSCopying>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textShadowColor;
@property (nonatomic, assign) CGSize textShadowOffset;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) RTToastMessageTransitionType transitionType;

- (id)initWithText:(NSString *)text;
- (id)initWithText:(NSString *)text andDuration:(NSTimeInterval)duration;

@end
