//
//  TwitterTimelineViewController.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClientUtility.h"

@interface TwitterTimelineViewController : UITableViewController
@property (nonatomic, strong) TwitterClientUtility *twitterClient;
@property (nonatomic, strong) ACAccount *account;

@end
