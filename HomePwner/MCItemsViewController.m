//
//  MCItemsViewController.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItemsViewController.h"
#import "MCItemStore.h"
#import "MCItem.h"
#import "MCDetailViewController.h"
#import "MCItemCell.h"
#import "MCImageStore.h"
#import "MCImageViewController.h"

@interface MCItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (strong, nonatomic) UIPopoverController *imagePopover; 

@end


@implementation MCItemsViewController

#pragma mark -Setup

- (instancetype)init {
    
    // call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // create a new bar button item that will send
        // addNewItem: to MCItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self
                                    action:@selector(addNewItem:)];
        
        // set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        // set this button item as the left item in the navigationItem
        // for edititing the list 
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(updateTableViewForDynamicTypeSize)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
        
        // Register for locale change notifications
        [nc addObserver:self
               selector:@selector(localeChanged:)
                   name:NSCurrentLocaleDidChangeNotification
                 object:nil];
    }
    
    return self;
    
}

- (void)localeChanged:(NSNotification *)note {
    [self.tableView reloadData];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

+ (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
        numberOfRowsInSection:(NSInteger)section {
    
    return [[[MCItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // create an instance of UITableViewCell, with default appearance
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:@"UITableViewCell"];
    
    // get a new or recycled cell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
//                                                        forIndexPath:indexPath];
    MCItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCItemCell"
                                                       forIndexPath:indexPath];
    
    // set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tablview
    NSArray *items = [[MCItemStore sharedStore] allItems];
    MCItem *item = items[indexPath.row];
    
//    cell.textLabel.text = [item description];
    
    // Configure the cell with the MCItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    // Create a number formatter for currency
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
//    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    
    cell.thumbnailView.image = item.thumbnail;
    
    // weak reference to cell
    __weak MCItemCell *weakCell = cell;
    
    // block for showing image when thumbnail is tapped
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        MCItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            NSString *itemKey = item.itemKey;
            
            // If there is no image, we don't need to display anything
            UIImage *img = [[MCImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            // Make a rectangle for the frame of the thumbnail relative
            // to our table view
//            CGRect rect = [self.view convertRect:cell.thumbnailView.bounds
//                                        fromView:cell.thumbnailView];
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                        fromView:strongCell.thumbnailView];
            
            // Create a new MCImageViewController and set its image
            MCImageViewController *ivc = [[MCImageViewController alloc] init];
            ivc.image = img;
            
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.imagePopover = nil; 
}

#pragma mark -ViewLoads
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"MCItemCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MCItemCell"];
    
    self.tableView.restorationIdentifier = @"MCItemsViewControllerTableView";
}

# pragma mark -ViewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // reload did will view appears again
    [self.tableView reloadData];
    
    [self updateTableViewForDynamicTypeSize];
}

#pragma mark -Buttons

- (IBAction)addNewItem:(id)sender {
    
    /* CAN'T DO THIS - NOT TELLING STORE THERE IS A NEW ITEM AND CAUSES CRASH*/
    // make a new index path for the 0th section, last row
    //    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    
    
    // create new MCItem and add it to the store
    MCItem *newItem = [[MCItemStore sharedStore] createItem];
    
    // figure out where that item is in the array
//    NSInteger lastRow = [[[MCItemStore sharedStore] allItems] indexOfObject:newItem];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // insert this new row into the table
//    [self.tableView insertRowsAtIndexPaths:@[indexPath]
//                          withRowAnimation:UITableViewRowAnimationTop];
   
    MCDetailViewController *detailViewController = [[MCDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    // block for reloading data on table view 
    detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:NULL];
    
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *items = [[MCItemStore sharedStore] allItems];
        MCItem *item = items[indexPath.row];
        [[MCItemStore sharedStore] removeItem:item];
     
        // also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [[MCItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

# pragma mark -NavController

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //MCDetailViewController *detailViewController = [[MCDetailViewController alloc] init];
    MCDetailViewController *detailViewController = [[MCDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[MCItemStore sharedStore] allItems];
    MCItem *selectedItem = items[indexPath.row];
    
    // give detail view controller a pointer to the itme object in row
    detailViewController.item = selectedItem;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark -Restoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                            coder:(NSCoder *)coder {
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    
    self.editing = [coder decodeObjectForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)path
                                            inView:(UIView *)view {
    
    NSString *identifier = nil;
    
    if (path && view) {
        // Return an identifier of the given NSIndexPath
        // in case next time the data source changes
        MCItem *item = [[MCItemStore sharedStore] allItems][path.row];
        identifier = item.itemKey;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *items = [[MCItemStore sharedStore] allItems];
        for (MCItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                NSInteger row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}

@end












