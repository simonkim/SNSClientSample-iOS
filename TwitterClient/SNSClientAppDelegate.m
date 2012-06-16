//
//  TwitterClientAppDelegate.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 1..
//  Copyright (c) 2012년 http://iosappdev.co.kr. All rights reserved.
//

#import "SNSClientAppDelegate.h"
#define kFacebookAppID  @"441082825910307"

/// Facebook Integration Begin
@interface SNSClientAppDelegate() <FBSessionDelegate>
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSMutableSet *fbsessionDelegates;
@end
/// Facebook Integration End

@implementation SNSClientAppDelegate

@synthesize window = _window;
/// Facebook Integration Begin
@synthesize facebook = _facebook;
@synthesize fbsessionDelegates = _fbsessionDelegates;
/// Facebook Integration End

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /// Facebook Integration Begin
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }    
    /// Facebook Integration End
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - URL handling w/ Facebook support 
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    /// Facebook Integration Begin
    return [self.facebook handleOpenURL:url];     
    /// Facebook Integration End
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    /// Facebook Integration Begin
    return [self.facebook handleOpenURL:url]; 
    /// Facebook Integration End
}

#pragma mark - Properties

/// Facebook Integration Begin
- (Facebook *) facebook 
{
    if ( _facebook == nil ) {
        _facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
    }
    return _facebook;
}
- (NSMutableSet *) fbsessionDelegates
{
    if ( _fbsessionDelegates == nil ) {
        _fbsessionDelegates = [NSMutableSet set];
    }
    return _fbsessionDelegates;
}

/// Facebook Integration End

/// Facebook Integration Begin
#pragma mark - FBSessionDelegate
/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize]; 
    
    [self.fbsessionDelegates makeObjectsPerformSelector:@selector(fbDidLogin)];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{

    for (id<FBSessionDelegate> delegate in self.fbsessionDelegates ) {
        [delegate fbDidNotLogin:cancelled];
    }
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];    

    for (id<FBSessionDelegate> delegate in self.fbsessionDelegates ) {
        [delegate fbDidExtendToken:accessToken expiresAt:expiresAt];
    }

}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }    
    [self.fbsessionDelegates makeObjectsPerformSelector:@selector(fbDidLogout)];
    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    [self.fbsessionDelegates makeObjectsPerformSelector:@selector(fbSessionInvalidated)];
}
/// Facebook Integration End

#pragma mark - API
/// Facebook Integration Begin
- (void) facebookLogin
{
    if ( !self.facebook.isSessionValid) {
        [self.facebook authorize:[[NSArray alloc] initWithObjects:@"user_groups", @"publish_actions", @"publish_stream", @"read_stream", nil]];
    }
}

- (BOOL) facebookLoggedIn
{
    return self.facebook.isSessionValid;
}

- (void) registerFBSessionDelegate:(id<FBSessionDelegate>) delegate
{
    [self.fbsessionDelegates addObject:delegate];
}
- (void) unregisterFBSessionDelegate:(id<FBSessionDelegate>) delegate
{
    [self.fbsessionDelegates removeObject:delegate];
}
/// Facebook Integration End

@end
