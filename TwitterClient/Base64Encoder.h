//
//  Base64Encoder.h
//  Original source can be found from:
//      - NSStringAdditions.h of WordPress-iOS project
//      - https://github.com/beaucollins/WordPress-iOS
//      - https://github.com/beaucollins/WordPress-iOS/blob/vendor/Vendor/xmlrpc/NSStringAdditions.h
//      

#import <UIKit/UIKit.h>
@interface Base64Encoder : NSObject
+ (NSUInteger) chunkSize;
+ (NSString *)base64StringFromData: (NSData *)data length: (int)length;

@end
