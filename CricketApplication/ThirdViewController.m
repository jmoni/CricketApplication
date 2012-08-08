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
#include "DatabaseController.h"

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
int value = -1;
int ballNo = 1;
UIButton *batterButton;
int batter1;
int batter2;
int bowler;
BOOL even;
int batter1Balls = 0;
int batter2Balls = 0;
int batter1Runs = 0;
int batter2Runs = 0;
float runs = 0;
int wickets = 0;
float economy = 0.00;
int noBalls = 0;
int wides = 0;
int byes = 0;
int legByes = 0;
int penalties = 0;
int total = 0;
int fieldingTeamSize;
float fieldStats[5][20];
int lastBowler;

@implementation ThirdViewController
@synthesize ball6;
@synthesize ball5;
@synthesize ball4;
@synthesize ball3;
@synthesize ball2;
@synthesize ball1;
@synthesize batter1Active;
@synthesize batter2Active;
@synthesize batter1BallsLabel;
@synthesize batter2BallsLabel;
@synthesize batter1RunsLabel;
@synthesize batter2RunsLabel;
@synthesize bowlerButton;
@synthesize oversLabel;
@synthesize maidensLabel;
@synthesize runsLabel;
@synthesize wicketsLabel;
@synthesize economyLabel;
@synthesize noBallLabel;
@synthesize wideLabel;
@synthesize byeLabel;
@synthesize legByeLabel;
@synthesize penLabel;
@synthesize totLabel;
@synthesize calculatorView;
@synthesize ballLabels;
@synthesize startGameButton;
@synthesize scoreLabel;
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

- (void)startGame:(id)sender {
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Are you ready to start game?"
				message:[NSString stringWithFormat:@"Ensure all game details are correct as you will not be able to edit these once the game starts."] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[mes show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self resignFirstResponder];
	}
	else
	{
		[self resignFirstResponder];
		[startGameButton setHidden:YES];
		for(int i = 0; i < [calculatorView count]; i++){
			[[calculatorView objectAtIndex:i] setHidden:NO];
		}
		for(int i = 0; i < [ballLabels count]; i++){
			[[ballLabels objectAtIndex:i] setHidden:NO];
		}
		DatabaseController *instance = [[DatabaseController alloc] init];
		[instance firstTabSave];
		[instance secondTabSave];
		[instance thirdTabSave];
		[batterName1 setEnabled:NO];
		[batterName2 setEnabled:NO];
		//[bowlerButton setEnabled:NO];
	}
}

-(IBAction)noRuns:(id)sender{
	value = 0;
    [self resetBallValueToString:@"•"];
	even = YES;
	fieldStats[2][bowler] ++;
	//maidens++;
}
-(IBAction)plusOne:(id)sender{
    if (value == -1)
		value += 2;
	else
		value ++;
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
	if (value%2 == 1)
		even = NO;
	else
		even = YES;
}
-(IBAction)four:(id)sender{
    value = 4;
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
	even = YES;
}
-(IBAction)six:(id)sender{
    value = 6;
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
	even = YES;
}
-(IBAction)confirm:(id)sender{
	if (value > -1) {
		if ([batter1Active isHidden]) {
			batter2Runs += value;
			batter2Balls++;
		} else {
			batter1Runs += value;
			batter1Balls++;
		}
		
		//overs += 0.1;
		fieldStats[1][bowler] += 0.1;
		runs += value;
		fieldStats[3][bowler] += value;
		fieldStats[0][bowler] = 2;
		value = -1;

		if (ballNo<6)
			ballNo ++;
		else{
			ballNo = 1;
			ball1.text = @"-";
			ball1.text = @"-";
			ball2.text = @"-";
			ball3.text = @"-";
			ball4.text = @"-";
			ball5.text = @"-";
			ball6.text = @"-";
			fieldStats[2][bowler] -= (int)(fieldStats[2][bowler])%6;
			//maidens -= maidens%6;
			for (int i = 0; i < fieldingTeamSize; i++){
				if(fieldStats[0][i] != 0)
					fieldStats[0][i]--;
			}
			[self changeBatterFacingBowler];
			[self changeBowler];
		}
		if ((fieldStats[1][bowler]-(int)(fieldStats[1][bowler]))*10 == 6) {
			fieldStats[1][bowler] -= 0.6;
			fieldStats[1][bowler]++;
		}
		
		scoreString = [NSString stringWithFormat:@"%.0f/%d	%.0f Overs", runs, wickets, fieldStats[1][bowler]];
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%d", batter1Runs]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%d", batter2Runs]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%d", batter1Balls]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%d", batter2Balls]];
		[oversLabel setText:[NSString stringWithFormat:@"%.1f", fieldStats[1][bowler]]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[3][bowler]]];
		[maidensLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[2][bowler]/6]];
		if(fieldStats[1][bowler] > 0)
			economy = fieldStats[3][bowler]/fieldStats[1][bowler];
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];

		[self changeBatterFacingBowler];
	}
}

