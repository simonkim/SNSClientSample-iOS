//
//  TwitterStatusCell.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "TwitterStatusCell.h"

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

- (UIImageView *) profileImageView
{
    if ( _profileImageView == nil ) {
        NSLog(@"_profileImageView not ready?");
    }
    return _profileImageView;
}

@end
