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
#include "MBProgressHUD.h"
#include "GameListViewController.h"

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
UILabel *runningTotal;
int extraCount = 0;
int height = 255;
int value = -1;
int ballNo = 1;
UIButton *batterButton;
int batter1;
int batter2;
int bowler;
BOOL even;
float runs = 0;
int wickets = 0;
int overs;
float economy = 0.00;
int noBalls = 0;
int noBallAdditions = 0;
int wides = 0;
int wideAdditions = 0;
int byes = 0;
int byeAdditions = 0;
int legByes = 0;
int legByeAdditions = 0;
int penalties = 0;
int penaltiesAdditions = 0;
int fieldingTeamSize;
int battingTeamSize;
float fieldStats[5][20];
int lastBowler;
int bonusRuns = 0;
NSMutableArray *fallOfWickets;
NSArray *waysToBeOut;
NSString *wayBatterOut;
int batterOutInt;
NSMutableArray *extraBallLabels;
bool outPicker = NO;
NSString *outType;
int outBy;
NSMutableArray *allBallLabels;
float inningNumber = 1;
NSString *newBatsman;
int batterReplace = 0;

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
@synthesize ballsScrollView;
@synthesize nextOverButton;
@synthesize enterButton;
@synthesize endGameButton;
@synthesize closeInningsButton;
@synthesize currentOverLabel;
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
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Are you ready to start?"
												message:[NSString stringWithFormat:@"Ensure all details are correct as you will not be able to edit these once the game starts."] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[mes setTag:0];
	[mes show];
}

- (IBAction)endGame:(id)sender{
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"End Game"
												message:[NSString stringWithFormat:@"Are you sure you want to end the game?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[mes setTag:1];
	[mes show];
}

- (IBAction)closeInnings:(id)sender{
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Close Innings"
												message:[NSString stringWithFormat:@"Are you sure you want to close the current innings?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[mes setTag:2];
	[mes show];
}

- (void)startInningsFunction:(id)sender{
	//start game
	[startGameButton setHidden:YES];
	for(int i = 0; i < [calculatorView count]; i++){
		[[calculatorView objectAtIndex:i] setHidden:NO];
	}
	[ballsScrollView setHidden:NO];
	[batterName1 setEnabled:NO];
	[batterName2 setEnabled:NO];
	ball1.textColor = [UIColor redColor];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	DatabaseController *instance = [[DatabaseController alloc] init];
	if (buttonIndex == 0)
	{
		[self resignFirstResponder];
	}
	else if (alertView.tag == 0)
	{
		//start game
		[self resignFirstResponder];
		[startGameButton setHidden:YES];
		for(int i = 0; i < [calculatorView count]; i++){
			[[calculatorView objectAtIndex:i] setHidden:NO];
		}
		[ballsScrollView setHidden:NO];
		[instance firstTabSave];
		[instance secondTabSave];
		[instance thirdTabSave];
		[batterName1 setEnabled:NO];
		[batterName2 setEnabled:NO];
        ball1.textColor = [UIColor redColor];
	}
	else if (alertView.tag == 1)
	{
		//end game
		[self resignFirstResponder];
		[self showHUD:@"Game ended"];
		NSString *fow = @"";
		for (int i = [fallOfWickets count]-1; i >= 0; i--){
			fow = [NSString stringWithFormat:@"%@$%@", fow, [fallOfWickets objectAtIndex:i]];
		}
		if ([battingTeam isEqualToString:@"home"]){
			[instance insertStringIntoDatabase:[NSString stringWithFormat:
												@"INSERT INTO INNINGS (GameID, BattingTeamID, InningNumber, FallOfWickets, Score) VALUES (%d, %d, %d, \"%@\", \"%@\")",
												currentGameID, homeTeamID, (int)inningNumber, fow, [scoreLabel text]]];
		} else {
			[instance insertStringIntoDatabase:[NSString stringWithFormat:
												@"INSERT INTO INNINGS (GameID, BattingTeamID, InningNumber, FallOfWickets, Score) VALUES (%d, %d, %d, \"%@\", \"%@\")",
												currentGameID, awayTeamID, (int)inningNumber, fow, [scoreLabel text]]];
		}
		[instance updateCurrentGameFinshed];
		[self performSegueWithIdentifier:@"endGameSegue" sender:endGameButton];
		
	}
	else if (alertView.tag == 2)
	{
		//close innings
		NSString *fow = @"";
		for (int i = [fallOfWickets count]-1; i >= 0; i--){
			fow = [NSString stringWithFormat:@"%@$%@", fow, [fallOfWickets objectAtIndex:i]];
		}
		if ([battingTeam isEqualToString:@"home"]){
			[instance insertStringIntoDatabase:[NSString stringWithFormat:
												@"INSERT INTO INNINGS (GameID, BattingTeamID, InningNumber, FallOfWickets, Score) VALUES (%d, %d, %d, \"%@\", \"%@\")",
												currentGameID, homeTeamID, (int)inningNumber, fow, [scoreLabel text]]];
		} else {
			[instance insertStringIntoDatabase:[NSString stringWithFormat:
												@"INSERT INTO INNINGS (GameID, BattingTeamID, InningNumber, FallOfWickets, Score) VALUES (%d, %d, %d, \"%@\", \"%@\")",
												currentGameID, awayTeamID, (int)inningNumber, fow, [scoreLabel text]]];
		}
		
		inningNumber+=0.5;
		if([battingTeam isEqualToString:@"home"])
			battingTeam = @"away";
		else
			battingTeam = @"home";
		for (int i=1; i<=extraCount;i++)
        {
            [[ballsScrollView viewWithTag:i] removeFromSuperview];
            [allBallLabels removeLastObject];
        }  
        
		[self showHUD:@"Innings closed"];
		[self viewDidLoad];
              
        ballNo = 1;
        [ball1 setFrame:CGRectMake(77, 6, 25, 21)];
        ball1.text = @"-";
        [ball2 setFrame:CGRectMake(110, 6, 25, 21)];
        ball2.text = @"-";
        [ball3 setFrame:CGRectMake(143, 6, 25, 21)];
        ball3.text = @"-";
        [ball4 setFrame:CGRectMake(176, 6, 25, 21)];
        ball4.text = @"-";
        [ball5 setFrame:CGRectMake(209, 6, 25, 21)];
        ball5.text = @"-";
        [ball6 setFrame:CGRectMake(242, 6, 25, 21)];
        ball6.text = @"-";
        [ballsScrollView setContentSize:CGSizeMake(280,33)];
		[self turnLabelsBlack:closeInningsButton];
		[nextOverButton setHidden:YES];
		[endGameButton setHidden:YES];
		[closeInningsButton setHidden:YES];
		[startGameButton setTitle:@"Start Innings" forState:UIControlStateNormal];
		[startGameButton removeTarget:self action:@selector(startGameButton:) forControlEvents:UIControlEventTouchUpInside];
		[startGameButton addTarget:self action:@selector(startInningsFunction:) forControlEvents:UIControlEventTouchUpInside];
		[batterName1 setEnabled:YES];
		[batterName2 setEnabled:YES];
		[ballsScrollView setHidden:YES];
		[startGameButton setHidden:NO];
		
		[self resignFirstResponder];
	}
}

- (IBAction)showHUD:(NSString *)string {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = string;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1];
}

-(int)outTypeToInt{
	for (int i = 0; i < [waysToBeOut count]; i++){
		if ([outType isEqualToString:[waysToBeOut objectAtIndex:i]]){
			if (i == 1) return 100+outBy;
			else if (i == 4) return 200+outBy;
			else return i;
		}
	}
	return -1;
}

-(IBAction)noRuns:(id)sender{
	value = 0;
    [self resetBallValueToString:@"•"];
	even = YES;
	fieldStats[2][bowler] ++;
    [self turnLabelsOrange:sender];
	//maidens++;
    [self resetExtra:sender];
}
-(IBAction)plusOne:(id)sender{
    if (value == -1)
		value += 2;
	else if (value > 99)
		value = 1;
	else
		value ++;
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
    [self turnLabelsOrange:sender];
    
	if (value%2 == 1)
		even = NO;
	else
		even = YES;
    [self resetExtra:sender];
}
-(IBAction)four:(id)sender{
    value = 4;
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
    
    [self turnLabelsOrange:sender];
	even = YES;
    [self resetExtra:sender];
}
-(IBAction)six:(id)sender{
    value = 6;
    
    [self resetBallValueToString:[NSString stringWithFormat:@"%d", value]];
    [self resetExtra:sender];
    [self turnLabelsOrange:sender];
	even = YES;
}

-(IBAction)resetExtra:(id)sender
{
    noBallAdditions = 0;
    wideAdditions = 0;
    byeAdditions = 0;
    legByeAdditions = 0;
    penaltiesAdditions = 0;
    [noBallLabel setTextColor:[UIColor blackColor]];
    [noBallLabel setText: [NSString stringWithFormat: @"%d", noBalls]];
    [wideLabel setTextColor:[UIColor blackColor]];
    [wideLabel setText: [NSString stringWithFormat: @"%d", wides]];
    [byeLabel setTextColor:[UIColor blackColor]];
    [byeLabel setText: [NSString stringWithFormat: @"%d", byes]];
    [legByeLabel setTextColor:[UIColor blackColor]];
    [legByeLabel setText: [NSString stringWithFormat: @"%d", legByes]];
    [penLabel setTextColor:[UIColor blackColor]];
    [penLabel setText: [NSString stringWithFormat: @"%d", penalties]];
    [totLabel setTextColor:[UIColor blackColor]];
    [totLabel setText: [NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes + penalties)]];
}

