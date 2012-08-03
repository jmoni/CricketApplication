//
//  ThirdViewController.m
//  CricketApplication
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "ThirdViewController.h"
#import "sqlite3.h"
#include "SecondViewController.h"
#include "FirstViewController.h"

@interface ThirdViewController ()
@property (strong, nonatomic) IBOutlet UIButton *batterName1;
@property (strong, nonatomic) IBOutlet UIButton *batterName2;
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UIImageView *oneActive;
@property (strong, nonatomic) IBOutlet UIImageView *twoActive;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoButtonItem;
@property (strong, nonatomic) IBOutlet UIPickerView *choosePlayer;
@end

UIView *newView;
int height = 255;

UIButton *batterButton;
int batter1;
int batter2;

@implementation ThirdViewController
@synthesize overTotal;
@synthesize fallOfWickets;
@synthesize batterName1;
@synthesize batterName2;
@synthesize teamName;
@synthesize oneActive;
@synthesize twoActive;
@synthesize infoButtonItem = _infoButtonItem;
@synthesize choosePlayer = _choosePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)noRuns:(id)sender{
    overTotal.text = @".";
}
-(IBAction)plusOne:(id)sender{
    overTotal.text = @"1";
}
-(IBAction)four:(id)sender{
    overTotal.text = @"4";
}
-(IBAction)six:(id)sender{
    overTotal.text = @"6";
}
-(IBAction)confirm:(id)sender{
    
}

-(IBAction)showExtrasOptions:(id)sender{
    batterName1.enabled = false;
    batterName2.enabled = false;
    height = 255;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
    
    toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    
    UIButton *nB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nB addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [nB setTitle:@"No Ball" forState:UIControlStateNormal];
    nB.frame = CGRectMake(20.0, 50.0, 65.0, 40.0);
    [newView addSubview:nB];
    
    UIButton *wide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [wide addTarget:self 
           action:nil
 forControlEvents:UIControlEventTouchDown];
    [wide setTitle:@"Wide" forState:UIControlStateNormal];
    wide.frame = CGRectMake(95.0, 50.0, 65.0, 40.0);
    [newView addSubview:wide];
    
    UIButton *bye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bye addTarget:self 
           action:nil
 forControlEvents:UIControlEventTouchDown];
    [bye setTitle:@"Bye" forState:UIControlStateNormal];
    bye.frame = CGRectMake(170.0, 50.0, 65.0, 40.0);
    [newView addSubview:bye];
    
    UIButton *legBye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [legBye addTarget:self 
           action:nil
 forControlEvents:UIControlEventTouchDown];
    [legBye setTitle:@"Leg Bye" forState:UIControlStateNormal];
    legBye.frame = CGRectMake(245.0, 50.0, 65.0, 40.0);
    [newView addSubview:legBye];
    
    UIButton *penaltyRun = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [penaltyRun addTarget:self 
           action:nil
 forControlEvents:UIControlEventTouchDown];
    [penaltyRun setTitle:@"Penalty Run" forState:UIControlStateNormal];
    penaltyRun.frame = CGRectMake(110.0, 100.0, 100.0, 40.0);
    [newView addSubview:penaltyRun];
    
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 150.0, 50.0, 21.0)];
    total.text = @"Total:";
    [newView addSubview:total];
    
    UILabel *totalVal = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 150.0, 150.0, 21.0)];
    totalVal.text = @"----------------";
    [newView addSubview:totalVal];
    
    UIButton *undo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [undo addTarget:self 
                   action:nil
         forControlEvents:UIControlEventTouchDown];
    [undo setTitle:@"Undo" forState:UIControlStateNormal];
    undo.frame = CGRectMake(135.0, 200.0, 50.0, 40.0);
    [newView addSubview:undo];

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

-(IBAction)showOutOptions:(id)sender {
    batterName1.enabled = false;
    batterName2.enabled = false;
    height = 255;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];

     toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    
    UIButton *caught = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [caught addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [caught setTitle:@"Caught" forState:UIControlStateNormal];
    caught.frame = CGRectMake(20.0, 50.0, 65.0, 40.0);
    [newView addSubview:caught];
                        
    UIButton *bowled = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bowled addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [bowled setTitle:@"Bowled" forState:UIControlStateNormal];
    bowled.frame = CGRectMake(95.0, 50.0, 65.0, 40.0);
    [newView addSubview:bowled];
    
    UIButton *lbw = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbw addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [lbw setTitle:@"LBW" forState:UIControlStateNormal];
    lbw.frame = CGRectMake(170.0, 50.0, 45.0, 40.0);
    [newView addSubview:lbw];
    
    UIButton *runOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [runOut addTarget:self 
            action:nil
     forControlEvents:UIControlEventTouchDown];
    [runOut setTitle:@"Run Out" forState:UIControlStateNormal];
    runOut.frame = CGRectMake(225.0, 50.0, 65.0, 40.0);
    [newView addSubview:runOut];
    
    UIButton *stumped = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [runOut addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [stumped setTitle:@"Stumped" forState:UIControlStateNormal];
    stumped.frame = CGRectMake(20.0, 100.0, 65.0, 40.0);
    [newView addSubview:stumped];
    
    UIButton *hitWicket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hitWicket addTarget:self 
               action:nil
     forControlEvents:UIControlEventTouchDown];
    [hitWicket setTitle:@"Hit Wicket" forState:UIControlStateNormal];
    hitWicket.frame = CGRectMake(95.0, 100.0, 75.0, 40.0);
    [newView addSubview:hitWicket];

    UIButton *handledBall = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [handledBall addTarget:self 
                  action:nil
        forControlEvents:UIControlEventTouchDown];
    [handledBall setTitle:@"Handled the Ball" forState:UIControlStateNormal];
    handledBall.frame = CGRectMake(180.0, 100.0, 120.0, 40.0);
    [newView addSubview:handledBall];
    
    UIButton *hitBallTwice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hitBallTwice addTarget:self 
                  action:nil
        forControlEvents:UIControlEventTouchDown];
    [hitBallTwice setTitle:@"Hit the Ball Twice" forState:UIControlStateNormal];
    hitBallTwice.frame = CGRectMake(10.0, 150.0, 130.0, 40.0);
    [newView addSubview:hitBallTwice];
    
    UIButton *obstructingField = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [obstructingField addTarget:self 
                  action:nil
        forControlEvents:UIControlEventTouchDown];
    [obstructingField setTitle:@"Obstructing the Field" forState:UIControlStateNormal];
    obstructingField.frame = CGRectMake(150.0, 150.0, 160.0, 40.0);
    [newView addSubview:obstructingField];
    
    UIButton *timedOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timedOut addTarget:self 
                  action:nil
        forControlEvents:UIControlEventTouchDown];
    [timedOut setTitle:@"Timed Out" forState:UIControlStateNormal];
    timedOut.frame = CGRectMake(120.0, 200.0, 80.0, 40.0);
    [newView addSubview:timedOut];
    
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

