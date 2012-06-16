//
//  ImageQuoteComposerViewController.m
//  TwitterClient
//
//  Created by Simon Kim on 12. 6. 15..
//  Copyright (c) 2012년 iosappdev.co.kr. All rights reserved.
//

#import "ImageQuoteComposerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Twitter/TWTweetComposeViewController.h>

#import "DZUISimpleViewControllerDelegate.h"
#import "DZUISimpleColorPickerViewController.h"
#import "DZUIAlertUtility.h"
#import "DZUIImagePickerUtility.h"
#import "DZUIFontPickerViewController.h"

@interface ImageQuoteComposerViewController () <DZUISimpleViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImage *photoImage;      // can be nil
@property (nonatomic, strong) UIColor *colorBackground; // can be nil

@property (nonatomic) CGSize sizeQuoteMargin;           // need default
@property (nonatomic, strong) UIColor *colorQuote;      // need default
@property (nonatomic, strong) UIColor *colorBy;         // need default
@property (nonatomic) UITextAlignment alignmentQuote;   // need default
@property (nonatomic) UITextAlignment alignmentBy;      // need default
@property (nonatomic, strong) UIFont *fontQuote;        // default = textView
@property (nonatomic, strong) UIFont *fontBy;           // default = textField

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ImageQuoteComposerViewController
@synthesize imageView;
@synthesize textView = _textView;
@synthesize textField = _textField;
@synthesize photoImage = _photoImage;
@synthesize fontQuote = _fontQuote;
@synthesize fontBy = _fontBy;
@synthesize sizeQuoteMargin = _sizeQuoteMargin;
@synthesize alignmentQuote = _alignmentQuote;
@synthesize alignmentBy = _alignmentBy;
@synthesize colorBackground = _colorBackground;
@synthesize colorQuote = _colorQuote;
@synthesize colorBy = _colorBy;

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

    
    self.alignmentQuote = UITextAlignmentLeft;
    self.alignmentBy = UITextAlignmentRight;
    self.colorQuote = [UIColor whiteColor];
    self.colorBy = [UIColor whiteColor];
    self.sizeQuoteMargin = CGSizeMake(32,32);
    
    // text view accessory view
    [self setupTextViewAccessoryView];
    
    // text field delegate
    self.textField.delegate = self;
    UIStepper *stepper = [[UIStepper alloc] init];
    [stepper addTarget:self action:@selector(actionStepper:) forControlEvents:UIControlEventValueChanged];
    stepper.maximumValue = 100;
    stepper.minimumValue = 14;
    stepper.value = 25;
    stepper.stepValue = 1;
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbarItems];
    UIBarButtonItem *stepperItem = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    [items addObject:stepperItem];
    self.toolbarItems = items;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setTextView:nil];
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Internal methods
- (void) setupTextViewAccessoryView
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionTextViewDone:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:barButtonSpace, barButtonDone, nil]];
    self.textView.inputAccessoryView = toolbar;
    self.textView.layer.cornerRadius = 8;
    
}
#pragma mark - Table view data source


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

#pragma mark - Properties
- (UIFont *) fontQuote
{
    if ( _fontQuote == nil ) {
        _fontQuote = self.textView.font;
        if ( _fontQuote.pointSize < 25 ) {
            _fontQuote = [_fontQuote fontWithSize:25];
        }
    }
    return _fontQuote;
}

- (UIFont *) fontBy
{
    if ( _fontBy == nil ) {
        _fontBy = self.textField.font;
        if ( _fontBy.pointSize < 25 ) {
            _fontBy = [_fontBy fontWithSize:25];
        }
    }
    return _fontBy;
}

- (UIColor *) colorBackground
{
    if ( _colorBackground == nil ) {
        _colorBackground = [UIColor lightGrayColor];
    }
    return _colorBackground;
}