-(IBAction)confirm:(id)sender{
	if (value > -1) {
        if (value<1000){
            if (ballNo == 1){
                [fallOfWickets addObject: ball1.text];
            }
            else if (ballNo == 2){
                [fallOfWickets addObject: ball2.text];
            }
            if (ballNo == 3){
                [fallOfWickets addObject: ball3.text];
            }
            if (ballNo == 4){
                [fallOfWickets addObject: ball4.text];
            }
            if (ballNo == 5){
                [fallOfWickets addObject: ball5.text];
            }
            if (ballNo == 6){
                [fallOfWickets addObject: ball6.text];
            }
        }
		if (value == 1000){
			wickets++;
			value = 0;
            batterReplace = 1;
			if(batterOutInt == 0) {
				//batter1Balls++;
				batStats[1][batter1]++;
				batStats[0][batter1] = 1;
                [fallOfWickets addObject:@"R1"];
				[self changePlayerNameWhenRetired:batter1];
				[self showActionSheet:batterName1];
			} else {
				//batter2Balls++;
                batterReplace = 2;
				batStats[1][batter2]++;
				batStats[0][batter2] = 1;
                [fallOfWickets addObject:@"R2"];
				[self changePlayerNameWhenRetired:batter2];
				[self showActionSheet:batterName2];
			}
        } else if (value == 2000) {
			fieldStats[4][bowler]++;
			wickets++;
			value = 0;
			if(batterOutInt == 0) {
				//batter1Balls++;
                batterReplace = 1;
				batStats[1][batter1]++;
				batStats[0][batter1] = 1;
				batStats[3][batter1] = [self outTypeToInt];
                [fallOfWickets addObject:[NSString stringWithFormat:@"%@%d",@"W1-",[self outTypeToInt]]];
				[self removePlayerWhenOut:batter1];
				[self showActionSheet:batterName1];
			} else {
				//batter2Balls++;
                batterReplace = 2;
				batStats[1][batter2]++;
				batStats[0][batter2] = 1;
				batStats[3][batter2] = [self outTypeToInt];
                [fallOfWickets addObject:[NSString stringWithFormat:@"%@%d",@"W2-",[self outTypeToInt]]];
				[self removePlayerWhenOut:batter2];
				[self showActionSheet:batterName2];
			}
		} else if (value == 3000){
			wickets++;
			value = 0;
			if(batterOutInt == 0) {
				//batter1Balls++;
                batterReplace = 1;
				batStats[1][batter1]++;
				batStats[0][batter1] = 1;
				batStats[3][batter1] = [self outTypeToInt];
                [fallOfWickets addObject:[NSString stringWithFormat:@"%@%d",@"W1-",[self outTypeToInt]]];
				[self removePlayerWhenOut:batter1];
				[self showActionSheet:batterName1];
			} else {
				//batter2Balls++;
                batterReplace = 2;
				batStats[1][batter2]++;
				batStats[0][batter2] = 1;
				batStats[3][batter2] = [self outTypeToInt];
                [fallOfWickets addObject:[NSString stringWithFormat:@"%@%d",@"W2-",[self outTypeToInt]]];
				[self removePlayerWhenOut:batter2];
				[self showActionSheet:batterName2];
			}
        } else if (value == 4000){
            extraCount ++;
            value = 0;
            noBalls += noBallAdditions;
            wides += wideAdditions;
            byes += byeAdditions;
            legByes += legByeAdditions;
            penalties += penaltiesAdditions;
            runs += noBallAdditions;
            runs += wideAdditions;
            runs += byeAdditions;
            runs += legByeAdditions;
            runs += penaltiesAdditions;
            noBallAdditions = 0;
            wideAdditions=0;
            byeAdditions=0;
            legByeAdditions=0;
            penaltiesAdditions=0;
            
            [totLabel setText: [NSString stringWithFormat:@"%d",(noBalls+wides+byes+legByes+penalties)]];
            [noBallLabel setText: [NSString stringWithFormat:@"%d",noBalls]];
            [wideLabel setText: [NSString stringWithFormat:@"%d",wides]];
            [byeLabel setText: [NSString stringWithFormat:@"%d",byes]];
            [legByeLabel setText: [NSString stringWithFormat:@"%d",legByes]];
            [penLabel setText: [NSString stringWithFormat:@"%d",penalties]];
            
            noBallLabel.textColor = [UIColor blackColor];
            wideLabel.textColor = [UIColor blackColor];
            byeLabel.textColor = [UIColor blackColor];
            legByeLabel.textColor = [UIColor blackColor];
            penLabel.textColor = [UIColor blackColor];
            totLabel.textColor = [UIColor blackColor];
            
            UILabel *toAdd= [[UILabel alloc] initWithFrame:CGRectMake(77 + (((extraCount-1)+(ballNo-1))*33), 6, 25,21)];
            toAdd.tag = extraCount;
            
            [toAdd setTextAlignment:UITextAlignmentCenter];
            if (ballNo == 1)
            {
                [ball1 setFrame:CGRectMake(ball1.frame.origin.x +33,6,25,21)];
                [ball2 setFrame:CGRectMake(ball2.frame.origin.x +33,6,25,21)];
                [ball3 setFrame:CGRectMake(ball3.frame.origin.x +33,6,25, 21)];
                [ball4 setFrame:CGRectMake(ball4.frame.origin.x +33,6,25, 21)];
                [ball5 setFrame:CGRectMake(ball5.frame.origin.x +33,6, 25, 21)];
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball1.text];
                [toAdd setText: ball1.text];
                [ball1 setText: @"-"];
            }
            else if (ballNo == 2)
            {
                [ball2 setFrame:CGRectMake(ball2.frame.origin.x +33,6,25,21)];
                [ball3 setFrame:CGRectMake(ball3.frame.origin.x +33,6,25, 21)];
                [ball4 setFrame:CGRectMake(ball4.frame.origin.x +33,6,25, 21)];
                [ball5 setFrame:CGRectMake(ball5.frame.origin.x +33,6, 25, 21)];
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball2.text];
                [toAdd setText: ball2.text];
                [ball2 setText: @"-"];
            }
            else if (ballNo == 3)
            {
                [ball3 setFrame:CGRectMake(ball3.frame.origin.x +33,6,25, 21)];
                [ball4 setFrame:CGRectMake(ball4.frame.origin.x +33,6,25, 21)];
                [ball5 setFrame:CGRectMake(ball5.frame.origin.x +33,6, 25, 21)];
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball3.text];
                [toAdd setText: ball3.text];
                [ball3 setText: @"-"];
            }
            else if (ballNo == 4)
            {
                [ball4 setFrame:CGRectMake(ball4.frame.origin.x +33,6,25, 21)];
                [ball5 setFrame:CGRectMake(ball5.frame.origin.x +33,6, 25, 21)];
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball4.text];
                [toAdd setText: ball4.text];
                [ball4 setText: @"-"];
            }
            else if (ballNo == 5)
            {
                [ball5 setFrame:CGRectMake(ball5.frame.origin.x +33,6, 25, 21)];
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball5.text];
                [toAdd setText: ball5.text];
                [ball5 setText: @"-"];
            }
            else if (ballNo == 6)
            {
                [ball6 setFrame:CGRectMake(ball6.frame.origin.x +33, 6, 25, 21)];
                [fallOfWickets addObject: ball6.text];
                [toAdd setText: ball6.text];
                [ball6 setText: @"-"];
            }
            [allBallLabels addObject:toAdd];
            [ballsScrollView addSubview: [allBallLabels objectAtIndex:extraCount-1]];
            [ballsScrollView setContentOffset:CGPointMake((33*extraCount),0) animated:YES];
            ballsScrollView.contentSize = CGSizeMake(ballsScrollView.contentSize.width  + (33*extraCount), ballsScrollView.contentSize.height);
            ballNo--;
            
		} else if ([batter1Active isHidden]) {
			//batter2Runs += value;
			//batter2Balls++;
			batStats[1][batter2]++;
			batStats[2][batter2] += value;
		} else {
			//batter1Runs += value;
			//batter1Balls++;
			batStats[1][batter1]++;
			batStats[2][batter1] += value;
		}       
        
        
		//overs += 0.1;
		fieldStats[1][bowler] += 0.1;
		runs += value;
		fieldStats[3][bowler] += value;
		fieldStats[0][bowler] = 2;
		value = -1;
        
        [self turnLabelsGreen:sender];
        
		if (ballNo<6)
			ballNo ++;
		else{
			ballNo++;
			[nextOverButton setHidden:NO];
			[endGameButton setHidden:NO];
			[closeInningsButton setHidden:NO];
			fieldStats[2][bowler] -= (int)(fieldStats[2][bowler])%6;
			overs++;
			//maidens -= maidens%6;
			for (int i = 0; i < fieldingTeamSize; i++){
				if(fieldStats[0][i] != 0)
					fieldStats[0][i]--;
			}
		}
		if ((fieldStats[1][bowler]-(int)(fieldStats[1][bowler]))*10 == 6) {
			fieldStats[1][bowler] -= 0.6;
			fieldStats[1][bowler]++;
		}
		[self turnLabelsRed:sender];
		[scoreLabel setText:[NSString stringWithFormat:@"%.0f/%d (%d Overs)", runs, wickets, overs]];
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter1]]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter2]]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter1]]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter2]]];
		[oversLabel setText:[NSString stringWithFormat:@"%.1f", fieldStats[1][bowler]]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[3][bowler]]];
		[maidensLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[2][bowler]/6]];
		[wicketsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[4][bowler]]];
		if(fieldStats[1][bowler] > 0)
			economy = fieldStats[3][bowler]/fieldStats[1][bowler];
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
		
		[self changeBatterFacingBowler];
	}/* else if (value == -2) {
		fieldStats[4][bowler]++;
		wickets++;
		[scoreLabel setText:[NSString stringWithFormat:@"%.0f/%d (%d Overs)", runs, wickets, overs]];
		[wicketsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[4][bowler]]];
	} else if (value == -3){
		wickets++;
		[scoreLabel setText:[NSString stringWithFormat:@"%.0f/%d (%d Overs)", runs, wickets, overs]];
	}*/
}

