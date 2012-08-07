//
//  FirstViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "FirstViewController.h"
#import "sqlite3.h"
#import "DatabaseController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize homeTeamEntered = _homeTeamEntered;
@synthesize awayTeamEntered = _awayTeamEntered;
@synthesize timeSlide = _timeSlide;
@synthesize dateButton = _dateButton;
@synthesize dateText = _dateText;
@synthesize overSlide = _overSlide;
@synthesize overTimeLabel = _overTimeLabel;
@synthesize switcher = _switcher;
@synthesize timeLabel = _timeLabel;
@synthesize infoButtonItem = _infoButtonItem;
@synthesize scrollView = _scrollView;
@synthesize umpireOneEntered = _umpireOneEntered;
@synthesize umpireTwoEntered = _umpireTwoEntered;

int height;
UIView *newView;
UITextField *activeField;

-(IBAction)showActionSheet:(id)sender {
    _homeTeamEntered.enabled = false;
    _awayTeamEntered.enabled = false;
	height = 255;
	
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
	
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y = height;
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	height = CGRectGetMaxY(self.view.bounds);
}

-(IBAction)textFieldReturn:(id)sender
{
	if([[_homeTeamEntered text] length] > 0)
		homeTeam = [_homeTeamEntered text];
	else
		homeTeam = @"Team 1";
	if([[_awayTeamEntered text] length] > 0)
		awayTeam = [_awayTeamEntered text];
	else
		awayTeam = @"Team 2";
    if([[_umpireOneEntered text] length] > 0)
		umpireOne = [_umpireOneEntered text];
	else
		umpireOne = @"Umpire 1";
    if([[_umpireTwoEntered text] length] > 0)
		umpireTwo = [_umpireTwoEntered text];
	else
		umpireTwo = @"Umpire 2";
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

-(IBAction) changeDate:(id)sender{
    date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    strDate = [dateFormat stringFromDate:date];
    
    [_dateButton setTitle:strDate forState:UIControlStateNormal];
}

-(IBAction)sliderUpdate:(id)sender{
    _overTimeLabel.text = [NSString stringWithFormat:@"%d",(int)_overSlide.value];
    numberOversOrDays = (int)_overSlide.value;
}

- (IBAction)flipSwitch: (id)sender{
    if ([_switcher selectedSegmentIndex] == 1) {
		matchType = @"timed";
        _overSlide.hidden = TRUE;
        _timeSlide.hidden = FALSE;
        _overTimeLabel.hidden = TRUE;
        _timeLabel.hidden = FALSE;
        numberOversOrDays = (int)_timeSlide.value;
    }
    else {
		matchType = @"overs";
        _overSlide.hidden = FALSE;
        _timeSlide.hidden = TRUE;
        _overTimeLabel.hidden = FALSE;
        _timeLabel.hidden = TRUE;
        numberOversOrDays = (int)_overSlide.value;
    }
}

-(IBAction)timeSliderUpdate:(id)sender{
    NSString *labelNum = [NSString stringWithFormat:@"%d",(int)_timeSlide.value];
    NSString *temp;
    if ((int)[_timeSlide value] == 1){
        temp = [labelNum stringByAppendingFormat:@" Day"];
        _timeLabel.text = temp;
    }
    else {
         temp = [labelNum stringByAppendingFormat:@" Days"];
        _timeLabel.text = temp;
    }
    numberOversOrDays = (int)_timeSlide.value;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
	[self registerForKeyboardNotifications];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
	[self registerForKeyboardNotifications];
    activeField = nil;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
	
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-160);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    date= [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
	
    strDate = [dateFormat stringFromDate:date];
	
    [_dateButton setTitle:strDate forState:UIControlStateNormal];
	homeTeam = @"Team 1";
	awayTeam = @"Team 2";
    umpireOne = @"Umpire 1";
	umpireTwo = @"Umpire 2";
    numberOversOrDays = 20;
	matchType = @"overs";
}

- (void)viewDidUnload
{
    [self setHomeTeamEntered:nil];
    [self setAwayTeamEntered:nil];
    [self setDateButton:nil];
    [self setDateText:nil];
    [self setOverTimeLabel:nil];
    [self setOverSlide:nil];
    [self setSwitcher:nil];
    [self setTimeSlide:nil];
    [self setTimeLabel:nil];
	[self setScrollView:nil];
	[self setHomeTeamEntered:nil];
    [self setUmpireOneEntered:nil];
    [self setUmpireTwoEntered:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated {
	if(disableElements){
		[_homeTeamEntered setEnabled:NO];
		[_awayTeamEntered setEnabled:NO];
		[_dateButton setEnabled:NO];
		[_umpireOneEntered setEnabled:NO];
		[_umpireTwoEntered setEnabled:NO];
		[_switcher setEnabled:NO];
		[_overSlide setEnabled:NO];
		[_timeSlide setEnabled:NO];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

