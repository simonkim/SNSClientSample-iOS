//
//  TwitterStatusCell.h
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterStatusCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelDisplayName;
@property (nonatomic, weak) IBOutlet UILabel *labelUsername;
@property (nonatomic, weak) IBOutlet UILabel *labelTime;

@end
