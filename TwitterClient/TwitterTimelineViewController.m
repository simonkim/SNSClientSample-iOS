//
//  TwitterTimelineViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 4..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "TwitterTimelineViewController.h"
#import "TwitterStatusCell.h"
#import "DZUIAlertUtility.h"
#import "DZUIActivityIndicatorUtility.h"

@interface TwitterTimelineViewController ()
{
    BOOL _appeared;
}
@property (nonatomic, strong) NSArray *arrayStatuses;
@property (nonatomic, strong) NSDateFormatter *twitterDateFormatter;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@end

@implementation TwitterTimelineViewController
@synthesize twitterClient = _twitterClient;
@synthesize account = _account;
@synthesize arrayStatuses = _arrayStatuses;
@synthesize twitterDateFormatter = _twitterDateFormatter;
@synthesize imageCache = _imageCache;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidAppear:(BOOL)animated
{
    if ( _appeared == NO ) {
        [self reloadTimeline];
        
        self.title = [NSString stringWithFormat:@"@%@", self.account.username];
        _appeared = YES;
    }
    
    
}

#pragma mark - Properties
- (NSDateFormatter *) twitterDateFormatter
{
    if ( _twitterDateFormatter == nil ) {
        _twitterDateFormatter = [[NSDateFormatter alloc] init];
        //Wed Dec 01 17:08:03 +0000 2010
        [_twitterDateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    }
    return _twitterDateFormatter;
}

- (NSMutableDictionary *) imageCache
{
    if ( _imageCache == nil ) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

#pragma mark - Internal methods
- (void) reloadTimeline
{
    DZUIActivityIndicatorUtility *utility = [DZUIActivityIndicatorUtility activityIndicatorInView:self.view withText:@"Reloading timeline..."];
    
    [self.twitterClient requestHomeTimelineWithAccount:self.account parameters:nil completed:^(BOOL succeed, NSDictionary *userInfo) {
        NSArray *timeline = [userInfo objectForKey:@"response"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( succeed && timeline.count > 0) {
                //NSLog(@"timeline:%@", [timeline description]);
                self.arrayStatuses = timeline;
                [self.tableView reloadData];
                
            } else {
                NSString *errorMessage = @"Unknown error";
                NSError *error = [userInfo objectForKey:@"error"];
                if ( error ) {
                    errorMessage = [NSString stringWithFormat:@"Loading timeline failed:%@", error.localizedDescription];
                }
                [DZUIAlertUtility alertWithMessage:errorMessage 
                                             title:@"Error"];
                
            }  
            [utility dismiss];
        });
        
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayStatuses.count;
}
- (NSString *) timeIntervalStringOf:(NSTimeInterval) timeInterval
{
    NSString *intervalString = @"Now";
    NSInteger num = 0;
    if ( timeInterval < 0 ) {

        timeInterval = ABS(timeInterval);
        num = timeInterval / (24 * 60 * 60);
        if ( num > 0 ) {
            // days
            intervalString = [NSString stringWithFormat:@"%dd", num];
        } else {
            num = timeInterval / ( 60 * 60 );
            if ( num > 0 ) {
                // hours
                intervalString = [NSString stringWithFormat:@"%dhrs", num];
            } else {
                num = timeInterval / ( 60 );
                if ( num > 0 ) {
                    // min
                    intervalString = [NSString stringWithFormat:@"%dmin", num];
                } else {
                    // sec
                    intervalString = [NSString stringWithFormat:@"%ds", timeInterval];
                }
            }
        }
    }
    return intervalString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell_tweet_status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSLog(@"cellForRowAtIndexPath:%d.%d", indexPath.section, indexPath.row);
    
    // Configure the cell...
    if ( [cell isKindOfClass:[TwitterStatusCell class]] ) {
        TwitterStatusCell *statusCell = (TwitterStatusCell *) cell;
        NSDictionary *status = [self.arrayStatuses objectAtIndex:indexPath.row];
        statusCell.labelText.text = [status objectForKey:@"text"];
        statusCell.labelDisplayName.text = [status valueForKeyPath:@"user.name"];
        statusCell.labelUsername.text = [NSString stringWithFormat:@"@%@", [status valueForKeyPath:@"user.screen_name"]];
        
        // Date
        NSDate *created_at = [status valueForKey:@"created_at"];
        if ( [created_at isKindOfClass:[NSDate class] ] ) {
            NSTimeInterval timeInterval = [created_at timeIntervalSinceNow];
            statusCell.labelTime.text = [self timeIntervalStringOf:timeInterval];
        } else if ( [created_at isKindOfClass:[NSString class]] ) {
            NSDate *date = [self.twitterDateFormatter dateFromString: (NSString *) created_at];
            NSTimeInterval timeInterval = [date timeIntervalSinceNow];
            statusCell.labelTime.text = [self timeIntervalStringOf:timeInterval];
        }
        
        // Profile image
        statusCell.profileImageView.image = nil;
        NSString *imageURLString = [status valueForKeyPath:@"user.profile_image_url"];
        if ( imageURLString ) {
            UIImage *image = [self.imageCache objectForKey:imageURLString];
            if ( image ) {
                statusCell.profileImageView.image = image;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //
                    NSURL *url = [NSURL URLWithString:imageURLString];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    NSLog(@"dataWithContentsOfURL:%d.%d", indexPath.section, indexPath.row);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //
                        UIImage *image = [UIImage imageWithData:imageData];
                        statusCell.profileImageView.image = image;
                        [statusCell setNeedsLayout];
                        NSLog(@"imageWithData:%d.%d", indexPath.section, indexPath.row);
                        [self.imageCache setObject:image forKey:imageURLString];
                    });
                });
            }
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (IBAction)actionRefresh:(id)sender {
    [self reloadTimeline];
}

@end
