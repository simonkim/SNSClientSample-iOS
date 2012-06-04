//
//  TwitterAccountsViewController.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 3..
//  Copyright (c) 2012년 http://iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@class TwitterAccountsViewController;

@protocol TwitterAccountsViewControllerDelegate <NSObject>
- (void) accountsViewController:(TwitterAccountsViewController *) accountsViewController didSelectAccount:(ACAccount *) account;
@end

@interface TwitterAccountsViewController : UITableViewController
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, weak) id<TwitterAccountsViewControllerDelegate> delegate;
@end