- (IBAction)undo:(id)sender {
	if (fieldStats[1][bowler] >= 0 && ballNo > 1) {
		NSString *deletedVal = [NSString stringWithFormat:@"%@", [fallOfWickets objectAtIndex:[fallOfWickets count]-1]];
		NSString *firstChar = [deletedVal substringToIndex:1];
		if (value <= -1 && ! [firstChar isEqualToString:@"W"]) {
            [fallOfWickets removeObjectAtIndex:[fallOfWickets count]-1];
            if([firstChar isEqualToString:@"n"])
            {
                noBalls --;
                runs --;
                noBallLabel.text = [NSString stringWithFormat:@"%d", noBalls];
                extraCount--;
                [[[ballsScrollView subviews] objectAtIndex:[[ballsScrollView subviews] count]-1]removeFromSuperview];
                [allBallLabels removeLastObject];
                [self moveBackBallLabel:sender];
            }
            if([firstChar isEqualToString:@"w"])
            {
                wides --;
                runs --;
                wideLabel.text = [NSString stringWithFormat:@"%d", wides];
                extraCount--;
                [[[ballsScrollView subviews] objectAtIndex:[[ballsScrollView subviews] count]-1]removeFromSuperview];
				[allBallLabels removeLastObject];
                [self moveBackBallLabel:sender];
            }
            if([firstChar isEqualToString:@"b"])
            {
                int toSubtract = [[deletedVal substringFromIndex:1] intValue];
                byes -= toSubtract;
                runs -= toSubtract;
                byeLabel.text = [NSString stringWithFormat:@"%d", byes];
                extraCount--;
                [[[ballsScrollView subviews] objectAtIndex:[[ballsScrollView subviews] count]-1]removeFromSuperview];
				[allBallLabels removeLastObject];
                [self moveBackBallLabel:sender];
            }
            if([firstChar isEqualToString:@"l"])
            {
                int toSubtract = [[deletedVal substringFromIndex:2] intValue];
                legByes -= toSubtract;
                runs -= toSubtract;
                legByeLabel.text = [NSString stringWithFormat:@"%d", legByes];
                extraCount--;
                [[[ballsScrollView subviews] objectAtIndex:[[ballsScrollView subviews] count]-1]removeFromSuperview];
				[allBallLabels removeLastObject];
                [self moveBackBallLabel:sender];
            }
            if([firstChar isEqualToString:@"p"])
            {
                int toSubtract = [[deletedVal substringFromIndex:1] intValue];
                runs -= toSubtract;
                penalties -= toSubtract;
                penLabel.text = [NSString stringWithFormat:@"%d", penalties];
                extraCount--;
                [[[ballsScrollView subviews] objectAtIndex:[[ballsScrollView subviews] count]-1]removeFromSuperview];
				[allBallLabels removeLastObject];
                [self moveBackBallLabel:sender];
            }
            else
            {
                if (ballNo == 1)
                    fieldStats[1][bowler]--;
                if (ballNo == 7)
                    [nextOverButton setHidden:YES];
                ballNo--;
                value = [self getBallValue];
                if (value%2 == 0) even = YES; else even = NO;
                [self changeBatterFacingBowler];
                if ([batter1Active isHidden]) {
                    //batter2Runs -= value;
                    //batter2Balls--;
                    batStats[2][batter2] -= value;
                    batStats[1][batter2]--;
                } else {
                    //batter1Runs -= value;
                    //batter1Balls--;
                    batStats[2][batter1] -= value;
                    batStats[1][batter1]--;
                }
                runs -= value;
                if (fieldStats[1][bowler]-(int)(fieldStats[1][bowler]) == 0)
                    fieldStats[1][bowler] -= 0.5;
                else
                    fieldStats[1][bowler] -= 0.1;
                fieldStats[3][bowler] -= value;
                [self resetBallValueToString:@"-"];
            }
            
            totLabel.text = [NSString stringWithFormat:@"%d", (noBalls + wides + byes + legByes +penalties) ];
            
            
            //if ([batter1Active isHidden]) batStats[1][batter2]++;
            //else batStats[1][batter1]++;
		}
		
		value = -1;
        [self turnLabelsBlack:sender];
        
        ballNo --;
        [self turnLabelsGreen:sender];
        ballNo ++;
        
		[self turnLabelsRed:sender];
		[scoreLabel setText:[NSString stringWithFormat:@"%.0f/%d (%d Overs)", runs, wickets, overs]];
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter1]]];
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter2]]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter1]]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter2]]];
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

