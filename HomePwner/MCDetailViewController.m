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

@interface MCDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
        UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation MCDetailViewController

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    MCItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
}

// set item to appear on nav bar 
- (void)setItem:(MCItem *)item {
    
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)takePicture:(id)sender {

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
    [self presentViewController:imagePicker animated:YES completion:NULL];

}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // store the image in the MCImageStore for this key
    [[MCImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // put that image onto the screen in our image view
    self.imageView.image = image;
    
    // take image picker off the screen
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
















