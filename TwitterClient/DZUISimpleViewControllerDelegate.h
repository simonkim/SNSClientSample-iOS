//
//  DZUISimpleViewControllerDelegate.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 15..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZUISimpleViewControllerDelegate <NSObject>
- (void) viewControllerDone:(UIViewController *) viewController;
@optional
- (void) viewControllerDidCancel:(UIViewController *) viewController;
@end