-(void)moveBackBallLabel:(id)sender
{
    if (ballNo <=6) [ball6 setFrame:CGRectMake(ball6.frame.origin.x-33, 6, 25, 21)];
    if (ballNo <=5)[ball5 setFrame:CGRectMake(ball5.frame.origin.x-33, 6, 25, 21)];
    if (ballNo <=4)[ball4 setFrame:CGRectMake(ball4.frame.origin.x-33, 6, 25, 21)];
    if (ballNo <=3)[ball3 setFrame:CGRectMake(ball3.frame.origin.x-33, 6, 25, 21)];
    if (ballNo <=2)[ball2 setFrame:CGRectMake(ball2.frame.origin.x-33, 6, 25, 21)];
    if (ballNo <=1)[ball1 setFrame:CGRectMake(ball1.frame.origin.x-33, 6, 25, 21)];
    
    [ballsScrollView setContentOffset:CGPointMake((33*extraCount),0) animated:YES];
    ballsScrollView.contentSize = CGSizeMake(ballsScrollView.contentSize.width  - 33, ballsScrollView.contentSize.height);
    
}

- (void)nextOver:(id)sender{
    for (int i=1; i<=extraCount;i++)
    {
        [[ballsScrollView viewWithTag:i] removeFromSuperview];
        [allBallLabels removeLastObject];
    }
    ballNo = 1;
    [ball1 setFrame:CGRectMake(77, 6, 25, 21)];
	ball1.text = @"-";
    [ball2 setFrame:CGRectMake(110, 6, 25, 21)];
	ball2.text = @"-";
    [ball3 setFrame:CGRectMake(143, 6, 25, 21)];
	ball3.text = @"-";
    [ball4 setFrame:CGRectMake(176, 6, 25, 21)];
	ball4.text = @"-";
    [ball5 setFrame:CGRectMake(209, 6, 25, 21)];
	ball5.text = @"-";
    [ball6 setFrame:CGRectMake(242, 6, 25, 21)];
	ball6.text = @"-";
	[self turnLabelsBlack:sender];
    [ballsScrollView setContentSize:CGSizeMake(280,33)];

	[self changeBowler];
	if (even)
		even = NO;
	[self changeBatterFacingBowler];
	[nextOverButton setHidden:YES];
	[endGameButton setHidden:YES];
	[closeInningsButton setHidden:YES];
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

- (void)removePlayerWhenOut:(int)player{
	if (batterOutInt == 0){
		if (batter2 > batter1)
			batter2--;
		batter1 = batter2+1;
	} else {
		if (batter1 > batter2)
			batter1--;
		batter2 = batter1+1;
	}
	if ([battingTeam isEqualToString:@"home"]){
		if (homeCaptain == player) homeCaptain += 100 + [homeOutPlayers count];
		else if (homeCaptain > player && homeCaptain < 100) homeCaptain--;
		if (homeViceCaptain == player) homeViceCaptain += 100 + [homeOutPlayers count];
		else if (homeViceCaptain > player && homeViceCaptain < 100) homeViceCaptain--;
		if (homeWicketKeeper == player) homeWicketKeeper += 100 + [homeOutPlayers count];
		else if (homeWicketKeeper > player && homeWicketKeeper < 100) homeWicketKeeper--;
		[homeOutPlayers addObject:[homePlayersArray objectAtIndex:player]];
		[homePlayersArray removeObjectAtIndex:player];
	} else {
		if (awayCaptain == player) awayCaptain += 100 + [awayOutPlayers count];
		else if (awayCaptain > player && awayCaptain < 100) awayCaptain--;
		if (awayViceCaptain == player) awayViceCaptain += 100 + [awayOutPlayers count];
		else if (awayViceCaptain > player && awayViceCaptain < 100) awayViceCaptain--;
		if (awayWicketKeeper == player) awayWicketKeeper += 100 + [awayOutPlayers count];
		else if (awayWicketKeeper > player && awayWicketKeeper < 100) awayWicketKeeper--;
		[awayOutPlayers addObject:[awayPlayersArray objectAtIndex:player]];
		[awayPlayersArray removeObjectAtIndex:player];
	}
	float temp;
	for (int i = 0; i < 4; i++){
		temp = batStats[i][player];
		for (int j = player; j < battingTeamSize; j++) {
			batStats[i][j] = batStats[i][j+1];
		}
		batStats[i][battingTeamSize-1] = temp;
	}
}

- (void)changePlayerNameWhenRetired:(int)player{
	if ([battingTeam isEqualToString:@"home"]){
		[homePlayersArray insertObject:
		 [NSString stringWithFormat:@"RET:%@", [homePlayersArray objectAtIndex:player]]
							   atIndex:player];
		[homePlayersArray removeObjectAtIndex:player+1];
	} else {
		[awayPlayersArray insertObject:
		 [NSString stringWithFormat:@"RET:%@", [homePlayersArray objectAtIndex:player]]
							   atIndex:player];
		[awayPlayersArray removeObjectAtIndex:player+1];
	}
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
    bonusRuns = 0;
    [self hideActionSheetB:sender];
    batterName1.enabled = false;
    batterName2.enabled = false;
    height = 255;
	NSString *titleString;
	
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	titleString = @"Extras";
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, spacer, titleButton, spacer, nil];
	
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
    height = 255;
	NSString *titleString;
	outPicker = YES;
	
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheetB:)];
	UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
	
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	titleString = @"Wicket";
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, spacer, titleButton, spacer, confirm, nil];
    
	UIPickerView *batterOut= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 140, 250)];
	[batterOut setTag:30];
	batterOut.hidden = false;
    batterOut.delegate = self;
    batterOut.dataSource = self;
    batterOut.showsSelectionIndicator = YES;
	[self selectRowForSelection:batterOut];
	
	UIPickerView *wayOut= [[UIPickerView alloc] initWithFrame:CGRectMake(140, 40, 180, 250)];
	[wayOut setTag:31];
	wayOut.hidden = false;
    wayOut.delegate = self;
    wayOut.dataSource = self;
    wayOut.showsSelectionIndicator = YES;
	[self selectRowForSelection:wayOut];
	
    //add popup view
    [newView addSubview:toolbar];
    [newView addSubview:batterOut];
	[newView addSubview:wayOut];
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

