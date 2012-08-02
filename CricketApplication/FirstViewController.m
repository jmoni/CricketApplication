//
//  FirstViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "FirstViewController.h"
#import "sqlite3.h"

@interface FirstViewController ()

@end
NSDate *date;
//int height = 255;
UIView *newView;
@implementation FirstViewController
@synthesize homeTeamEntered = _homeTeamEntered;
@synthesize awayTeamEntered = _awayTeamEntered;
@synthesize dateButton = _dateButton;
@synthesize dateText = _dateText;
@synthesize infoButtonItem = _infoButtonItem;




-(IBAction)showActionSheet:(id)sender {
    _homeTeamEntered.enabled = false;
    _awayTeamEntered.enabled = false;
    
    int height = 255;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;

    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone     target:self action:@selector(hideActionSheet:)];
    toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];

    //add date picker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = date;
    datePicker.frame = CGRectMake(0, 40, 320, 250);
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [newView addSubview:datePicker];

    //add popup view
    [newView addSubview:toolbar];
    [self.view addSubview:newView];

    //animate it onto the screen
    CGRect temp = newView.frame;
    temp.origin.y = CGRectGetMaxY(self.view.bounds);
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y -= height;
    newView.frame = temp;
    [UIView commitAnimations];
}
-(IBAction)hideActionSheet:(UIBarButtonItem *)_infoButtonItem{
    _homeTeamEntered.enabled = true;
    _awayTeamEntered.enabled = true;
	int height = 255;
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y = height;
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	
	//remove view from page altogether
	//[newView removeFromSuperview];
}

-(IBAction)hideActionSheetB:(id)sender{
    _homeTeamEntered.enabled = true;
    _awayTeamEntered.enabled = true;
	int height = 255;
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y =height; 
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	
	//remove view from page altogether
	//[newView removeFromSuperview];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
	[homeTeamEntered resignFirstResponder];
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

-(IBAction) changeDate:(id)sender{
    date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDate = [dateFormat stringFromDate:date];
    
    [_dateButton setTitle:strDate forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    date= [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];

    NSString *strDate = [dateFormat stringFromDate:date];

    [_dateButton setTitle:strDate forState:UIControlStateNormal];
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