- (IBAction)undo:(id)sender {
	if (fieldStats[1][bowler] >= 0 && ballNo > 1) {
		if (value > -1) {
			
		} else {
			if (ballNo == 1)
				fieldStats[1][bowler]--;
			ballNo--;
			value = [self getBallValue];
			if (value%2 == 0) even = YES; else even = NO;
			[self changeBatterFacingBowler];
			if ([batter1Active isHidden]) {
				batter2Runs -= value;
				batter2Balls--;
			} else {
				batter1Runs -= value;
				batter1Balls--;
			}
			runs -= value;
			if (fieldStats[1][bowler]-(int)(fieldStats[1][bowler]) == 0)
				fieldStats[1][bowler] -= 0.5;
			else 
				fieldStats[1][bowler] -= 0.1;
			fieldStats[3][bowler] -= value;
		}
		[self resetBallValueToString:@"-"];
		value = -1;
		
		scoreString = [NSString stringWithFormat:@"%.0f/%d	%.0f Overs", runs, wickets, fieldStats[1][bowler]];
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%d", batter1Runs]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%d", batter2Runs]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%d", batter1Balls]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%d", batter2Balls]];
		[oversLabel setText:[NSString stringWithFormat:@"%.1f", fieldStats[1][bowler]]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[3][bowler]]];
		//[maidensLabel setText:[NSString stringWithFormat:@"%d", maidens/6]];
		if(fieldStats[1][bowler] > 0)
			economy = fieldStats[3][bowler]/fieldStats[1][bowler];
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
	} else {
		[ball1 setText:@"-"];
		value = -1;
	}
}

- (void)resetBallValueToString:(NSString *)string {
	if (ballNo == 1)
		ball1.text = string;
	else if (ballNo == 2)
		ball2.text = string;
	else if (ballNo == 3)
		ball3.text = string;
	else if (ballNo == 4)
		ball4.text = string;
	else if (ballNo == 5)
		ball5.text = string;
	else if (ballNo == 6)
		ball6.text = string;
}

- (int)getBallValue {
	int ballValue = -1;
	if (ballNo == 1)
		ballValue = [[ball1 text] intValue];
	else if (ballNo == 2)
		ballValue = [[ball2 text] intValue];
	else if (ballNo == 3)
		ballValue = [[ball3 text] intValue];
	else if (ballNo == 4)
		ballValue = [[ball4 text] intValue];
	else if (ballNo == 5)
		ballValue = [[ball5 text] intValue];
	else if (ballNo == 6)
		ballValue = [[ball6 text] intValue];
	return ballValue;
}

- (void)changeBatterFacingBowler {
	if (!even){
		if ([batter1Active isHidden]){
			[batter1Active setHidden:NO];
			[batter2Active setHidden:YES];
		} else if ([batter2Active isHidden]){
			[batter1Active setHidden:YES];
			[batter2Active setHidden:NO];
		}
	}
}

