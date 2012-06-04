//
//  TwitterClientMenuViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 1..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "TwitterClientMenuViewController.h"
#import "TwitterAccountsViewController.h"
#import "SimpleImageViewController.h"

#import "TwitterClientUtility.h"
#import "DZUIImagePickerUtility.h"
#import "DZUIAlertUtility.h"
#import "DZUIActivityIndicatorUtility.h"

@interface TwitterClientMenuViewController () <TwitterAccountsViewControllerDelegate>
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
            [DZUIAlertUtility alertWithMessage:@"Timeline not implemented yet" title:@"Information" forDuration:3];
            
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
    }
}

#pragma mark - TwitterAccountsViewControllerDelegate
- (void) accountsViewController:(TwitterAccountsViewController *)accountsViewController didSelectAccount:(ACAccount *)account
{
    self.selectedAccount = account;
    self.labelAccountUsername.text = account.username;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions



@end
