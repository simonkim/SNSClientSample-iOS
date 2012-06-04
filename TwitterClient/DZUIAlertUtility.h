//
//  DZUIAlertUtility.h
//  DZUILib
//
//  Created by Simon Kim on 12. 3. 14..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface DZUIAlertUtility : NSObject

- (void) alertWithMessage:(NSString *) message title:(NSString *) title;
- (void) alertWithMessage:(NSString *) message title:(NSString *) title forDuration:(NSTimeInterval) duration;
+ (void) alertWithMessage:(NSString *) message title:(NSString *) title;
+ (void) alertWithMessage:(NSString *) message title:(NSString *) title forDuration:(NSTimeInterval) duration;
+ (DZUIAlertUtility *) promptTextWithTitle:(NSString *) title defaultText:(NSString *)defaultText completedBlock:(void (^)(NSString *text, DZUIAlertUtility *utility)) completed;
+ (DZUIAlertUtility *) promptTextWithTitle:(NSString *) title message:(NSString *) message 
                               defaultText:(NSString *)defaultText  completedBlock:(void (^)(NSString *text, DZUIAlertUtility *utility)) completed;

+ (DZUIAlertUtility *) confirmWithTitle:(NSString *) title message:(NSString *) message completedBlock:(void (^)(BOOL confirmed, DZUIAlertUtility *utility)) completed;
@end
