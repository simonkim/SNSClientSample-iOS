//
//  DZUIImagePickerUtility.h
//  DZUILib
//
//  Created by Simon Kim on 12. 3. 25..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DZUIImagePickerUtility : NSObject

+ (DZUIImagePickerUtility *) imagePickerUtilityWithImagePickerReadyBlock:(void (^)(UIImagePickerController *picker)) pickerReadyBlock
                                                        imagePickedBlock:(void (^)(UIImage *image)) picked 
                                                          cancelledBlock:(void (^)(void)) cancelled;
@end
