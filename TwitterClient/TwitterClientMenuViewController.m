//
//  TwitterClientMenuViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 1..
//  Copyright (c) 2012년 http://iosappdev.co.kr. All rights reserved.
//

#import "TwitterClientMenuViewController.h"
#import <Twitter/TWTweetComposeViewController.h>

#import "TwitterAccountsViewController.h"
#import "SimpleImageViewController.h"
#import "TwitterTimelineViewController.h"
#import "ImageQuoteComposerViewController.h"

#import "TwitterClientUtility.h"
#import "DZUIImagePickerUtility.h"
#import "DZUIAlertUtility.h"
#import "DZUIActivityIndicatorUtility.h"
#import "DZUISimpleViewControllerDelegate.h"

@interface TwitterClientMenuViewController () <TwitterAccountsViewControllerDelegate,DZUISimpleViewControllerDelegate >
@property (weak, nonatomic) IBOutlet UILabel *labelAccountUsername;
@property (nonatomic, strong) TwitterClientUtility *twitterClient;
@property (nonatomic, strong) ACAccount *selectedAccount;
@end

@implementation TwitterClientMenuViewController
@synthesize labelAccountUsername = _labelAccountUsername;
@synthesize twitterClient = _twitterClient;
@synthesize selectedAccount = _selectedAccount;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewDidUnload
{
    [self setLabelAccountUsername:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Properties
- (TwitterClientUtility *) twitterClient
{
    if ( _twitterClient == nil ) {
        _twitterClient = [[TwitterClientUtility alloc] init];
    }
    return _twitterClient;
}

#pragma mark - Internal Methods
- (void) startProfileImageUpdateChain
{
    if ( self.selectedAccount ) {
        DZUIImagePickerUtility *__block utility = [DZUIImagePickerUtility imagePickerUtilityWithImagePickerReadyBlock:^(UIImagePickerController *picker) {
            // Image Picker Controller customization
            picker.allowsEditing = YES;
            
            [self presentModalViewController:picker animated:YES];
        } imagePickedBlock:^(UIImage *image) {
            //
            [self dismissViewControllerAnimated:YES completion:^{
                //
                DZUIActivityIndicatorUtility * __block activityUtility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Requesting profile image update..."];
                
                [self.twitterClient updateProfileWithImageData:UIImageJPEGRepresentation(image, 0.75) account:self.selectedAccount completed:^(BOOL succeed, NSDictionary *userInfo) {
                    // we are not in back in main/UI queue yet
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //
                        if ( succeed ) {
                            //...
                            [DZUIAlertUtility alertWithMessage:@"Profile image update successfully requested" 
                                                         title:@"Information" forDuration:3];
                        } else {
                            // ...
                            NSString *errorMessage = @"Unknown error";
                            NSError *error = [userInfo objectForKey:@"error"];
                            if ( error ) {
                                errorMessage = [NSString stringWithFormat:@"Profile image update failed:%@", error.localizedDescription];
                            }
                            [DZUIAlertUtility alertWithMessage:errorMessage 
                                                         title:@"Error"];
                        }
                        utility = nil;
                        [activityUtility dismiss];
                        activityUtility = nil;                        
                    });

                }];
                
            }];
        } cancelledBlock:^{
            
            //
            [self dismissModalViewControllerAnimated:YES];
            utility = nil;
            
        }];
    }
    
}

#pragma mark - Table view data source

