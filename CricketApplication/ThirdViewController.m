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
int value = 0;
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
float overs = 0;
int maidens = 0;
float runs = 0;
int wickets = 0;
float economy = 0.00;

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
@synthesize fallOfWickets;
@synthesize bowlerButton;
@synthesize oversLabel;
@synthesize maidensLabel;
@synthesize runsLabel;
@synthesize wicketsLabel;
@synthesize economyLabel;
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
	value = 0;
    [self resetBallValueToString:@"•"];
	even = YES;
	maidens++;
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
		runs += value;
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
			overs++;
			maidens -= maidens%6;
		}
				
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%d", batter1Runs]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%d", batter2Runs]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%d", batter1Balls]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%d", batter2Balls]];
		[oversLabel setText:[NSString stringWithFormat:@"%.0f", overs]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", runs]];
		[maidensLabel setText:[NSString stringWithFormat:@"%d", maidens/6]];
		if(overs > 0)
			economy = runs/overs;
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
		
		//[sender setHighlightedTextColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1.0f]];
		
		[self changeBatterFacingBowler];
	}
}

- (IBAction)undo:(id)sender {
	if (overs >= 0 && ballNo > 1) {
		if (value > -1) {
			
		} else {
			if (ballNo == 1)
				overs--;
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
		}
		[self resetBallValueToString:@"-"];
		value = -1;
		
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%d", batter1Runs]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%d", batter2Runs]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%d", batter1Balls]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%d", batter2Balls]];
		[oversLabel setText:[NSString stringWithFormat:@"%.0f", overs]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", runs]];
		//[maidensLabel setText:[NSString stringWithFormat:@"%d", maidens/6]];
		if(overs > 0)
			economy = runs/overs;
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
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
	else if ([batterButton isEqual:bowlerButton] && bowler < [pickerView numberOfRowsInComponent:0])
		[pickerView selectRow:bowler inComponent:0 animated:YES];
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
    batterName1.enabled = true;
    batterName2.enabled = true;
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
		row++;
	} else if ([batterButton isEqual:batterName2] && batter1 == row && row == [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row-1 inComponent:0 animated:YES];
		row--;
	} else if ([batterButton isEqual:batterName1] && batter2 == row && row < [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row+1 inComponent:0 animated:YES];
		row++;
	} else if ([batterButton isEqual:batterName1] && batter2 == row && row == [pickerView numberOfRowsInComponent:0]-1){
		[pickerView selectRow:row-1 inComponent:0 animated:YES];
		row--;
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
	else if ([batterButton isEqual:bowlerButton])
		bowler = row;
}

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
	} else if ([battingTeam isEqualToString:@"away"]) {
		[teamName setText:awayTeam];
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[homePlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
	}
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
    fallOfWickets = nil;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