-(IBAction)showOutByPicker:(id)sender typeOfOut:(NSString *)string{
	height = 255;
	NSString *titleString;
	
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	titleString = [NSString stringWithFormat:@"%@ By", string];
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, spacer, titleButton, spacer, nil];
    
	UIPickerView *outBy= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 250)];
	[outBy setTag:32];
	outBy.hidden = false;
    outBy.delegate = self;
    outBy.dataSource = self;
    outBy.showsSelectionIndicator = YES;
	[self selectRowForSelection:outBy];
	
    //add popup view
    [newView addSubview:toolbar];
    [newView addSubview:outBy];
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

-(IBAction)byeCalc:(id)sender string:(NSString *)identifier{
    height = 255;
	NSString *titleString;
	
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector (showExtrasOptions:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *enter = [[UIBarButtonItem alloc]
                              initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(addExtras:)];
	titleString = @"No. of Extras";
	
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
	
	toolbar.items = [NSArray arrayWithObjects:_infoButtonItem,spacer, titleButton, spacer, enter, nil];
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
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back addTarget:self
			 action:@selector(showExtrasOptions:)
   forControlEvents:UIControlEventTouchDown];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    back.frame = CGRectMake(85.0, 100.0, 70.0, 40.0);
    [newView addSubview:back];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirm addTarget:self
                action:@selector(addExtras:)
	  forControlEvents:UIControlEventTouchDown];
    [confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    confirm.frame = CGRectMake(165.0, 100.0, 70.0, 40.0);
    [newView addSubview:confirm];
    if ([identifier isEqualToString:@"Bye"])
    {
        [confirm setTag:1];
        [enter setTag:1];
    }
    else if ([identifier isEqualToString:@"Leg Bye"])
    {
        [confirm setTag:2];
        [enter setTag:2];
    }
    else if ([identifier isEqualToString:@"Pen"])
    {
        [confirm setTag:3];
        [enter setTag:3];
    }
	
    UILabel *extras = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 150.0, 90.0,20.0)];
    extras.text = @"Extras:";
    [newView addSubview: extras];
    
    runningTotal = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 150.0, 40.0,20.0)];
    [newView addSubview: runningTotal];
    
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
    noBallAdditions=1;
    wideAdditions = 0;
    byeAdditions =0;
    legByeAdditions = 0;
    penaltiesAdditions = 0;
    totLabel.text = [NSString stringWithFormat:@"%d%@%d", (noBalls+wides+byes+legByes+penalties),@"+",(noBallAdditions+wideAdditions+byeAdditions+legByeAdditions+penaltiesAdditions)];
    wideLabel.textColor = [UIColor  blackColor];
    byeLabel.textColor = [UIColor  blackColor];
    legByeLabel.textColor = [UIColor  blackColor];
    penLabel.textColor = [UIColor  blackColor];
    value = 4000;
    [noBallLabel setTextColor:[UIColor orangeColor]];
    [self hideActionSheetB:sender];
    [self updateExtrasLabels:sender];
    [self turnLabelsOrange:sender];
    [self resetBallValueToString:@"nb"];
	
}
-(IBAction)extraWide:(id)sender{
    wideAdditions=1;
    
    noBallAdditions = 0;
    byeAdditions =0;
    legByeAdditions = 0;
    penaltiesAdditions = 0;
    totLabel.text = [NSString stringWithFormat:@"%d%@%d", (noBalls+wides+byes+legByes+penalties),@"+",(noBallAdditions+wideAdditions+byeAdditions+legByeAdditions+penaltiesAdditions)];
    noBallLabel.textColor = [UIColor blackColor];
    byeLabel.textColor = [UIColor  blackColor];
    legByeLabel.textColor = [UIColor  blackColor];
    penLabel.textColor = [UIColor  blackColor];
    value = 4000;
    [wideLabel setTextColor:[UIColor orangeColor]];
    [self turnLabelsOrange:sender];
    [self updateExtrasLabels:sender];
    [self resetBallValueToString:@"w"];
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

-(IBAction)addExtras:(id)sender{
    if (bonusRuns!=0)
    {
		if ([sender tag] == 1)
		{
			byeAdditions=bonusRuns;
			byeLabel.textColor = [UIColor orangeColor];
			noBallAdditions = 0;
			wideAdditions =0;
			legByeAdditions = 0;
			penaltiesAdditions = 0;
			noBallLabel.textColor = [UIColor blackColor];
			wideLabel.textColor = [UIColor  blackColor];
			legByeLabel.textColor = [UIColor  blackColor];
			penLabel.textColor = [UIColor  blackColor];
			[self resetBallValueToString:[NSString stringWithFormat:@"%@%d",@"b",bonusRuns]];
		}
		else if ([sender tag] == 2)
		{
			legByeAdditions=bonusRuns;
			legByeLabel.textColor = [UIColor orangeColor];
			noBallAdditions = 0;
			byeAdditions =0;
			wideAdditions = 0;
			penaltiesAdditions = 0;
			noBallLabel.textColor = [UIColor blackColor];
			wideLabel.textColor = [UIColor  blackColor];
			byeLabel.textColor = [UIColor  blackColor];
			penLabel.textColor = [UIColor  blackColor];
			[self resetBallValueToString:[NSString stringWithFormat:@"%@%d",@"lb",bonusRuns]];
			
		}
		else if ([sender tag] == 3)
		{
			penaltiesAdditions=bonusRuns;
			penLabel.textColor = [UIColor orangeColor];
			noBallAdditions = 0;
			byeAdditions =0;
			legByeAdditions = 0;
			wideAdditions = 0;
			noBallLabel.textColor = [UIColor blackColor];
			wideLabel.textColor = [UIColor  blackColor];
			byeLabel.textColor = [UIColor  blackColor];
			legByeLabel.textColor = [UIColor  blackColor];
			[self resetBallValueToString:[NSString stringWithFormat:@"%@%d",@"p",bonusRuns]];
		}
        value = 4000;
        [self updateExtrasLabels:sender];
		bonusRuns = 0;
        [self turnLabelsOrange:sender];
        totLabel.text = [NSString stringWithFormat:@"%d%@%d", (noBalls+wides+byes+legByes+penalties),@"+",(noBallAdditions+wideAdditions+byeAdditions+legByeAdditions+penaltiesAdditions)];
        totLabel.textColor = [UIColor orangeColor];
        
    }
    [self hideActionSheetB:sender];
    
}
-(IBAction)byePlusOne:(id)sender{
    bonusRuns++;
    [runningTotal setText:[NSString stringWithFormat:@"%d", bonusRuns]];
}
-(IBAction)fourBye:(id)sender{
    bonusRuns = 4;
    [runningTotal setText:[NSString stringWithFormat:@"%d", bonusRuns]];
}

-(IBAction)sixBye:(id)sender{
    bonusRuns = 6;
    [runningTotal setText:[NSString stringWithFormat:@"%d", bonusRuns]];
}

- (void)batterOutAction:(NSString *)string {
	if([string isEqualToString:@"Bowled"]){
		value = 2000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Caught"]){
		value = 2000;
		[self resetBallValueToString:@"W"];
		[self showOutByPicker:bowlerButton typeOfOut:@"Caught"];
	} else if([string isEqualToString:@"LBW"]){
		value = 2000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Run Out"]){
		value = 3000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Stumped"]){
		value = 3000;
		[self resetBallValueToString:@"W"];
		[self showOutByPicker:bowlerButton typeOfOut:@"Stumped"];
	} else if([string isEqualToString:@"Hit Wicket"]){
		value = 2000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Handled Ball"]){
		value = 3000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Hit Ball Twice"]){
		value = 3000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Obstr. Field"]){
		value = 3000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Timed Out"]){
		//Ball doesn't increase
		value = 3000;
		[self resetBallValueToString:@"W"];
	} else if([string isEqualToString:@"Retired"]){
		value = 1000;
		[self resetBallValueToString:@"W"];
	}
	outType = string;
}

-(IBAction)showActionSheet:(id)sender {
    batterName1.enabled = false;
    batterName2.enabled = false;
	batterButton = sender;
	height = 255;
    NSString *titleString;
	
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideActionSheet:)];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
	if ([batterButton isEqual:bowlerButton])
		titleString = @"Select Bowler";
	else
		titleString = @"Select Batter";
	
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
    toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, spacer, titleButton, spacer, nil];
    
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

