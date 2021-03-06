//
//  MCDetailViewController.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/20/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCDetailViewController.h"
#import "MCItem.h"
#import "MCImageStore.h"
#import "MCItemStore.h"
#import "MCAssetTypeViewController.h"
#import "AppDelegate.h"

@interface MCDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
        UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end

@implementation MCDetailViewController

#pragma mark -Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    // the contentMode of the image view in the XIB was Asepect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // the image view was a subview of the view
    [self.view addSubview:iv];
    
    // the image view was pointed to byu the imageView property
    self.imageView = iv;
    
    // set the vertical priorities to be less than
    // those of the other subviews
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700
                                                    forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolBar"   : self.toolbar};
    
    // imageView is 0pts from superview at left and right edges
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                options:0 metrics:nil
                                                  views:nameMap];
    
    // imageView is 8 pts from dateLabel at its top edge...
    // ... and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolBar]"
                                                options:0 metrics:nil
                                                  views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    MCItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    
    // need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // use filterd NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    // get the image for its image key from the image store
    UIImage *imagetoDisplay = [[MCImageStore sharedStore] imageForKey:itemKey];
    
    // use that image to put on the screen in the imageView
    self.imageView.image = imagetoDisplay;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io =
    [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
//        typeLabel = @"None";
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    
//    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    self.assetTypeButton.title =
        [NSString stringWithFormat:NSLocalizedString(@"Type:", @"Asset type button"), typeLabel];
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    MCItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    
    int newValue = [self.valueField.text intValue];
    
    // Is it changed?
    if (newValue != item.valueInDollars) {
        
        // Put it in the item
        item.valueInDollars = newValue;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue
                      forKey:MCNextItemNamePrefsKey];
    }
    
//    item.valueInDollars = [self.valueField.text intValue];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    
    [NSException raise:@"Wrong initializer" format:@"Use initForNewItem:"];
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (void)updateFonts {
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

#pragma mark -Actions
- (IBAction)takePicture:(id)sender {
    
    if ([self.imagePickerPopover isPopoverVisible]) {
        // if the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // if the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    imagePicker.delegate = self;
    
    // place image picker on the screen
//    [self presentViewController:imagePicker animated:YES completion:NULL];
    
    // check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        // Display the popover controller; sender
        // is the camera bar button item
        [self.imagePickerPopover
                    presentPopoverFromBarButtonItem:sender
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
        
    } else {
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    // store the image in the MCImageStore for this key
    [[MCImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // put that image onto the screen in our image view
    self.imageView.image = image;
    
    // take image picker off the screen
    // you must call this dismiss method
//    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // Do I have a popover?
    if (self.imagePickerPopover) {
        
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (IBAction)showAssetTypePicker:(id)sender {
    
    [self.view endEditing:YES];
    
    MCAssetTypeViewController *avc = [[MCAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
    
}

// set item to appear on nav bar
- (void)setItem:(MCItem *)item {
    
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    
    // Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (instancetype)initForNewItem:(BOOL)isNew {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                              target:self
                                                              action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        // Make sure this is NOT in the if (isNew ) { } block of code
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
        
    }
    return self;
}

#pragma mark -Buttons

- (void)save:(id)sender {
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
    
    // if the user cancelled, the remove the MCItem from the store
    [[MCItemStore sharedStore] removeItem:self.item];
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark -Restoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder {
 
    BOOL isNew = NO;
    if ([path count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // Save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    // Have store save changes to disk
    [[MCItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (MCItem *item in [[MCItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}

@end
















