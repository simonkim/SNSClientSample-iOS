//
//  SimpleImageViewController.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSURL *imageURL;
@end
