//
//  TwitterClientTests.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 1..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "TwitterClientUtility.h"
#import "Base64Encoder.h"
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <Twitter/TWRequest.h>

@interface TwitterClientUtility()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountTypeTwitter;
@end

@implementation TwitterClientUtility
@synthesize accountStore = _accountStore;
@synthesize accountTypeTwitter = _accountTypeTwitter;

#pragma mark - Properties
- (ACAccountStore *) accountStore
{
    if ( _accountStore == nil ) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (ACAccountType *) accountTypeTwitter 
{
    if ( _accountTypeTwitter == nil ) {
        _accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return _accountTypeTwitter;
}

#pragma mark - API
- (void) queryAccountsWithCompletion:(void (^)(BOOL granted, NSArray *accounts)) completion
{
    //ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    //ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:self.accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error){        
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountTypeTwitter];  
            
            for (ACAccount *account in accounts) {
                NSLog(@"twitter account : %@, %@", account.username, account.description);
            }            
            if ( completion ) completion( YES, accounts );
        } else {
            if ( completion ) completion( NO, nil );
        }
    }];    
}

/*
    succeed: YES | NO
    userInfo: { urlResponse: ..., response:..., error:... }
 */
- (void) updateProfileWithImageData:(NSData *) imageData account:(ACAccount *) account completed:(void (^)(BOOL succeed, NSDictionary *userInfo)) completed
{
    // http://api.twitter.com/1/account/update_profile_image.format 
    // parameters
    // image: base64 encoded GIF, JPG or PNG
    
    // Now make an authenticated request to our endpoint
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"1" forKey:@"include_entities"];
    
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/account/update_profile_image.json"];
    
    //  Build the request with our parameter 
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:nil 
                                          requestMethod:TWRequestMethodPOST];
    // Attach the account object to this request
    [request setAccount:account];
    
    // Profile Image Data
    NSString *base64 = [Base64Encoder base64StringFromData:imageData length:imageData.length];
    NSData *base64Data = [base64 dataUsingEncoding:NSASCIIStringEncoding];
    [request addMultiPartData:base64Data withName:@"image" type:@"multipart/form-data"];
    
    
    // Perform request
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        BOOL result = NO;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        // userInfo: { urlResponse:... }
        if ( urlResponse && (urlResponse.statusCode / 100) == 2 ) {
            // successfully requested
            result = YES;
            [userInfo setObject:urlResponse forKey:@"urlResponse"];
        }
        
        if ( urlResponse ) {
            NSLog(@"URLResponse:%@", [urlResponse description]);
            NSLog(@"statusCode:%d", urlResponse.statusCode);
            NSLog(@"headerFields:%@", [[urlResponse allHeaderFields] description]);
        }
        
        
        if (responseData) {
            NSError *jsonError;
            NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];            
            if (timeline) {                          
                // at this point, we have an object that we can parse
                NSLog(@"%@", timeline);
                [userInfo setObject:timeline forKey:@"response"];
            } else { 
                // inspect the contents of jsonError
                NSLog(@"%@", jsonError);
                
                error = jsonError;
            }
            
        } else {
            // inspect the contents of error 
            NSLog(@"%@", error);
        }
        
        if ( error ) {
            [userInfo setObject:error forKey:@"error"];
        }
        
        if ( completed ) completed( result, userInfo );
    }];       
}

- (void) updateProfileWithImageURL:(NSURL *) imageURL account:(ACAccount *) account completed:(void (^)(BOOL succeed, NSDictionary *userInfo)) completed
{
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [self updateProfileWithImageData:imageData account:account completed:completed];
 
}
- (NSString *) filterProfileImageSizeString:(NSString *) sizeString
{
    NSArray *validSizeStrings = [NSArray arrayWithObjects:@"normal", @"mini", @"bigger", @"original", nil];
    if ( [validSizeStrings indexOfObject:sizeString] == NSNotFound ) {
        sizeString = @"normal";
    }
    return sizeString;
}

- (NSURL *) profileImageURLForUserName:(NSString *) username size:(NSString *) sizeString
{
    // http://api.twitter.com/1/users/profile_image/:screen_name.format

    sizeString = [self filterProfileImageSizeString:sizeString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=%@", username, sizeString]];
    return url;
}

@end