-(IBAction)showActionSheet:(id)sender {
    batterName1.enabled = false;
    batterName2.enabled = false;
	batterButton = sender;
	height = 255;
    
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];

    toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    
    //add a picker
    _choosePlayer = [[UIPickerView alloc] initWithFrame: CGRectMake(0,40,320,250)];
    _choosePlayer.hidden = false;
    _choosePlayer.delegate = self;
    _choosePlayer.dataSource = self;
    _choosePlayer.showsSelectionIndicator = YES;
	[self selectRowForSelection:_choosePlayer];

    //add popup view
    [newView addSubview:toolbar];
    [newView addSubview:_choosePlayer];
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

- (void) selectRowForSelection:(UIPickerView *)pickerView {
	if ([batterButton isEqual:batterName1] && batter1 < [pickerView numberOfRowsInComponent:0])
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
	else if ([batterButton isEqual:batterName2] && batter2 < [pickerView numberOfRowsInComponent:0])
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
	if (batter1 >= [homePlayersArray count] && [battingTeam isEqualToString:@"home"]) {
		batter1 = 0;
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
		[batterButton setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
	} else if (batter2 >= [homePlayersArray count] && [battingTeam isEqualToString:@"home"]) {
		batter2 = 1;
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
		[batterButton setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else if (batter1 >= [awayPlayersArray count] && [battingTeam isEqualToString:@"away"]) {
		batter1 = 0;
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
	} else if (batter2 >= [awayPlayersArray count] && [battingTeam isEqualToString:@"away"]) {
		batter2 = 1;
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	}
	//NSLog(@"Batter 1: %d\nBatter 2: %d", batter1, batter2);
	if ([battingTeam isEqualToString:@"home"]) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	}
}

//Used when clicking the done button
- (IBAction)hideActionSheet:(UIBarButtonItem *)_infoButtonItem{
    batterName1.enabled = true;
    batterName2.enabled = true;
	//_choosePlayer.hidden = true;
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

//Used for clicked on the background
-(IBAction)hideActionSheetB:(id)sender{
    batterName1.enabled = true;
    batterName2.enabled = true;
	
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y =height; 
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	height = CGRectGetMaxY(self.view.bounds);
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)_choosePlayer{
    return 1;
}

//number of rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if ([battingTeam isEqualToString:@"home"])
		return [homePlayersArray count];
	else if ([battingTeam isEqualToString:@"away"])
		return [awayPlayersArray count];
	else return 0;
}

//values in picker view
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if ([battingTeam isEqualToString:@"home"])
		return [homePlayersArray objectAtIndex:row];
	else if ([battingTeam isEqualToString:@"away"])
		return [awayPlayersArray objectAtIndex:row];
	else return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([battingTeam isEqualToString:@"home"])
		[batterButton setTitle:[homePlayersArray objectAtIndex:row] forState:UIControlStateNormal];
	else if ([battingTeam isEqualToString:@"away"])
		[batterButton setTitle:[awayPlayersArray objectAtIndex:row] forState:UIControlStateNormal];
	
	//set batter integers
	if ([batterButton isEqual:batterName1])
		batter1 = row;
	else if ([batterButton isEqual:batterName2])
		batter2 = row;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	batter1 = 0;
	batter2 = 1;
	[teamName setText:homeTeam];
	if ([battingTeam isEqualToString:@"home"]) {
		[teamName setText:homeTeam];
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		[teamName setText:awayTeam];
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	if ([battingTeam isEqualToString:@"home"] && [homePlayersArray count] > batter1 && [homePlayersArray count] > batter2) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"] && [awayPlayersArray count] > batter1 && [awayPlayersArray count] > batter2) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else {
		[self selectRowForSelection:_choosePlayer];
	}
	if ([battingTeam isEqualToString:@"home"])
		[teamName setText:homeTeam];
	else if ([battingTeam isEqualToString:@"away"])
		[teamName setText:awayTeam];
}

- (void)viewDidUnload
{
    [self setBatterName1:nil];
    [self setBatterName2:nil];
    [self setTeamName:nil];
    [self setOneActive:nil];
    [self setTwoActive:nil];
    fallOfWickets = nil;
    [self setOverTotal:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
