//
//  FBOGUtility.h
//  DZMobileTextComposer
//
//  Created by Simon Kim on 12. 4. 3..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
// Facebook Open Graph Utility

@interface FBOGUtility : NSObject
@property (nonatomic,strong) Facebook *facebook;

- (void) publishObjectWithName:(NSString *) objectName 
                         atURL:(NSURL *)objectURL ogNamespace:(NSString *) ogNamespace
                 completeBlock:(void (^)(NSString *fbObjectId)) completeBlock 
                    errorBlock:(void (^)(NSError *error)) errorBlock;

- (void) wallpostWithParams:(NSDictionary *) params
              completeBlock:(void (^)(NSString *fbObjectId)) completeBlock 
                 errorBlock:(void (^)(NSError *error)) errorBlock; 

- (void) queryGraph:(NSString *) graphPath
      completeBlock:(void (^)(NSDictionary *results)) completeBlock 
         errorBlock:(void (^)(NSError *error)) errorBlock; 

- (void) requestGraph:(NSString *) graphPath
            andParams:(NSMutableDictionary *)params
        andHttpMethod:(NSString *)httpMethod
        completeBlock:(void (^)(NSDictionary *results)) completeBlock 
           errorBlock:(void (^)(NSError *error)) errorBlock;

// list groups
// 
// Sample link: https://graph.facebook.com/me/groups?access_token=
/* Sample response
 {
 "data": [
 {
 "version": 1,
 "name": "IOS \uc571\uac1c\ubc1c \uc138\ubbf8\ub098 \uadf8\ub8f9",
 "id": "393329794018232",
 "administrator": true,
 "bookmark_order": 3
 },
 {
 "version": 1,
 "name": "Facebook Mobile HACK - Seoul",
 "id": "356101177765424",
 "bookmark_order": 1
 },
 {
 "version": 1,
 "name": "Nextreaming",
 "id": "186007368105291",
 "bookmark_order": 5
 },
 {
 "version": 1,
 "name": "PalmPalm",
 "id": "165423973498254",
 "bookmark_order": 2
 },
 {
 "version": 1,
 "name": "Ex-Nex",
 "id": "166160943418850",
 "bookmark_order": 4
 }
 ],
 "paging": {
 "next": "https://graph.facebook.com/me/groups?access_token=AAAAAAITEghMBAJhlw25QSc7ZAWYH07eNjk4SZC3vrZBVHGasZBK6z40vQQeHLQu9frOAYZCwR8PF6UOUZCvqDgDrZAJlgrSAxubjdYvAWZCR0MiZBZAioQaw9P&limit=5000&offset=5000&__after_id=166160943418850"
 }
 } 
 
 */


/* Sample code
 // Scaning Groups: requires user_groups permission
 FBOGUtility *utility = [[FBOGUtility alloc] init];
 [self addStrongCookieObject:utility];
 [utility queryGraph:@"me/groups" 
 completeBlock:^(NSDictionary *results) {
 NSLog(@"Class:%@", NSStringFromClass([results class]));
 NSLog(@"Response:'%@'", [results description]);
 [self removeStrongCookieObject:utility];
 } errorBlock:^(NSError *error) {
 NSLog(@"Error:'%@'", [error description]);
 [self removeStrongCookieObject:utility];
 }];
 
 */
@end
