//
//  DZUIActivityIndicatorUtility.m
//  DZUILib
//
//  Created by Simon Kim on 12. 4. 2..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import "DZUIActivityIndicatorUtility.h"
#import <QuartzCore/QuartzCore.h>

@interface DZUIActivityIndicatorUtility()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation DZUIActivityIndicatorUtility
@synthesize activityIndicator = _activityIndicator;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height /2 - self.activityIndicator.bounds.size.height /3);
        [self addSubview:self.activityIndicator];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = 16;
    }
    return self;
}

- (void) dismiss
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
    
    [self removeFromSuperview];
}


+ (DZUIActivityIndicatorUtility *) activityIndicatorInView:(UIView *) view withCustomView:(UIView *) customView
{
    NSLog(@"activityIndicatorInView:withCustomView:");
    NSLog(@"- view:%p", view);
    NSLog(@"- customView:%p", customView);
    DZUIActivityIndicatorUtility *utility = [[DZUIActivityIndicatorUtility alloc] initWithFrame:CGRectMake(0, 0, 160, 120)];
    NSLog(@"- utility:%p", utility);
    utility.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);

    [utility addSubview:customView];
    
    CGFloat top = utility.activityIndicator.center.y + utility.activityIndicator.bounds.size.height/2;
    CGFloat margin = utility.bounds.size.height - top;
    customView.center = CGPointMake(utility.bounds.size.width/2, utility.bounds.size.height - (margin - customView.bounds.size.height/2));
    [utility.activityIndicator startAnimating];
    
    [view addSubview:utility];
    return utility;
}
+ (DZUIActivityIndicatorUtility *) activityIndicatorInView:(UIView *) view withText:(NSString *) text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 156, 40)];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(1,1);
    label.minimumFontSize = 10;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    
    return [[self class] activityIndicatorInView:view withCustomView:label];
}

@end