- (void) handleMainMenuAtIndex:(NSUInteger) index
{
    switch( index ) {
            // Query Accounts
        case 0:
        {
            DZUIActivityIndicatorUtility * __block utility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Loading registered twitter accounts..."];
            
            [self.twitterClient queryAccountsWithCompletion:^(BOOL granted, NSArray *accounts) {
                
                // We are not in the main/UI queue yet
                dispatch_async(dispatch_get_main_queue(), ^{
                    //
                    if ( granted && accounts.count > 0 ) {
                        [self performSegueWithIdentifier:@"push_accounts" sender:accounts];
                    } else if ( granted ) {
                        // No accounts registered
                        [DZUIAlertUtility alertWithMessage:@"Please register a twitter account to your device" title:@"Information" forDuration:3];
                    } else {
                        // Not granted.
                    }
                    [utility dismiss];
                    utility = nil;
                });
            }];
        }
            break;
            
        case 1: // View Profile Image
        {
            if ( self.selectedAccount != nil ) {
                NSURL *imageURL = [self.twitterClient profileImageURLForUserName:self.selectedAccount.username size:@"original"];
                [self performSegueWithIdentifier:@"push_image_view" sender:imageURL];
                

            } else {
                [DZUIAlertUtility alertWithMessage:@"Please choose a twitter account" title:@"Information" forDuration:3];
            }   
            
        }
            break;
        case 2: // Update Profile image
        {
            if ( self.selectedAccount != nil ) {
                [self startProfileImageUpdateChain]; 
            } else {
                [DZUIAlertUtility alertWithMessage:@"Please choose a twitter account" title:@"Information" forDuration:3];
            }   
        }
            break;
            
        case 3: // Timeline
        {
            if ( self.selectedAccount ) {
                [self performSegueWithIdentifier:@"push_timeline" sender:self];
            } else {
                [DZUIAlertUtility alertWithMessage:@"Please choose a twitter account" title:@"Information" forDuration:3];                
            }
        }
            
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ( indexPath.section == 0 ) {
        [self handleMainMenuAtIndex:indexPath.row];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Storyboard & Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"push_accounts"]) {
        TwitterAccountsViewController *viewController = (TwitterAccountsViewController *) segue.destinationViewController;
        viewController.accounts = (NSArray *) sender;
        viewController.delegate = self;
    } else if ( [segue.identifier isEqualToString:@"push_image_view"] ) {
        SimpleImageViewController *viewController = (SimpleImageViewController *) segue.destinationViewController;
        viewController.imageURL = sender;
        viewController.title = [NSString stringWithFormat:@"Profile Image for @%@", self.selectedAccount.username];
    } else if ( [segue.identifier isEqualToString:@"push_timeline"] ) {
        TwitterTimelineViewController *viewController = (TwitterTimelineViewController *) segue.destinationViewController;
        viewController.twitterClient = self.twitterClient;
        viewController.account = self.selectedAccount;
    } else if ( [segue.identifier isEqualToString:@"push_imagequote_tweet"] ) {
        ImageQuoteComposerViewController *viewController = (ImageQuoteComposerViewController *) segue.destinationViewController;
        viewController.delegate = self;
    } // push_imagequote_tweet
    // ImageQuoteComposerViewController
}

#pragma mark - TwitterAccountsViewControllerDelegate
- (void) accountsViewController:(TwitterAccountsViewController *)accountsViewController didSelectAccount:(ACAccount *)account
{
    self.selectedAccount = account;
    self.labelAccountUsername.text = account.username;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Internal methods
- (BOOL) showTweetComposerWithImage:(UIImage *) image withURL:(NSURL *) url initialText:(NSString *) initialText
{
    // 1. Check if we can tweet
    if ( [TWTweetComposeViewController canSendTweet] ) {
        
        // 2. Instantiation
        TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
        
        // 3, 4, 5. Initial Tweet contents
        [viewController setInitialText:initialText];
        if ( image ) {
            [viewController addImage:image];
        }
        if ( url ) {
            [viewController addURL:url];
        }
        
        // 6. Completion Handler block
        TWTweetComposeViewControllerCompletionHandler completionHandler =
        ^(TWTweetComposeViewControllerResult result) {
            // This block of code will be excuted on completion of the tweet request
            // or the user cancelled
            if ( result == TWTweetComposeViewControllerResultDone ) {
                NSLog(@"Tweet was successful.");
                [DZUIAlertUtility alertWithMessage:@"Tweet was successful" title:@"Information" forDuration:3];
            } else if ( result == TWTweetComposeViewControllerResultCancelled ) {
                NSLog(@"Tweet was unsuccessful.");
                [DZUIAlertUtility alertWithMessage:@"Tweet was unsuccessful" title:@"Information"];
            }
            [self dismissModalViewControllerAnimated:YES];
        };
        [viewController setCompletionHandler:completionHandler];    
        
        // 7. Presentation
        [self presentModalViewController:viewController animated:YES];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - DZUISimpleViewControllerDelegate
- (void) viewControllerDone:(UIViewController *)vc
{
    if ( [vc isKindOfClass:[ImageQuoteComposerViewController class]] ) {
        ImageQuoteComposerViewController *viewController = (ImageQuoteComposerViewController *) vc;
        UIImage *image = [viewController quoteImage];
        if ( image ) {
            NSString *text = [NSString stringWithFormat:@"%@ -%@", [viewController quote], [viewController signature]];
            [self showTweetComposerWithImage:image withURL:[NSURL URLWithString:@"http://www.iosappdev.co.kr"] initialText:text];
            
        }
    }
}
#pragma mark - Actions



@end
