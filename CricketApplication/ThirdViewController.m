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

@implementation ThirdViewController
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
-(IBAction)showOutOptions:(id)sender {
    batterName1.enabled = false;
    batterName2.enabled = false;
    
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
    timedOut.frame = CGRectMake(20.0, 200.0, 75.0, 40.0);
    [newView addSubview:timedOut];
    
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

-(IBAction)showActionSheet:(id)sender {
    batterName1.enabled = false;
    batterName2.enabled = false;
	batterButton = sender;
    
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

-(IBAction)hideActionSheet:(UIBarButtonItem *)_infoButtonItem{
    batterName1.enabled = true;
    batterName2.enabled = true;
	
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
	
	//remove view from page altogether
	//[newView removeFromSuperview];
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

//values in picker view (filled with homeTeam array for now)
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	if ([battingTeam isEqualToString:@"home"]) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:0] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:1] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:0] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:1] forState:UIControlStateNormal];
	}
}

/*- (void)viewDidAppear:(BOOL)animated
{
	if ([battingTeam isEqualToString:@"home"]) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:0] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:1] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:0] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:1] forState:UIControlStateNormal];
	}
}*/

- (void)viewDidUnload
{
    [self setBatterName1:nil];
    [self setBatterName2:nil];
    [self setTeamName:nil];
    [self setOneActive:nil];
    [self setTwoActive:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
