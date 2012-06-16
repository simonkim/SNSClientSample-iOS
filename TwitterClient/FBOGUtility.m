//
//  FBOGUtility.m
//  DZMobileTextComposer
//
//  Created by Simon Kim on 12. 4. 3..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import "FBOGUtility.h"

@interface FBOGUtility() <FBRequestDelegate>
@property (nonatomic, strong) FBRequest *fbRequest;

@property (nonatomic, strong) void (^completeBlock)(NSString *fbObjectId);
@property (nonatomic, strong) void (^completeListBlock)(NSDictionary *results);
@property (nonatomic, strong) void (^errorBlock)(NSError *error);
@end

// Facebook Open Graph Utility
@implementation FBOGUtility
@synthesize facebook = _facebook;

@synthesize fbRequest = _fbRequest;
@synthesize completeBlock = _completeBlock;
@synthesize completeListBlock = _completeListBlock;
@synthesize errorBlock = _errorBlock;



- (void) publishObjectWithName:(NSString *) objectName 
                         atURL:(NSURL *)objectURL
                     ogNamespace:(NSString *) ogNamespace
                 completeBlock:(void (^)(NSString *fbObjectId)) completeBlock 
                    errorBlock:(void (^)(NSError *error)) errorBlock 
{
    // objectName: "article", "photo", and so on
    // objectURL: URL to the open graph object named as 'objectName'
    // namespace: e.g. "richnote"
    
    self.completeBlock = completeBlock;
    self.errorBlock = errorBlock;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[objectURL absoluteString], objectName, nil];
    
    NSString *path = [NSString stringWithFormat:@"me/%@:publish", ogNamespace];
    self.fbRequest = [[self facebook] requestWithGraphPath:path 
                                                     andParams:params 
                                                 andHttpMethod:@"POST"
                                                   andDelegate:self];    
}



- (void) requestGraph:(NSString *) graphPath
          andParams:(NSMutableDictionary *)params
      andHttpMethod:(NSString *)httpMethod
      completeBlock:(void (^)(NSDictionary *results)) completeBlock 
         errorBlock:(void (^)(NSError *error)) errorBlock
{
    self.completeListBlock = completeBlock;
    self.errorBlock = errorBlock;
    
    self.fbRequest = [[self facebook] requestWithGraphPath:graphPath 
                                                     andParams:params 
                                                 andHttpMethod:httpMethod
                                                   andDelegate:self];        
}

- (void) queryGraph:(NSString *) graphPath
      completeBlock:(void (^)(NSDictionary *results)) completeBlock 
         errorBlock:(void (^)(NSError *error)) errorBlock
{
    [self requestGraph:graphPath andParams:nil andHttpMethod:@"GET" completeBlock:completeBlock errorBlock:errorBlock];
}

- (void) wallpostWithParams:(NSDictionary *) params
              completeBlock:(void (^)(NSString *fbObjectId)) completeBlock 
                 errorBlock:(void (^)(NSError *error)) errorBlock 
{
    /*
     /PROFILE_ID/feed	Publish a new post on the given profile's feed/wall	
     message, 
     picture, 
     link, 
     name, 
     caption, 
     description, 
     source, 
     place, 
     tags 
     */
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [self requestGraph:@"me/feed" 
             andParams:mutableParams 
         andHttpMethod:@"POST" 
         completeBlock:^(NSDictionary *result){
             if ( completeBlock ) {
                 NSString *resultId = [result objectForKey:@"id"];
                 NSLog(@"resultId:'%@'", resultId);
                 completeBlock(resultId);
             }
         }
            errorBlock:errorBlock];
}


#pragma mark - FBRequestDelegate
/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request:didFailWithError:'%@'", [error description]);
    self.errorBlock(error);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"request:didLoad:'%@'", [result description]);
    if ( self.completeListBlock ) {
        self.completeListBlock(result );
    } else if ( self.completeBlock ) {
        NSString *resultId = [result objectForKey:@"id"];
        NSLog(@"resultId:'%@'", resultId);
        self.completeBlock(resultId);
    }
}
@end