//Used when clicking the done button
- (IBAction)hideActionSheet:(UIBarButtonItem *)infoButtonItem{
	if (![startGameButton isHidden]) {
		batterName1.enabled = true;
		batterName2.enabled = true;
	}
    if (batterReplace == 1 || batterReplace == 2)
    {
        [fallOfWickets addObject:[NSString stringWithFormat:@"%@%d%@%@",@"NEW",batterReplace,@"-",newBatsman]];
        batterReplace = 0;
    }
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y = height;
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	height = CGRectGetMaxY(self.view.bounds);
	if (outPicker){
		[self batterOutAction:outType];
		[self turnLabelsOrange:infoButtonItem];
	}
	outPicker = NO;
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
	outPicker = NO;
}

- (void) selectRowForSelection:(UIPickerView *)pickerView {
	if ([pickerView tag] == 30){
		if ([batter1Active isHidden]){
			[pickerView selectRow:1 inComponent:0 animated:YES];
			[self pickerView:pickerView didSelectRow:1 inComponent:0];
		} else
			[self pickerView:pickerView didSelectRow:0 inComponent:0];
		return;
	}
	if ([pickerView tag] == 31){
		[self pickerView:pickerView didSelectRow:0 inComponent:0];
		return;
	}
	if ([pickerView tag] == 32){
		if ([outType isEqualToString:@"Stumped"] && [battingTeam isEqualToString:@"home"]){
			[pickerView selectRow:awayWicketKeeper inComponent:0 animated:YES];
			[self pickerView:pickerView didSelectRow:1 inComponent:0];
		} else if ([outType isEqualToString:@"Stumped"] && [battingTeam isEqualToString:@"away"]){
			[pickerView selectRow:homeWicketKeeper inComponent:0 animated:YES];
			[self pickerView:pickerView didSelectRow:1 inComponent:0];
		} else
			[self pickerView:pickerView didSelectRow:0 inComponent:0];
		return;
	}
	if ([batterButton isEqual:batterName1] && batter1 < [pickerView numberOfRowsInComponent:0])
		[pickerView selectRow:batter1 inComponent:0 animated:YES];
	else if ([batterButton isEqual:batterName2] && batter2 < [pickerView numberOfRowsInComponent:0])
		[pickerView selectRow:batter2 inComponent:0 animated:YES];
	else if ([batterButton isEqual:bowlerButton] && bowler < [pickerView numberOfRowsInComponent:0]){
		[pickerView selectRow:bowler inComponent:0 animated:YES];
		[self pickerView:pickerView didSelectRow:bowler inComponent:0];
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

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)_choosePlayer{
    return 1;
}

//number of rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if ([pickerView tag] == 32) batterButton = bowlerButton;
	if ([pickerView tag] == 30){
		return 2;
	} else if ([pickerView tag] == 31){
		return 11;
	} else if ([battingTeam isEqualToString:@"home"]) {
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
	if ([pickerView tag] == 32) batterButton = bowlerButton;
	if ([pickerView tag] == 30){
		if (row == 0)
			return [[batterName1 titleLabel] text];
		else
			return [[batterName2 titleLabel] text];
	} else if ([pickerView tag] == 31){
		return [waysToBeOut objectAtIndex:row];
	} else if ([battingTeam isEqualToString:@"home"]) {
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
    newBatsman = [NSString stringWithFormat: @"%d", row];
	if ([pickerView tag] == 30){
		batterOutInt = row;
		return;
	}
	if ([pickerView tag] == 31){
		outType = [NSString stringWithFormat:@"%@", [waysToBeOut objectAtIndex:row]];
		return;
	}
	if ([pickerView tag] == 32){
		outBy = row;
		return;
	}
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
	if ([batterButton isEqual:batterName1]){
		batter1 = row;
		[batter1RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter1]]];
		[batter1BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter1]]];
	} else if ([batterButton isEqual:batterName2]){
		batter2 = row;
		[batter2RunsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[2][batter2]]];
		[batter2BallsLabel setText:[NSString stringWithFormat:@"%.0f", batStats[1][batter2]]];
	} else if ([batterButton isEqual:bowlerButton]){
		bowler = row;
		[oversLabel setText:[NSString stringWithFormat:@"%.1f", fieldStats[1][bowler]]];
		[runsLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[3][bowler]]];
		[maidensLabel setText:[NSString stringWithFormat:@"%.0f", fieldStats[2][bowler]/6]];
		if(fieldStats[1][bowler] > 0)
			economy = fieldStats[3][bowler]/fieldStats[1][bowler];
		else
			economy = 0;
		[economyLabel setText:[NSString stringWithFormat:@"%.2f", economy]];
	}
}