- (void)changeBowler {
	int temp;
	temp = bowler;
	bowler = lastBowler;
	lastBowler = temp;
	[self showActionSheet:bowlerButton];
	
}

-(IBAction)showExtrasOptions:(id)sender{
    [self hideActionSheetB:sender];
    batterName1.enabled = false;
    batterName2.enabled = false;
    height = 200;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];

	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
        
    UIButton *nB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nB addTarget:self
		   action:@selector(extraNoBall:)
			forControlEvents:UIControlEventTouchDown];
    [nB setTitle:@"No Ball" forState:UIControlStateNormal];
    nB.frame = CGRectMake(20.0, 50.0, 65.0, 40.0);
    [newView addSubview:nB];
    
    UIButton *wide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [wide addTarget:self
             action:@selector(extraWide:)
			forControlEvents:UIControlEventTouchDown];
    [wide setTitle:@"Wide" forState:UIControlStateNormal];
    wide.frame = CGRectMake(95.0, 50.0, 65.0, 40.0);
    [newView addSubview:wide];
    
    UIButton *bye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bye addTarget:self
			action:@selector(extraBye:)
			forControlEvents:UIControlEventTouchDown];
    [bye setTitle:@"Bye" forState:UIControlStateNormal];
    bye.frame = CGRectMake(170.0, 50.0, 65.0, 40.0);
    [newView addSubview:bye];
    
    UIButton *legBye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [legBye addTarget:self
			   action:@selector(extraLegBye:)
				forControlEvents:UIControlEventTouchDown];
    [legBye setTitle:@"Leg Bye" forState:UIControlStateNormal];
    legBye.frame = CGRectMake(245.0, 50.0, 65.0, 40.0);
    [newView addSubview:legBye];
    
    UIButton *penaltyRun = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [penaltyRun addTarget:self
				action:@selector(extraPen:)
				forControlEvents:UIControlEventTouchDown];
    [penaltyRun setTitle:@"Penalty Run" forState:UIControlStateNormal];
    penaltyRun.frame = CGRectMake(110.0, 100.0, 100.0, 40.0);
    [newView addSubview:penaltyRun];
    
    /*UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 150.0, 50.0, 21.0)];
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
    undo.frame = CGRectMake(135.0, 180.0, 50.0, 40.0);
    [newView addSubview:undo];*/
	
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
    //batterName1.enabled = false;
    //batterName2.enabled = false;
    height = 255;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector (hideActionSheet:)];
    
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    
    
    
    UIButton *caught = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [caught addTarget:self
			action:@selector(caught:)
			forControlEvents:UIControlEventTouchDown];
    [caught setTitle:@"Caught" forState:UIControlStateNormal];
    caught.frame = CGRectMake(20.0, 50.0, 65.0, 40.0);
    [newView addSubview:caught];
	
    UIButton *bowled = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bowled addTarget:self
			action:@selector(bowled:)
			forControlEvents:UIControlEventTouchDown];
    [bowled setTitle:@"Bowled" forState:UIControlStateNormal];
    bowled.frame = CGRectMake(95.0, 50.0, 65.0, 40.0);
    [newView addSubview:bowled];
    
    UIButton *lbw = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbw addTarget:self
			action:@selector(lbw:)
			forControlEvents:UIControlEventTouchDown];
    [lbw setTitle:@"LBW" forState:UIControlStateNormal];
    lbw.frame = CGRectMake(170.0, 50.0, 45.0, 40.0);
    [newView addSubview:lbw];
    
    UIButton *runOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [runOut addTarget:self
			action:@selector(runOut:)
			forControlEvents:UIControlEventTouchDown];
    [runOut setTitle:@"Run Out" forState:UIControlStateNormal];
    runOut.frame = CGRectMake(225.0, 50.0, 65.0, 40.0);
    [newView addSubview:runOut];
    
    UIButton *stumped = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [runOut addTarget:self
			action:@selector(stumped:)
			forControlEvents:UIControlEventTouchDown];
    [stumped setTitle:@"Stumped" forState:UIControlStateNormal];
    stumped.frame = CGRectMake(20.0, 100.0, 65.0, 40.0);
    [newView addSubview:stumped];
    
    UIButton *hitWicket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hitWicket addTarget:self
			action:@selector(hitWicket:)
			forControlEvents:UIControlEventTouchDown];
    [hitWicket setTitle:@"Hit Wicket" forState:UIControlStateNormal];
    hitWicket.frame = CGRectMake(95.0, 100.0, 75.0, 40.0);
    [newView addSubview:hitWicket];
	
    UIButton *handledBall = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [handledBall addTarget:self
			action:@selector(handledBall:)
			forControlEvents:UIControlEventTouchDown];
    [handledBall setTitle:@"Handled the Ball" forState:UIControlStateNormal];
    handledBall.frame = CGRectMake(180.0, 100.0, 120.0, 40.0);
    [newView addSubview:handledBall];
    
    UIButton *hitBallTwice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hitBallTwice addTarget:self
			action:@selector(hitBallTwice:)
			forControlEvents:UIControlEventTouchDown];
    [hitBallTwice setTitle:@"Hit the Ball Twice" forState:UIControlStateNormal];
    hitBallTwice.frame = CGRectMake(10.0, 150.0, 130.0, 40.0);
    [newView addSubview:hitBallTwice];
    
    UIButton *obstructingField = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [obstructingField addTarget:self
			action:@selector(obstructingField:)
			forControlEvents:UIControlEventTouchDown];
    [obstructingField setTitle:@"Obstructing the Field" forState:UIControlStateNormal];
    obstructingField.frame = CGRectMake(150.0, 150.0, 160.0, 40.0);
    [newView addSubview:obstructingField];
    
    UIButton *timedOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timedOut addTarget:self
			action:@selector(timedOut:)
			forControlEvents:UIControlEventTouchDown];
    [timedOut setTitle:@"Timed Out" forState:UIControlStateNormal];
    timedOut.frame = CGRectMake(70.0, 200.0, 80.0, 40.0);
    [newView addSubview:timedOut];
    
    UIButton *retired = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retired addTarget:self
			action:@selector(retired:)
			forControlEvents:UIControlEventTouchDown];
    [retired setTitle:@"Retired" forState:UIControlStateNormal];
    retired.frame = CGRectMake(170.0, 200.0, 80.0, 40.0);
    [newView addSubview:retired];
    
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

