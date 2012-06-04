//
//  DZUIActivityIndicatorUtility.h
//  DZUILib
//
//  Created by Simon Kim on 12. 4. 2..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DZUIActivityIndicatorUtility : UIView
- (void) dismiss;

+ (DZUIActivityIndicatorUtility *) activityIndicatorInView:(UIView *) view withText:(NSString *) text;
+ (DZUIActivityIndicatorUtility *) activityIndicatorInView:(UIView *) view withCustomView:(UIView *) customView;
@end