#pragma mark - Internal methods
- (UIImage *) imageWithColor:(UIColor *) color size:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) quoteImageWithQuote:(NSString *) quote whom:(NSString *) whom baseImage:(UIImage *) baseImage
{
    CGSize size = baseImage.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGRect rectQuote = CGRectInset(rect, self.sizeQuoteMargin.width, self.sizeQuoteMargin.height);
    CGRect rectBy;

    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Quote
    [self.colorQuote set];
    CGContextSetShadow(context, CGSizeZero, 2);
    [baseImage drawAtPoint:CGPointMake(0, 0)];
    CGSize sizeQuote = [quote drawInRect:rectQuote withFont:self.fontQuote lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // By...
    rectBy = rectQuote;
    rectBy.origin.y = rectQuote.origin.y + sizeQuote.height;
    rectBy.size.height -= sizeQuote.height;
    
    [self.colorBy set];
    whom = [NSString stringWithFormat:@"-%@", whom];
    [whom drawInRect:rectBy withFont:self.fontBy lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    
    // Signature
    UIFont *fontSignature = [self.fontBy fontWithSize:17];
    [[UIColor orangeColor] set];
    CGRect rectSignature = CGRectMake(self.sizeQuoteMargin.width, rectQuote.origin.y + rectQuote.size.height - fontSignature.pointSize, rectQuote.size.width, fontSignature.pointSize);
        
    NSString *signature = @"iosappdev.co.kr";
    [signature drawInRect:rectSignature withFont:fontSignature lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) refreshQuoteImage
{
    if (self.photoImage == nil ) {
        UIImage *image = [self imageWithColor:self.colorBackground size:self.imageView.bounds.size];
        
        self.imageView.image = [self quoteImageWithQuote:self.textView.text whom:self.textField.text baseImage:image];
        
    } else {
        self.imageView.image = [self quoteImageWithQuote:self.textView.text whom:self.textField.text baseImage:self.photoImage];;
        
    }
}

#pragma mark - Storyboard
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"push_colorpicker"] ) {
        DZUISimpleColorPickerViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    } else if ( [segue.identifier isEqualToString:@"push_font_picker"] ) {
        DZUIFontPickerViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}
#pragma mark - DZUISimpleViewControllerDelegate
- (void) viewControllerDone:(UIViewController *)vc
{
    if ( [vc isKindOfClass:[DZUISimpleColorPickerViewController class]] ) {
        DZUISimpleColorPickerViewController *viewController = (DZUISimpleColorPickerViewController *) vc;
        
        NSLog(@"selectedColor:%@", [viewController.selectedColor description]);
        
        // TODO: replace image with color filled
        if ( self.photoImage ) {
            DZUIAlertUtility *__block utility = [DZUIAlertUtility confirmWithTitle:@"Confirm" message:@"Selecting color will remove photo. Will you continue?" completedBlock:^(BOOL confirmed, DZUIAlertUtility *u) {
                //
                if ( confirmed ) {            
                    self.photoImage = nil;
                    self.colorBackground = viewController.selectedColor;
                    [self refreshQuoteImage];
                    
                }
                utility = nil;
            }];
        } else {
            self.photoImage = nil;
            self.colorBackground = viewController.selectedColor;
            [self refreshQuoteImage];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([vc isKindOfClass:[DZUIFontPickerViewController class]]) {
        DZUIFontPickerViewController *viewController = (DZUIFontPickerViewController *) vc;
        self.fontQuote = viewController.selectedFont;
        self.fontBy = viewController.selectedFont;
        [self refreshQuoteImage];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self refreshQuoteImage];
    return YES;
}


#pragma mark - Actions
- (void) actionStepper:(UIStepper *) sender
{
    self.fontQuote = [self.fontQuote fontWithSize:sender.value];
    self.fontBy = [self.fontBy fontWithSize:sender.value];
    [self refreshQuoteImage];
}

- (void) actionTextViewDone:(id) sender
{
    [self.textView resignFirstResponder];
    [self refreshQuoteImage];
    
}

- (IBAction)actionFont:(id)sender {
    //[//UIFont 
}

- (IBAction)actionPhoto:(id)sender {
    
    DZUIImagePickerUtility *__block utility = [DZUIImagePickerUtility imagePickerUtilityWithImagePickerReadyBlock:^(UIImagePickerController *picker) {
        // Image Picker Controller customization
        picker.allowsEditing = YES;
        
        [self presentModalViewController:picker animated:YES];
    } imagePickedBlock:^(UIImage *image) {
        //
        [self dismissViewControllerAnimated:YES completion:^{
            self.photoImage = image;
            [self refreshQuoteImage];
        }];
    } cancelledBlock:^{
        
        //
        [self dismissModalViewControllerAnimated:YES];
        utility = nil;
        
    }];    
}

- (BOOL) showTweetComposerWithImage:(UIImage *) image withURL:(NSURL *) url initialText:(NSString *) initialText
{
    // 1. Check if we can tweet
    if ( [TWTweetComposeViewController canSendTweet] ) {
        
        // 2. Instantiation
        TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
        
        // 3, 4, 5. Initial Tweet contents
        [viewController setInitialText:initialText];
        if ( image ) {
            [viewController addImage:image];
        }
        if ( url ) {
            [viewController addURL:url];
        }
        
        // 6. Completion Handler block
        TWTweetComposeViewControllerCompletionHandler completionHandler =
        ^(TWTweetComposeViewControllerResult result) {
            // This block of code will be excuted on completion of the tweet request
            // or the user cancelled
            if ( result == TWTweetComposeViewControllerResultDone ) {
                NSLog(@"Tweet was successful.");
            } else if ( result == TWTweetComposeViewControllerResultCancelled ) {
                NSLog(@"Tweet was unsuccessful.");
            }
            [self dismissModalViewControllerAnimated:YES];
        };
        [viewController setCompletionHandler:completionHandler];    
        
        // 7. Presentation
        [self presentModalViewController:viewController animated:YES];
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)actionTweet:(id)sender 
{
    if ( self.imageView.image ) {
        NSString *text = [NSString stringWithFormat:@"%@ -%@", self.textView.text, self.textField.text];
        BOOL result = NO;
        result = [self showTweetComposerWithImage:self.imageView.image withURL:[NSURL URLWithString:@"http://www.iosappdev.co.kr"] initialText:text];
        /*
        NSString *message = @"Tweet successfully posted";
        NSString *title = @"Information";
        if ( !result ) {
                message = @"Tweet was unsuccessful";
            title = @"Error";
        }
        [DZUIAlertUtility alertWithMessage:message title:title];
         */
    }
}
@end