-(IBAction)extraNoBall:(id)sender{
    noBalls++;
[noBallLabel setText:[NSString stringWithFormat:@"%d", noBalls]];
    [totLabel setText:[NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes + penalties)]];
    [self hideActionSheetB:sender];
    
}
-(IBAction)extraWide:(id)sender{
    wides++;
    [wideLabel setText:[NSString stringWithFormat:@"%d", wides]];
    [totLabel setText:[NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes + penalties)]];
    [self hideActionSheetB:sender];
}
-(IBAction)extraBye:(id)sender{
    [self hideActionSheetB:sender];
    [self byeCalc:sender string:@"Bye"];
}

-(IBAction)extraLegBye:(id)sender{
    [self hideActionSheetB:sender];
    [self byeCalc:sender string:@"Leg Bye"];
}
-(IBAction)extraPen:(id)sender{
    [self hideActionSheetB:sender];
    [self byeCalc:sender string:@"Pen"];
}

-(IBAction)byeCalc:(id)sender string:(NSString *)identifier{
    height = 200;
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector (showExtrasOptions:)];
    
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    //add popup view
    [newView addSubview:toolbar];
    [self.view addSubview:newView];
    NSString *title = [@"+1 " stringByAppendingString: identifier];
    UIButton *plusOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusOne addTarget:self
                action:@selector(byePlusOne:)
      forControlEvents:UIControlEventTouchDown];
    [plusOne setTitle:title forState:UIControlStateNormal];
    plusOne.frame = CGRectMake(30.0, 50.0, 80.0, 40.0);
    [newView addSubview:plusOne];
    
    title = [@"4 " stringByAppendingString: identifier];
    UIButton *four = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [four addTarget:self
                action:@selector(fourBye:)
      forControlEvents:UIControlEventTouchDown];
    [four setTitle:title forState:UIControlStateNormal];
    four.frame = CGRectMake(120.0, 50.0, 80.0, 40.0);
    [newView addSubview:four];
    
    
    title = [@"6 " stringByAppendingString: identifier];
    UIButton *six = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [six addTarget:self
            action:@selector(sixBye:)
      forControlEvents:UIControlEventTouchDown];
    [six setTitle:title forState:UIControlStateNormal];
    six.frame = CGRectMake(210.0, 50.0, 80.0, 40.0);
    [newView addSubview:six];
    if ([identifier isEqualToString:@"Bye"])
    {
        [plusOne setTag:1];
        [four setTag:1];
        [six setTag:1];
    }
    else if ([identifier isEqualToString:@"Leg Bye"])
    {
        
        [plusOne setTag:2];
        [four setTag:2];
        [six setTag:2];
    }
    else if ([identifier isEqualToString:@"Pen"])
    {
        [plusOne setTag:3];
        [four setTag:3];
        [six setTag:3];
    }
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back addTarget:self
            action:@selector(showExtrasOptions:)
  forControlEvents:UIControlEventTouchDown];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    back.frame = CGRectMake(85.0, 100.0, 70.0, 40.0);
    [newView addSubview:back];

    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirm addTarget:self
                action:nil
  forControlEvents:UIControlEventTouchDown];
    [confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    confirm.frame = CGRectMake(165.0, 100.0, 70.0, 40.0);
    [newView addSubview:confirm];

    //animate it onto the screen
    CGRect temp = newView.frame;
    temp.origin.y = CGRectGetMaxY(self.view.bounds);
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y -= height;
    newView.frame = temp;
    [UIView commitAnimations];
    
}

