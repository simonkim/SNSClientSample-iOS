//
//  SNSFBMenuViewController.m
//  SNSClient
//
//  Created by Simon Kim on 12. 6. 16..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "SNSFBMenuViewController.h"
#import "SNSClientAppDelegate.h"
#import "ImageQuoteComposerViewController.h"

#import "FBOGUtility.h"
#import "DZUIAlertUtility.h"
#import "DZUIImagePickerUtility.h"
#import "DZUIActivityIndicatorUtility.h"
#import "DZUISimpleViewControllerDelegate.h"


@interface SNSFBMenuViewController () <FBSessionDelegate, DZUISimpleViewControllerDelegate>

@end

@implementation SNSFBMenuViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self facebookLoginButton]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillAppear:(BOOL)animated
{
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    
    [appDelegate registerFBSessionDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    
    [appDelegate unregisterFBSessionDelegate:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Facebook
- (UIButton *) facebookLoginButton
{
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    BOOL loggedIn = appDelegate.facebookLoggedIn;
    
    UIImage *image = nil;
    if ( loggedIn ) {
        image = [UIImage imageNamed:@"FBConnect.bundle/images/LogoutNormal"];
    } else {
        image = [UIImage imageNamed:@"FBConnect.bundle/images/LoginNormal"];
    }
    
    UIButton *facebookLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [facebookLogin setImage:image forState:UIControlStateNormal];
    [facebookLogin addTarget:self action:@selector(actionLoginLogout:) forControlEvents:UIControlEventTouchUpInside];
    facebookLogin.bounds = CGRectMake(0, 0, image.size.width, image.size.height);   
    return facebookLogin;
}

- (void) actionLoginLogout:(id) sender
{
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;

    if ( [appDelegate facebookLoggedIn] ) {
        // Logout
        [[appDelegate facebook] logout];
    } else {
        // Login
        [appDelegate facebookLogin];        
    }
}

#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - Internal methods
- (void) uploadImage:(UIImage *) image withMessage:(NSString *) message resultBlock:(void(^)(NSString *fbObjectId)) resultBlock
{
    FBOGUtility *__block utility = [[FBOGUtility alloc] init];
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    
    utility.facebook = appDelegate.facebook;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            image, @"picture",  // picture: URL
                            nil];
    
    if ( message ) {
        [params setObject:message forKey:@"message"];
    }
    
    [utility requestGraph:@"me/photos" andParams:params andHttpMethod:@"POST"
                  completeBlock:^(NSDictionary *result) {
                      NSString *fbObjectId = [result objectForKey:@"id"];
                      NSLog(@"Article Object ID:%@", fbObjectId);
                      utility = nil;
                      if (resultBlock) resultBlock(fbObjectId);
                  } errorBlock:^(NSError *error) {
                      utility = nil;
                      if (resultBlock) resultBlock(nil);
                      
                  }];  
    
}

- (void) startUploadPhotoChain
{
        DZUIImagePickerUtility *__block utility = [DZUIImagePickerUtility imagePickerUtilityWithImagePickerReadyBlock:^(UIImagePickerController *picker) {
            // Image Picker Controller customization
            picker.allowsEditing = YES;
            
            [self presentModalViewController:picker animated:YES];
        } imagePickedBlock:^(UIImage *image) {
            //
            [self dismissViewControllerAnimated:YES completion:^{
                //
                DZUIActivityIndicatorUtility * __block activityUtility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Uploading image..."];
                
                [self uploadImage:image withMessage:@"Uploaded a photo" resultBlock:^(NSString *fbObjectId) {
                    //
                    if ( fbObjectId ) {
                        //...
                        [DZUIAlertUtility alertWithMessage:                 
                         [NSString stringWithFormat:@"%@ has been uploaded", @"Photo"]             
                                                     title:@"Information" forDuration:3];  
                        
                    } else {
                        // ...
                        [DZUIAlertUtility alertWithMessage:@"Failed uploading photo" 
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
#pragma mark - Table view delegate
typedef enum {
    SNSFBMenuItemProfile = 0,
    SNSFBMenuItemNewsFeed = 1,
    SNSFBMenuItemPhotos = 2,
    SNSFBMenuItemSimplePost = 3,
    SNSFBMenuItemUploadPhoto = 4,
    SNSFBMenuItemUpoadImageQuote = 5,
} SNSFBMenuItemType;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    BOOL loggedIn = appDelegate.facebookLoggedIn;
    
    switch (indexPath.row) {
        case SNSFBMenuItemUploadPhoto:
            //
            if ( loggedIn ) {
                [self startUploadPhotoChain];
            } else {
                [DZUIAlertUtility alertWithMessage:@"Login to Facebook first" title:@"Information"];
            }
            break;
            
        case SNSFBMenuItemUpoadImageQuote:
            if ( loggedIn ) {
                [self performSegueWithIdentifier:@"push_imagequote_facebook" sender:self];
            } else {
                [DZUIAlertUtility alertWithMessage:@"Login to Facebook first" title:@"Information"];
            }
            break;
        default:
            break;
    }
}


#pragma mark - FBSessionDelegate
- (void)fbDidLogin
{
    self.navigationItem.rightBarButtonItem.customView = [self facebookLoginButton];    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
}

- (void)fbDidLogout
{
    self.navigationItem.rightBarButtonItem.customView = [self facebookLoginButton];        
}

- (void)fbSessionInvalidated
{
    self.navigationItem.rightBarButtonItem.customView = [self facebookLoginButton];    
}

#pragma mark - Actions
- (IBAction)actionTest:(id)sender 
{
    FBOGUtility *__block utility = [[FBOGUtility alloc] init];
    UIApplication *application = [UIApplication sharedApplication];
    SNSClientAppDelegate *appDelegate = (SNSClientAppDelegate *) application.delegate;
    
    utility.facebook = appDelegate.facebook;
    
    NSURL *thumbnailURL = [NSURL URLWithString:@"http://www.iosappdev.co.kr/iosappdev/wp-content/uploads/2012/01/simon_face.png"];
    NSURL *linkURL = [NSURL URLWithString:@"https://github.com/simonkim/SNSClientSample-iOS"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Social Image Quote is under development. Find the link for the source code of the current project.", @"message",       // message: Text
                            [thumbnailURL absoluteString], @"picture",  // picture: URL
                            [linkURL absoluteString], @"link",          // link: URL
                            @"Social Image Quote", @"name",                    // name: Text
                            @"Distribute your cool quoted image to social networks", @"caption",                   // caption: Text
                            @"https://github.com/simonkim/SNSClientSample-iOS", @"description",     // description: Text
                            @"link", @"type",                           // type: Text
                            nil];
    
    [utility wallpostWithParams:params
                  completeBlock:^(NSString *fbObjectId) {
                      NSLog(@"Article Object ID:%@", fbObjectId);
                      [DZUIAlertUtility alertWithMessage:                 
                       [NSString stringWithFormat:@"Link to the post(%@) has been shared to your Facebook Wall", @"Wall post"]             
                                                   title:@"Information" forDuration:3];  
                      
                      utility = nil;
                  } errorBlock:^(NSError *error) {
                      [DZUIAlertUtility alertWithMessage:
                       [NSString stringWithFormat:@"Couldn't write to your Facebook Wall:%@", error.localizedDescription] 
                                                   title:@"Error"];
                      
                      utility = nil;
                  }];  
}

#pragma mark - Storyboard
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"push_imagequote_facebook"] ) {
        ImageQuoteComposerViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
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
            
            DZUIActivityIndicatorUtility * __block activityUtility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Uploading image..."];

            [self uploadImage:image withMessage:text resultBlock:^(NSString *fbObjectId) {
                //
                if ( fbObjectId ) {
                    //...
                    [DZUIAlertUtility alertWithMessage:                 
                     [NSString stringWithFormat:@"%@ has been uploaded", @"Image"]             
                                                 title:@"Information" forDuration:3];  
                    
                } else {
                    // ...
                    [DZUIAlertUtility alertWithMessage:@"Failed uploading image" 
                                                 title:@"Error"];
                }
                [activityUtility dismiss];
                activityUtility = nil;                        
                
            }];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
