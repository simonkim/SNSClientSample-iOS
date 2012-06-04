//
//  DZUIAlertUtility.m
//  DZUILib
//
//  Created by Simon Kim on 12. 3. 14..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import "DZUIAlertUtility.h"

@interface DZUIAlertUtility() <UIAlertViewDelegate>
@property (nonatomic, strong) void (^textInputCompleteBlock)(NSString *text, DZUIAlertUtility *utility);
@property (nonatomic, strong) void (^confirmedBlock)(BOOL confirmed, DZUIAlertUtility *utility);
@end

@implementation DZUIAlertUtility
@synthesize textInputCompleteBlock = _textInputCompleteBlock;
@synthesize confirmedBlock = _confirmedBlock;

+ (DZUIAlertUtility *) promptTextWithTitle:(NSString *) title message:(NSString *) message 
                               defaultText:(NSString *)defaultText  completedBlock:(void (^)(NSString *text, DZUIAlertUtility *utility)) completed
{
    DZUIAlertUtility *utility = [[DZUIAlertUtility alloc] init];
    utility.textInputCompleteBlock = completed;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = utility;
    [alertView textFieldAtIndex:0].text = defaultText;
    [alertView show];
    
    return utility;
}
+ (DZUIAlertUtility *) promptTextWithTitle:(NSString *) title defaultText:(NSString *)defaultText  completedBlock:(void (^)(NSString *text, DZUIAlertUtility *utility)) completed
{
    return [[self class] promptTextWithTitle:title message:@"Enter Text" defaultText:defaultText completedBlock:completed];
}

+ (DZUIAlertUtility *) confirmWithTitle:(NSString *) title message:(NSString *) message completedBlock:(void (^)(BOOL confirmed, DZUIAlertUtility *utility)) completed
{
    DZUIAlertUtility *utility = [[DZUIAlertUtility alloc] init];
    utility.confirmedBlock = completed;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:message 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") 
                                              otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    alertView.delegate = utility;
    [alertView show];
    return utility;
    
}

- (void) alertWithMessage:(NSString *) message title:(NSString *) title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:message 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) dismissAlert:(UIAlertView *) alertView
{
    if (alertView.visible) 
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void) alertWithMessage:(NSString *) message title:(NSString *) title forDuration:(NSTimeInterval) duration
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:message 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];    
    if ( duration != 0 ) {
        [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:duration];
    }
}

+ (void) alertWithMessage:(NSString *) message title:(NSString *) title forDuration:(NSTimeInterval) duration
{
    DZUIAlertUtility *utility = [[DZUIAlertUtility alloc] init];
    [utility alertWithMessage:message
                        title:title
                  forDuration:duration];
}

+ (void) alertWithMessage:(NSString *) message title:(NSString *) title
{
    [[self class] alertWithMessage:message title:title forDuration:0];    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d", buttonIndex);
    if ( self.textInputCompleteBlock ) {
        self.textInputCompleteBlock((buttonIndex == 1) ? [alertView textFieldAtIndex:0].text : nil, self);
    } else if (self.confirmedBlock ) {
        self.confirmedBlock((buttonIndex == 1) ? YES : NO, self);
    }
}

@end