- (void)fillWayOutArray{
	waysToBeOut = [[NSArray alloc] initWithObjects:
				   @"Bowled", @"Caught", @"LBW", @"Run Out", @"Stumped", @"Hit Wicket", @"Handled Ball", @"Hit Ball Twice", @"Obstr. Field", @"Timed Out", @"Retired", nil];
}

-(IBAction)turnLabelsOrange:(id)sender
{
    if (ballNo == 1)
    {
        ball1.textColor =[UIColor orangeColor];
    }
    else if (ballNo == 2)
    {
        ball2.textColor =[UIColor orangeColor];
    }
    else if (ballNo == 3)
    {
        ball3.textColor =[UIColor orangeColor];
    }
    else if (ballNo == 4)
    {
        ball4.textColor =[UIColor orangeColor];
    }
    else if (ballNo == 5)
    {
        ball5.textColor =[UIColor orangeColor];
    }
    else if (ballNo == 6)
    {
        ball6.textColor =[UIColor orangeColor];
    }
	[enterButton setBackgroundColor:[UIColor orangeColor]];
}

-(IBAction)turnLabelsRed:(id)sender
{
    if (ballNo == 1)
    {
        ball1.textColor =[UIColor redColor];
    }
    else if (ballNo == 2)
    {
        ball2.textColor =[UIColor redColor];
    }
    else if (ballNo == 3)
    {
        ball3.textColor =[UIColor redColor];
    }
    else if (ballNo == 4)
    {
        ball4.textColor =[UIColor redColor];
    }
    else if (ballNo == 5)
    {
        ball5.textColor =[UIColor redColor];
    }
    else if (ballNo == 6)
    {
        ball6.textColor =[UIColor redColor];
    }
	[enterButton setBackgroundColor:[UIColor clearColor]];
}

