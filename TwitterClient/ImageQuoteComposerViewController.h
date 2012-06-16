//
//  ImageQuoteComposerViewController.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 15..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZUISimpleViewControllerDelegate.h"
@interface ImageQuoteComposerViewController : UITableViewController
@property (nonatomic, weak) id<DZUISimpleViewControllerDelegate> delegate;
- (UIImage *) quoteImage;
- (NSString *) quote;
- (NSString *) signature;
@end
