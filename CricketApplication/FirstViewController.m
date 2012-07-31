//
//  FirstViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize homeTeamEntered = _homeTeamEntered;
@synthesize awayTeamEntered = _awayTeamEntered;
@synthesize dateButton = _dateButton;
@synthesize dateText = _dateText;
@synthesize myPicker = _myPicker;



-(IBAction)showActionSheet:(id)sender{
    UIActionSheet *dateActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Done", nil];
    [dateActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [dateActionSheet showInView:self.view];
    [dateActionSheet setFrame:CGRectMake(0, 200, 320, 383)];

}

#define kPickerTag 200
#define SelectButtonIndex 1
#define CancelButtonIndex 2
-(void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 100, 116)];
    [pickerView setTag:kPickerTag];
    
    [pickerView setDatePickerMode:UIDatePickerModeDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM-dd-yyyy"];
    NSDate *myDate2 = myPicker.date;
    
    self.dateText.text = myDate2.description;
    NSLog(@"text: %@", self.dateText.text);
    [actionSheet addSubview:pickerView];
    
    NSArray *subViews = [actionSheet subviews];
    
    [[subViews objectAtIndex:SelectButtonIndex] setFrame:CGRectMake(0, 5, 75, 46)];
    [[subViews objectAtIndex:CancelButtonIndex] setFrame:CGRectMake(225, 5, 85, 46)];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setHomeTeamEntered:nil];
    [self setAwayTeamEntered:nil];
    [self setDateButton:nil];
    [self setDateText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