-(IBAction)turnLabelsGreen:(id)sender
{
    if (ballNo == 1)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
    }
    else if (ballNo == 2)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball2.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
		
    }
    else if (ballNo == 3)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball2.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball3.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
		
    }
    else if (ballNo == 4)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball2.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball3.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball4.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
		
    }
    else if (ballNo == 5)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball2.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball3.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball4.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball5.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
		
    }
    else if (ballNo == 6)
    {
        ball1.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball2.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball3.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball4.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball5.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
        ball6.textColor =[UIColor colorWithRed:.1 green:.5 blue:0 alpha:1.0];
    }
}

-(IBAction)turnLabelsBlack:(id)sender
{
    ball1.textColor =[UIColor blackColor];
    ball2.textColor =[UIColor blackColor];
    ball3.textColor =[UIColor blackColor];
    ball4.textColor =[UIColor blackColor];
    ball5.textColor =[UIColor blackColor];
    ball6.textColor =[UIColor blackColor];
    noBallLabel.textColor = [UIColor blackColor];
    wideLabel.textColor = [UIColor  blackColor];
    byeLabel.textColor = [UIColor  blackColor];
    legByeLabel.textColor = [UIColor  blackColor];
    penLabel.textColor = [UIColor  blackColor];
}

-(IBAction)updateExtrasLabels:(id)sender
{
    [penLabel setText:[NSString stringWithFormat: @"%d%@%d",penalties,@"+",penaltiesAdditions]];
    [noBallLabel setText:[NSString stringWithFormat:@"%d%@%d", noBalls,@"+",noBallAdditions]];
    [legByeLabel setText:[NSString stringWithFormat: @"%d%@%d",legByes,@"+",legByeAdditions]];
    [byeLabel setText: [NSString stringWithFormat: @"%d%@%d",byes,@"+",byeAdditions]];
    [wideLabel setText:[NSString stringWithFormat:@"%d%@%d", wides,@"+", wideAdditions]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ballsScrollView setDelegate:self];
    [ballsScrollView setContentSize:CGSizeMake(280, 33)];
    allBallLabels =[[NSMutableArray alloc ] init];
	// Do any additional setup after loading the view.
	batter1 = 0;
	batter2 = 1;
	bowler = 0;
    fallOfWickets= [[NSMutableArray alloc] init];
	[teamName setText:homeTeam];
	if ([battingTeam isEqualToString:@"home"]) {
		[teamName setText:homeTeam];
		[batterName1 setTitle:[homePlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[homePlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[awayPlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
		fieldingTeamSize = [awayPlayersArray count];
		battingTeamSize = [homePlayersArray count];
		for (int i = 0; i < 5;i++){
			for (int j = 0; j < fieldingTeamSize; j++) {
				fieldStats[i][j] = 0;
			}
		}
		for (int i = 0; i < 4;i++){
			for (int j = 0; j < battingTeamSize; j++) {
				batStats[i][j] = 0;
			}
		}
	} else if ([battingTeam isEqualToString:@"away"]) {
		[teamName setText:awayTeam];
		[batterName1 setTitle:[awayPlayersArray objectAtIndex:batter1] forState:UIControlStateNormal];
		[batterName2 setTitle:[awayPlayersArray objectAtIndex:batter2] forState:UIControlStateNormal];
		[bowlerButton setTitle:[homePlayersArray objectAtIndex:bowler] forState:UIControlStateNormal];
		fieldingTeamSize = [homePlayersArray count];
		battingTeamSize = [awayPlayersArray count];
		for (int i = 0; i < 5;i++){
			for (int j = 0; j < fieldingTeamSize; j++) {
				fieldStats[i][j] = 0;
			}
		}
		for (int i = 0; i < 4;i++){
			for (int j = 0; j < battingTeamSize; j++) {
				batStats[i][j] = 0;
			}
		}
	}
	[scoreLabel setText:@"-"];
	[batter1RunsLabel setText:@"-"];
	[batter2RunsLabel setText:@"-"];
	[batter1BallsLabel setText:@"-"];
	[batter2BallsLabel setText:@"-"];
	[oversLabel setText:@"-"];
	[runsLabel setText:@"-"];
	[maidensLabel setText:@"-"];
	[wicketsLabel setText:@"-"];
	[economyLabel setText:@"-"];
	[totLabel setText:@"-"];
	[noBallLabel setText:@"-"];
	[wideLabel setText:@"-"];
	[byeLabel setText:@"-"];
	[legByeLabel setText:@"-"];
	[penLabel setText:@"-"];
	
	extraCount = 0;
	ballNo = 1;
	runs = 0;
	wickets = 0;
	overs = 0;
	economy = 0.00;
	noBalls = 0;
	wides = 0;
	byes = 0;
	legByes = 0;
	penalties = 0;
	bonusRuns = 0;
	lastBowler = 0;
	[self fillWayOutArray];
	
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
    [self setBallsScrollView:nil];
	[self setNextOverButton:nil];
	[self setEnterButton:nil];
	[self setEndGameButton:nil];
	[self setCloseInningsButton:nil];
    [self setCurrentOverLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
