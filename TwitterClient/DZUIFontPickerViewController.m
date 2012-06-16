//
//  DZUIFontPickerViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 15..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "DZUIFontPickerViewController.h"

@interface DZUIFontPickerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelSize;
@property (weak, nonatomic) IBOutlet UILabel *labelPreview;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic) CGFloat pointSize;
@end

@implementation DZUIFontPickerViewController
@synthesize labelSize;
@synthesize labelPreview;
@synthesize pointSize = _pointSize;
@synthesize selectedFont = _selectedFont;
@synthesize delegate = _delegate;

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
    
    self.pointSize = 25;
}

- (void)viewDidUnload
{
    [self setLabelSize:nil];
    [self setLabelPreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1. Font Sample, single row
    // 2. Font family names
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    } else {
        return [UIFont familyNames].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIDFont = @"cell_font";
    static NSString *cellIDFontPreview = @"cell_font_preview";
    UITableViewCell *cell;
    if ( indexPath.section == 0 ) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDFontPreview];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDFont];
        //NSArray *familyNames = [UIFont familyNames];
        //NSString *familyName = [familyNames objectAtIndex:indexPath.row];
        cell.textLabel.text = [self familyNameAtIndex:indexPath.row];
        /*
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        if ( fontNames.count > 0 ) {
            cell.detailTextLabel.text = [fontNames objectAtIndex:0];
        }
         */
        NSString *fontName = [self fontNameAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:fontName size:cell.textLabel.font.pointSize];
    }
    
    // Configure the cell...
    
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 116;
    } else {
        return tableView.rowHeight;
    }
}

#pragma mark - Internal methods
- (NSString *) familyNameAtIndex:(NSUInteger) index
{
    NSArray *familyNames = [UIFont familyNames];
    NSString *familyName = [familyNames objectAtIndex:index];
    
    return familyName;
}

- (NSString *) fontNameAtIndex:(NSUInteger) index
{
    NSString *familyName = [self familyNameAtIndex:index];
    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    NSString *fontName = familyName;
    if ( fontNames.count > 0 ) {
        fontName = [fontNames objectAtIndex:0];
    }

    return fontName;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( indexPath.section == 1 ) {
        NSString *fontName = [self fontNameAtIndex:indexPath.row];
        UIFont *font = [UIFont fontWithName:fontName size:self.pointSize];
        NSLog(@"font:%@", [font description]);
        self.labelPreview.font = font; 
        self.selectedFont = font;
        [self.delegate viewControllerDone:self];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)actionStepper:(UIStepper *)sender {
    self.labelSize.text = [NSString stringWithFormat:@"%@", sender.value];
    self.labelPreview.font = [self.labelPreview.font fontWithSize:sender.value]; 
    self.pointSize = sender.value;
}

@end