-(IBAction)byePlusOne:(id)sender{
    if ([sender tag] == 1)
    {
    byes++;
    [byeLabel setText:[NSString stringWithFormat:@"%d", byes]];
    }
    else if ([sender tag] ==2){
    legByes++;
    [legByeLabel setText:[NSString stringWithFormat:@"%d", legByes]];
    }
    else if ([sender tag] ==3){
        penalties++;
        [penLabel setText:[NSString stringWithFormat:@"%d", penalties]];
    }
    [totLabel setText:[NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes + penalties)]];
}
-(IBAction)fourBye:(id)sender{
    if ([sender tag] == 1)
    {
        byes+=4;
        [byeLabel setText:[NSString stringWithFormat:@"%d", byes]];
    }
    else if ([sender tag] ==2){
        legByes+=4;
        [legByeLabel setText:[NSString stringWithFormat:@"%d", legByes]];
    }
    else if ([sender tag] ==3){
        penalties+=4;
        [penLabel setText:[NSString stringWithFormat:@"%d", penalties]];
    }
    [totLabel setText:[NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes + penalties)]];
}

-(IBAction)caught:(id)sender{
	[self hideActionSheetB:sender];
	[self showSecondaryOutOptions:sender label:@"Caught By:"];
}

-(IBAction)bowled:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)lbw:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)runOut:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)stumped:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)hitWicket:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)handledBall:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)hitBallTwice:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)obstructingField:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)timedOut:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)retired:(id)sender{
	[self hideActionSheetB:sender];
}

