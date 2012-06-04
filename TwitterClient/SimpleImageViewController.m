//
//  SimpleImageViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "SimpleImageViewController.h"
#import "DZUIActivityIndicatorUtility.h"
#import "DZUIAlertUtility.h"
@interface SimpleImageViewController ()

@end

@implementation SimpleImageViewController
@synthesize imageView;
@synthesize imageURL = _imageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( self.imageView.image == nil && self.imageURL != nil ) {
        DZUIActivityIndicatorUtility *activityUtility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Loading image..."];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            BOOL result = NO;
            NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
            if ( data ) {
                UIImage *image = [UIImage imageWithData:data];
                if ( image ) {
                    result = YES;
                    self.imageView.image = image;
                }
            }
            
            [activityUtility dismiss];
            if ( result == NO ) {
                [DZUIAlertUtility alertWithMessage:@"Couldn't load profile image" title:@"Error"];
            }
        });    
        NSLog(@"ActivityUtility:%p", activityUtility);
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
