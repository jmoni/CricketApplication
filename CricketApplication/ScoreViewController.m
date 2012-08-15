//
//  ScoreViewController.m
//  CricketApplication
//
//  Created by Miranda Aperghis on 13/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "ScoreViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DatabaseController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize firstTeamBatTitle = _firstTeamBatTitle;
@synthesize tableOfPlayers = _tableOfPlayers;
@synthesize playerNamesHome;
@synthesize playerNamesAway;
@synthesize table;

int gameID;
int homeNumberInnings;
int awayNumberInnings;
int homeTeamID;
int awayTeamID;
NSString *whoWonToss;
NSString *decisionToBatOrField;
NSString *firstTeamBatting;
NSString *homeTeamName;
NSString *awayTeamName;
NSMutableArray *homePlayersDB;
NSMutableArray *awayPlayersDB;
NSMutableArray *fallOfWicketsArray;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Total number of innings for entire match (to find out how many sections are needed)
    NSInteger t = homeNumberInnings + awayNumberInnings;
    NSLog(@"The total number of innings and therefore sections : %d",t);
    return t;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"Title");
    if (((int)section % 2 == 0) && [firstTeamBatting isEqualToString: @"home"]){
        return [NSString stringWithFormat:@"%@",homeTeamName];
    }
    else if (((int)section % 2 == 0)&& [firstTeamBatting isEqualToString: @"away"]){
        return [NSString stringWithFormat:@"%@",awayTeamName];
    }
    else if (((int)section % 2 == 1) && [firstTeamBatting isEqualToString: @"home"]){
        return [NSString stringWithFormat:@"%@",awayTeamName];
    }
    else if (((int)section % 2 == 1) && [firstTeamBatting isEqualToString: @"away"]){
        return [NSString stringWithFormat:@"%@",homeTeamName];
    }
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([firstTeamBatting isEqualToString: @"home"])return [playerNamesHome count];
    else if ([firstTeamBatting isEqualToString: @"away"]) return [playerNamesAway count];
    else return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Cell");
    
    static NSString *CellIdentifier = @"Cell";
    
    MyCutstomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    // Set the values in the table
    
    NSLog(@"HERE");
    
    if (((int)indexPath.section % 2 == 0)){
        if ([firstTeamBatting isEqualToString: @"home"]) cell.lblName.text = [homePlayersDB objectAtIndex:indexPath.row];
        else cell.lblName.text = [awayPlayersDB objectAtIndex:indexPath.row];
    }
    else if (((int)indexPath.section % 2 == 1)){
        if ([firstTeamBatting isEqualToString: @"home"]) cell.lblName.text = [awayPlayersDB objectAtIndex:indexPath.row];
        else cell.lblName.text = [homePlayersDB objectAtIndex:indexPath.row];
    }
    
    cell.lblR.text = @"R";
    cell.lblB.text = @"B";
    cell.lbl4s.text =@"4";
    cell.lbl6s.text =@"6";
    cell.lblSR.text =@"SR";
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ViewLoaded");
    
    gameID = currentGameID;
    homeTeamID = 0;
    awayTeamID = 0;
    
    // Do any additional setup after loading the view.
    
    //Get the players names
    playerNamesHome = [[NSArray alloc] initWithArray:homePlayersArray];
	playerNamesAway = [[NSArray alloc] initWithArray:awayPlayersArray];
    
    // Create an instance of database controller so we can use its functions
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    // Retrieve homeID and awayID using the gameID from database
    homeTeamID = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT HomeID FROM Games WHERE GameID = %d",gameID]];
    awayTeamID = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT AwayID FROM Games WHERE GameID = %d",gameID]];
    
    // Retrieve max number of innings for home and away team using teamIDs from database
    homeNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, homeTeamID]];
    awayNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, awayTeamID]];
    
    // Retrieve who won the toss from database
    whoWonToss = [instance returnStringFromDatabase:[NSString stringWithFormat: @"SELECT TossResult FROM Games WHERE GameID = %d", gameID]];
    // Retrieve what the decision was from database
    decisionToBatOrField = [instance returnStringFromDatabase:[NSString stringWithFormat:@"SELECT Decision FROM Games WHERE GameID = %d",gameID]];
    
    // Get team names
    homeTeamName = [instance returnStringFromDatabase:[NSString stringWithFormat: @"SELECT TeamName FROM Teams WHERE TeamID = %d",homeTeamID]];
    awayTeamName = [instance returnStringFromDatabase:[NSString stringWithFormat: @"SELECT TeamName FROM Teams WHERE TeamID = %d",awayTeamID]];
    
    // Get the fall of wickets string
    fallOfWicketsArray = [instance returnArrayFromDatabase:[NSString stringWithFormat: @"SELECT FallOfWickets FROM Innings WHERE GameID = %d AND InningNumber != 0",gameID]];
    
    // Work out which team is batting first
    if ([whoWonToss isEqualToString:@"home"]){
        if ([decisionToBatOrField isEqualToString:@"bat"]){
            firstTeamBatting = @"home";
        }
        else if ([decisionToBatOrField isEqualToString:@"field"]){
            firstTeamBatting = @"away";
        }
    }
    else if ([whoWonToss isEqualToString:@"away"]){
        if ([decisionToBatOrField isEqualToString:@"bat"]){
            firstTeamBatting = @"away";
        }
        else if ([decisionToBatOrField isEqualToString:@"field"]){
            firstTeamBatting = @"home";
        }
    }
    
    //Read players from database into arrays
    homePlayersDB = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TeamID = %d",homeTeamID]];
    awayPlayersDB = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TeamID = %d",awayTeamID]];
    
    
    
    //-------------------------------------------------------------------testing
    NSLog(@"Game ID : %d",gameID);
    NSLog(@"Home Team ID : %d",homeTeamID);
    NSLog(@"Away Team ID : %d",awayTeamID);
    NSLog(@"Home Number of Innings : %d",homeNumberInnings);
    NSLog(@"Away Number of Innings : %d",awayNumberInnings);
    NSLog(@"Toss Result: %@",whoWonToss);
    NSLog(@"Decision: %@",decisionToBatOrField);
    NSLog(@"First team batting: %@",firstTeamBatting);
    NSLog(@"Team 1 Name: %@",homeTeamName);
    NSLog(@"Team 2 Name: %@",awayTeamName);
    NSLog(@"Home Players: %@",homePlayersDB);
    NSLog(@"Away Players: %@",awayPlayersDB);
    NSLog(@"Fall of wickets strings: %@",fallOfWicketsArray);
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"WILL APPEAR");
    
    // Create an instance of database controller so we can use its functions
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    // Retrieve max number of innings for home and away team using teamIDs from database
    homeNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, homeTeamID]];
    awayNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, awayTeamID]];
    
    [self.table reloadData];
    NSLog(@"RELOAD");
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"DID APPEAR");
    
    // Create an instance of database controller so we can use its functions
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    // Retrieve max number of innings for home and away team using teamIDs from database
    homeNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, homeTeamID]];
    awayNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, awayTeamID]];
    
    [self.table reloadData];
    NSLog(@"RELOAD");
    
}

- (void)viewDidUnload
{
    [self setFirstTeamBatTitle:nil];
    [self setTableOfPlayers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
