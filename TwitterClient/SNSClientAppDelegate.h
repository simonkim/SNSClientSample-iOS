//
//  TwitterClientAppDelegate.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 1..
//  Copyright (c) 2012년 http://iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface SNSClientAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) Facebook *facebook;

- (void) facebookLogin;
- (BOOL) facebookLoggedIn;
- (void) registerFBSessionDelegate:(id<FBSessionDelegate>) delegate;
- (void) unregisterFBSessionDelegate:(id<FBSessionDelegate>) delegate;
@end
