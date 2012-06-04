//
//  DZUIImagePickerUtility.m
//  DZUILib
//
//  Created by Simon Kim on 12. 3. 25..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import "DZUIImagePickerUtility.h"
#import <MobileCoreServices/MobileCoreServices.h> // kUTTypeImage


@interface DZUIImagePickerUtility() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) void (^pickedBlock)(UIImage *image);
@property (nonatomic, strong) void (^cancelledBlock)(void);
@end

@implementation DZUIImagePickerUtility
@synthesize cancelledBlock = _cancelledBlock;
@synthesize pickedBlock = _pickedBlock;

+ (DZUIImagePickerUtility *) imagePickerUtilityWithImagePickerReadyBlock:(void (^)(UIImagePickerController *picker)) pickerReadyBlock
                                                        imagePickedBlock:(void (^)(UIImage *image)) picked 
                                                          cancelledBlock:(void (^)(void)) cancelled
{
    // The caller provides with the following 3 blocks
    //  1. pickerReadyBlock(picker): allows caller to present UIImagePickerController object since it requires a View Controller
    //  2. picked(image): invoked when the user has chosen an image. The caller simply needs to implement this block when it's calling this method
    //  3. cancelled: invoked when the user cancelled choosing an image.
    
    // 1. We need an object to store the provided 2 blocks of 3.
    DZUIImagePickerUtility *utility = [[DZUIImagePickerUtility alloc] init];
    utility.pickedBlock = picked;
    utility.cancelledBlock = cancelled;
    
    // 2. Create an image picker object, setup for photo library source type. and utility object plays the delegate role.
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = utility;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    // 3. It's the first chance to call the block back: for presenting the image picker controller
    pickerReadyBlock( imagePicker );

    // 4. CAUTION: if the call does not keep strong reference to 'utility' object, it will be freed immedately.
    return utility;
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // User cancelled
    self.cancelledBlock();
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // User has chosen an image
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a still image capture
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if ( image == nil ) {
            // try original image
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            NSLog(@"Picking up the original image");
        } else {
            NSLog(@"Picking up the edited image");
            
        }
        // This is what the caller actually waiting for. calling back the block pickedBlock(image)
        self.pickedBlock( image );
    }
}
@end
