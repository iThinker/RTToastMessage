//
//  RTViewController.m
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

#import "RTViewController.h"
#import "RTToastManager.h"
#import "RTToastMessage.h"

@interface RTViewController ()

@end

@implementation RTViewController

- (void)showBrown:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Brown"];
    message.backgroundColor = [UIColor brownColor];
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showFox:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Fox"];
    message.image = [UIImage imageNamed:@"fox.png"];
    message.textColor = [UIColor orangeColor];
    message.textShadowColor = [UIColor redColor];
    message.textShadowOffset = CGSizeMake(2.0f, 2.0f);
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showJumps:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Jumps"];
    message.backgroundColor = [UIColor blueColor];
    message.transitionType = RTToastMessageTransitionCurlDown;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showOver:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Over"];
    message.transitionType = RTToastMessageTransitionFlipFromTop;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showThe:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"The"];
    message.backgroundColor= [UIColor redColor];
    message.transitionType = RTToastMessageTransitionCrossDissolve;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showLazy:(id)sender {
    [[RTToastManager sharedManager] showMessageWithText:@"Lazy"];
}

- (void)showDog:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Dog"];
    message.image = [UIImage imageNamed:@"dog.png"];
    message.backgroundColor = [UIColor whiteColor];
    message.textColor = [UIColor darkTextColor];
    message.textShadowColor = nil;
    message.transitionType = RTToastMessageTransitionFlipFromLeft;
    [[RTToastManager sharedManager] showMessage:message];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
