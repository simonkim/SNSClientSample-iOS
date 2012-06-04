//
//  TwitterStatusCell.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "TwitterStatusCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TwitterStatusCell
@synthesize profileImageView = _profileImageView;
@synthesize labelDisplayName = _labelDisplayName;
@synthesize labelText = _labelText;
@synthesize labelUsername = _labelUsername;
@synthesize labelTime = _labelTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setProfileImageView:(UIImageView *)profileImageView
{
    // intercept the moment the image view object is set.
    if ( profileImageView ) {
        profileImageView.layer.cornerRadius = 4;
    }
    _profileImageView = profileImageView;
}

@end