-(IBAction)showSecondaryOutOptions:(id)sender label:(NSString *)string {
    height = 255;
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
    
    
    //UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action: nil];
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, nil];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake
					   (20.0, 50.0, 100, 21)];
	[label1 setText:string];
	[newView addSubview:label1];
	
	UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 addTarget:self
			   action:@selector(showActionSheet:)
				forControlEvents:UIControlEventTouchDown];
    //[button1 setTitle:@"Caught" forState:UIControlStateNormal];
    button1.frame = CGRectMake(120.0, 50.0, 130.0, 22.0);
    [newView addSubview:button1];
	
    /*UIButton *caught = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [caught addTarget:self
			   action:@selector(caught:)
	 forControlEvents:UIControlEventTouchDown];
    [caught setTitle:@"Caught" forState:UIControlStateNormal];
    caught.frame = CGRectMake(20.0, 50.0, 65.0, 40.0);
    [newView addSubview:caught];*/
    
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
	else if ([batterButton isEqual:bowlerButton] && bowler < [pickerView numberOfRowsInComponent:0]){
		[pickerView selectRow:bowler inComponent:0 animated:YES];
	}
	if (batter1 >= [homePlayersArray count] && [battingTeam isEqualToString:@"home"]) {
		batter1 = 0;
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
		[batterButton setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
	} else if (batter1 >= [awayPlayersArray count] && [battingTeam isEqualToString:@"away"]) {
		batter1 = 0;
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
	}

	if (batter2 >= [homePlayersArray count] && [battingTeam isEqualToString:@"home"]) {
		batter2 = 1;
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
		[batterButton setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	} else if (batter2 >= [awayPlayersArray count] && [battingTeam isEqualToString:@"away"]) {
		batter2 = 1;
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
	}
	
	if (bowler >= [homePlayersArray count] && [battingTeam isEqualToString:@"away"]) {
		bowler = 0;
		[pickerView selectRow:bowler inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	} else if (bowler >= [awayPlayersArray count] && [battingTeam isEqualToString:@"home"]) {
		bowler = 0;
		[pickerView selectRow:bowler inComponent:0 animated:YES];
		[batterButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	}
	
	//NSLog(@"Batter 1: %d\nBatter 2: %d", batter1, batter2);
	if ([battingTeam isEqualToString:@"home"]) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[homePlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	}
}

//Used when clicking the done button
- (IBAction)hideActionSheet:(UIBarButtonItem *)_infoButtonItem{
	if (![startGameButton isHidden]) {
		batterName1.enabled = true;
		batterName2.enabled = true;
	}
    //[obstructingField setTitle:@"Obstructing the Field" forState:UIControlStateNormal];
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
	if (![startGameButton isHidden]) {
		batterName1.enabled = true;
		batterName2.enabled = true;
	}
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
	if ([battingTeam isEqualToString:@"home"]) {
		if ([batterButton isEqual:bowlerButton])
			return [awayPlayersArray count];
		return [homePlayersArray count];
	} else if ([battingTeam isEqualToString:@"away"]) {
		if ([batterButton isEqual:bowlerButton])
			return [homePlayersArray count];
		return [awayPlayersArray count];
	} else return 0;
}

//values in picker view
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if ([battingTeam isEqualToString:@"home"]) {
		if ([batterButton isEqual:bowlerButton])
			return [awayPlayersArray objectAtIndex:row];
		return [homePlayersArray objectAtIndex:row];
	} else if ([battingTeam isEqualToString:@"away"]) {
		if ([batterButton isEqual:bowlerButton])
			return [homePlayersArray objectAtIndex:row];
		return [awayPlayersArray objectAtIndex:row];
	} else return NULL;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([batterButton isEqual:batterName2] && batter1 == row && row < [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row+1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row+1 inComponent:0];
		return;
	} else if ([batterButton isEqual:batterName2] && batter1 == row && row == [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row-1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row-1 inComponent:0];
		return;
	} else if ([batterButton isEqual:batterName1] && batter2 == row && row < [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row+1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row+1 inComponent:0];
		return;
	} else if ([batterButton isEqual:batterName1] && batter2 == row && row == [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row-1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row-1 inComponent:0];
		return;
	} else if ([batterButton isEqual:bowlerButton] && fieldStats[0][row] > 0 && row < [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row+1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row+1 inComponent:0];
		return;
	} else if ([batterButton isEqual:bowlerButton] && fieldStats[0][row] > 0 && row == [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row-1 inComponent:0 animated:YES];
		[UIView commitAnimations];
		[self pickerView:pickerView didSelectRow:row-1 inComponent:0];
		return;
	}
	if ([battingTeam isEqualToString:@"home"]){
		if ([batterButton isEqual:bowlerButton])
			[batterButton setTitle:[awayPlayersArray objectAtIndex:row] forState:UIControlStateNormal];
		else
			[batterButton setTitle:[homePlayersArray objectAtIndex:row] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"]) {
		if ([batterButton isEqual:bowlerButton])
			[batterButton setTitle:[homePlayersArray objectAtIndex:row] forState:UIControlStateNormal];
		else
			[batterButton setTitle:[awayPlayersArray objectAtIndex:row] forState:UIControlStateNormal];
	}
	
	//set batter integers
	if ([batterButton isEqual:batterName1])
		batter1 = row;
	else if ([batterButton isEqual:batterName2])
		batter2 = row;
	else if ([batterButton isEqual:bowlerButton]){
		bowler = row;
		[oversLabel setText:[NSString stringWithFormat:@"%.1f", fieldStats[1][bowler]]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[3][bowler]]];
		[maidensLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[2][bowler]/6]];
		if(fieldStats[1][bowler] > 0)
			economy = fieldStats[3][bowler]/fieldStats[1][bowler];
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
	}
}

/*- (int)returnLastBowler {
	for (int i = 0; i < fieldingTeamSize; i++){
		if (fieldStats[0][i] == 1)
			return i;
	}
	return -1;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	batter1 = 0;
	batter2 = 1;
	bowler = 0;
	[teamName setText:homeTeam];
	if ([battingTeam isEqualToString:@"home"]) {
		[teamName setText:homeTeam];
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
		fieldingTeamSize = [awayPlayersArray count];
		for (int i = 0; i < 5;i++){
			for (int j = 0; j < fieldingTeamSize; j++) {
				fieldStats[i][j] = 0;
			}
		}
	} else if ([battingTeam isEqualToString:@"away"]) {
		[teamName setText:awayTeam];
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[homePlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
		fieldingTeamSize = [homePlayersArray count];
		for (int i = 0; i < 5;i++){
			for (int j = 0; j < fieldingTeamSize; j++) {
				fieldStats[i][j] = 0;
			}
		}
	}
	lastBowler = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
	if ([battingTeam isEqualToString:@"home"] && [homePlayersArray count] > batter1 && [homePlayersArray count] > batter2 && [awayPlayersArray count] > bowler) {
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	} else if ([battingTeam isEqualToString:@"away"] && [awayPlayersArray count] > batter1 && [awayPlayersArray count] > batter2 && [homePlayersArray count] > bowler) {
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[homePlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
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
	[self setBowlerButton:nil];
    [self setBall1:nil];
    [self setBall2:nil];
    [self setBall3:nil];
    [self setBall4:nil];
    [self setBall5:nil];
    [self setBall6:nil];
	[self setBatter1Active:nil];
	[self setBatter2Active:nil];
	[self setBatter1BallsLabel:nil];
	[self setBatter2BallsLabel:nil];
	[self setBatter1RunsLabel:nil];
	[self setBatter2RunsLabel:nil];
	[self setOversLabel:nil];
	[self setMaidensLabel:nil];
	[self setRunsLabel:nil];
	[self setWicketsLabel:nil];
	[self setEconomyLabel:nil];
	[self setCalculatorView:nil];
	[self setStartGameButton:nil];
	[self setBallLabels:nil];
    [self setNoBallLabel:nil];
    [self setWideLabel:nil];
    [self setByeLabel:nil];
    [self setLegByeLabel:nil];
    [self setPenLabel:nil];
    [self setTotLabel:nil];
    [self setScoreLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
