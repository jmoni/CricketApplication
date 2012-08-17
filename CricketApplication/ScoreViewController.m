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
NSMutableArray *fallOfWicketsArrayH;
NSMutableArray *fallOfWicketsArrayA;

// ------------------------------- HOME
NSMutableArray *runsH;
NSMutableArray *ballsH;
NSMutableArray *foursH;
NSMutableArray *sixsH;
// ------------------------------- AWAY
NSMutableArray *runsA;
NSMutableArray *ballsA;
NSMutableArray *foursA;
NSMutableArray *sixsA;
// ------------------------------- Array full of arrays
NSMutableArray *runsArrayHome;
NSMutableArray *runsArrayAway;
NSMutableArray *ballsArrayHome;
NSMutableArray *ballsArrayAway;
NSMutableArray *foursArrayHome;
NSMutableArray *foursArrayAway;
NSMutableArray *sixsArrayHome;
NSMutableArray *sixsArrayAway;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Total number of innings for entire match (to find out how many sections are needed)
    NSInteger t = homeNumberInnings + awayNumberInnings;
    NSLog(@"The total number of innings and therefore sections : %d",t);
    return t;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
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
    
    //NSLog(@"Cell");
    
    static NSString *CellIdentifier = @"Cell";
    
    MyCutstomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    // Set the values in the table
    
    if ((int)indexPath.section % 2 == 0){
        if ([firstTeamBatting isEqualToString: @"home"]){
            cell.lblName.text = [homePlayersDB objectAtIndex:indexPath.row];
            cell.lblR.text = [[runsArrayHome objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lblB.text = [[ballsArrayHome objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lbl4s.text = [[foursArrayHome objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lbl6s.text = [[sixsArrayHome objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
        }
        else{
            cell.lblName.text = [awayPlayersDB objectAtIndex:indexPath.row];
            cell.lblR.text = [[runsArrayAway objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lblB.text = [[ballsArrayAway objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lbl4s.text = [[foursArrayAway objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
            cell.lbl6s.text = [[sixsArrayAway objectAtIndex:(((int)indexPath.section)/2)]objectAtIndex:indexPath.row];
        }
    }
    else if (((int)indexPath.section % 2 == 1)){
        if ([firstTeamBatting isEqualToString: @"home"]){
            cell.lblName.text = [homePlayersDB objectAtIndex:indexPath.row];
            cell.lblR.text = [[runsArrayAway objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lblB.text = [[ballsArrayAway objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lbl4s.text = [[foursArrayAway objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lbl6s.text = [[sixsArrayAway objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
        }
        else{
            cell.lblName.text = [awayPlayersDB objectAtIndex:indexPath.row];
            cell.lblR.text = [[runsArrayHome objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lblB.text = [[ballsArrayHome objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lbl4s.text = [[foursArrayHome objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
            cell.lbl6s.text = [[sixsArrayHome objectAtIndex:(((int)indexPath.section - 1)/2)]objectAtIndex:indexPath.row];
        }
    }
    cell.lblSR.text =@"SR";
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Read in fall of wickets string and turn into array separated by the $ symbol
-(NSMutableArray *)readInFallOfWickets:(int) arrayNumber :(NSString*) string{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    [temp addObjectsFromArray: [string componentsSeparatedByString:@"$"]];
    [temp removeObjectAtIndex:0];
    return temp;
}


// DECODE FALL OF WICKETS FOR THE HOME TEAM
- (void)decodeFallOfWicketsHome : (int) arrayNumber : (NSString*) string{
    NSLog(@"DECODE HOME");
    int batter;
    int runs;
    int tempRuns;
    int tempBalls = 0;
    int tempFours = 0;
    int tempSixs = 0;
    NSString *temp;
    int i=0;
        
    runsH = [NSMutableArray array];
    ballsH = [NSMutableArray array];
    foursH = [NSMutableArray array];
    sixsH = [NSMutableArray array];
    for (int i=0 ; i < [homePlayersDB count] ; i++){
        //----------------- Home
        [runsH insertObject:@"0" atIndex:i];
        [ballsH insertObject:@"0" atIndex:i];
        [foursH insertObject:@"0" atIndex:i];
        [sixsH insertObject:@"0" atIndex:i];
    }
    
    NSMutableArray *fow = [self readInFallOfWickets: arrayNumber :string];
    NSLog(@"arrayNumber: %d, string: %@, fow: %@",arrayNumber, string, fow);
    int l = [fow count];
    
    while (i<l){
        //Get the string in the array at position i
        temp = [fow objectAtIndex:i];
        
        //If it starts with B then its going to be a
        if ([temp hasPrefix:@"B"]){
            temp = [temp substringFromIndex:1];
            batter = [temp intValue];
            //NSLog(@"Batter: %d",batter);
            i++;
        }
        else if ([temp hasPrefix:@"NB"]){
            temp = [temp substringFromIndex:2];
            batter = [temp intValue];
            //NSLog(@"Batter: %d",batter);
            i++;
        }
        else if (![temp hasPrefix:@"B"] || ![temp hasPrefix:@"NB"]){
            // ------------------------------ CALCULATE RUNS
            //Get the number of runs from the fall of wickets
            runs = [temp intValue];
            //Hit a four
            if(runs == 4){
                tempFours = [[foursH objectAtIndex:batter] intValue];
                tempFours = tempFours + 1;
                [foursH replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempFours]];
            }
            //Hit a six
            if(runs == 6){
                tempSixs = [[sixsH objectAtIndex:batter] intValue];
                tempSixs = tempSixs + 1;
                [sixsH replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempSixs]];
            }
            // ------------------------------ CALCULATE RUNS
            //Get the previous number of runs from the array
            tempRuns = [[runsH objectAtIndex:batter] intValue];
            //Add the values together
            runs = runs + tempRuns;
            //Convert and add back into array
            [runsH replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",runs]];
            // ------------------------------ CALCULATE BALLS
            //Get the previous number of balls from the array
            tempBalls = [[ballsH objectAtIndex:batter] intValue];
            //Add one to it for the new ball thrown
            tempBalls = tempBalls + 1;
            //Convert and add back into array
            [ballsH replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempBalls]];
            i++;
        }
    }
    [runsArrayHome addObject:runsH];
    [ballsArrayHome addObject:ballsH];
    [foursArrayHome addObject:foursH];
    [sixsArrayHome addObject:sixsH];
    
    NSLog(@"End of decode home: %@", [runsArrayHome objectAtIndex:arrayNumber]);
}


// DECODE FALL OF WICKETS FOR THE AWAY TEAM
- (void)decodeFallOfWicketsAway : (int) arrayNumber : (NSString*) string{
    NSLog(@"DECODE AWAY");
    int batter;
    int runs;
    int tempRuns;
    int tempBalls = 0;
    int tempFours = 0;
    int tempSixs = 0;
    NSString *temp;
    int i=0;
    
    //Initialise new array (new location for array in arrays)
    runsA = [NSMutableArray array];
    ballsA = [NSMutableArray array];
    foursA = [NSMutableArray array];
    sixsA = [NSMutableArray array];
    //
    for (int i=0 ; i < [homePlayersDB count] ; i++){
        //----------------- Home
        [runsA insertObject:@"0" atIndex:i];
        [ballsA insertObject:@"0" atIndex:i];
        [foursA insertObject:@"0" atIndex:i];
        [sixsA insertObject:@"0" atIndex:i];
    }
    
    NSMutableArray *fow = [self readInFallOfWickets: arrayNumber :string];
    NSLog(@"arrayNumber: %d, string: %@, fow: %@",arrayNumber, string, fow);
    int l = [fow count];
    
    while (i<l){
        //Get the string in the array at position i
        temp = [fow objectAtIndex:i];
        
        //If it starts with B then its going to be a
        if ([temp hasPrefix:@"B"]){
            temp = [temp substringFromIndex:1];
            batter = [temp intValue];
            //NSLog(@"Batter: %d",batter);
            i++;
        }
        else if (![temp hasPrefix:@"B"]){
            // ------------------------------ CALCULATE RUNS
            //Get the number of runs from the fall of wickets
            runs = [temp intValue];
            //Hit a four
            if(runs == 4){
                tempFours = [[foursA objectAtIndex:batter] intValue];
                tempFours = tempFours + 1;
                [foursA replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempFours]];
            }
            //Hit a six
            if(runs == 6){
                tempSixs = [[sixsA objectAtIndex:batter] intValue];
                tempSixs = tempSixs + 1;
                [sixsA replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempSixs]];
            }
            //Get the previous number of runs from the array
            tempRuns = [[runsA objectAtIndex:batter] intValue];
            //Add the values together
            runs = runs + tempRuns;
            //NSLog(@"Runs for batter %d : %d",batter,runs);
            //Convert and add back into array
            [runsA replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",runs]];
            // ------------------------------ CALCULATE BALLS
            //Get the previous number of balls from the array
            tempBalls = [[ballsA objectAtIndex:batter] intValue];
            //Add one to it for the new ball thrown
            tempBalls = tempBalls + 1;
            //Convert and add back into array
            [ballsA replaceObjectAtIndex:batter withObject:[NSString stringWithFormat: @"%d",tempBalls]];
            i++;
        }
    }
    [runsArrayAway addObject:runsA];
    [ballsArrayAway addObject:ballsA];
    [foursArrayAway addObject:foursA];
    [sixsArrayAway addObject:sixsA];
    
    NSLog(@"End of decode away: %@", [runsArrayAway objectAtIndex:arrayNumber]);
}


//Initialise the arrays to hold the number of runs/balls/4s/6s for the score card
- (void) initialiseArrays{
    
    runsH = [[NSMutableArray alloc]init];
    ballsH = [[NSMutableArray alloc]init];
    foursH = [[NSMutableArray alloc]init];
    sixsH = [[NSMutableArray alloc]init];
    
    runsA = [[NSMutableArray alloc]init];
    ballsA = [[NSMutableArray alloc]init];
    foursA = [[NSMutableArray alloc]init];
    sixsA = [[NSMutableArray alloc]init];
    
    //arrayInningsRunsHome = [[NSMutableArray alloc]init];
    
    //Initialises the arrays with zeros to start with
    for (int i=0 ; i < [homePlayersDB count] ; i++){
        //----------------- Home
        [runsH insertObject:@"0" atIndex:i];
        [ballsH insertObject:@"0" atIndex:i];
        [foursH insertObject:@"0" atIndex:i];
        [sixsH insertObject:@"0" atIndex:i];
        //----------------- Away
        [runsA insertObject:@"0" atIndex:i];
        [ballsA insertObject:@"0" atIndex:i];
        [foursA insertObject:@"0" atIndex:i];
        [sixsA insertObject:@"0" atIndex:i];
    }
}

//Retrieve data from the database (eg. teamIDS, number of innings, player arrays etc...)
- (void) retrieveFromDatabase{
    
    DatabaseController *instance = [[DatabaseController alloc]init];
    gameID = currentGameID;
    homeTeamID = 0;
    awayTeamID = 0;
    homeNumberInnings = 0;
    awayNumberInnings = 0;
    
    //Get the players names
    playerNamesHome = [[NSArray alloc] initWithArray:homePlayersArray];
	playerNamesAway = [[NSArray alloc] initWithArray:awayPlayersArray];
    
    // Create an instance of database controller so we can use its functions
    
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
    homePlayersDB = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TeamID = %d AND PreviouslyPlayed > 0 ORDER BY PreviouslyPlayed",homeTeamID]];
    awayPlayersDB = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TeamID = %d AND PreviouslyPlayed > 0 ORDER BY PreviouslyPlayed",awayTeamID]];
}

- (void) testing{
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
    NSLog(@"Fall of Wickets Home: %@",fallOfWicketsArrayH);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"ViewLoaded");
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    //Retrieve data from the database (eg. teamIDS, number of innings, player arrays etc...) HAS TO COME BEFORE INITIALISE ARRAYS
    [self retrieveFromDatabase];
    
    //Initialise the arrays to hold the number of runs/balls/4s/6s for the score card
    [self initialiseArrays];
    

    // --------------------------------------------------------------------------------------------------- WORKING FROM HERE!!

    //Initialise the arrays
    runsArrayHome = [[NSMutableArray alloc] init];
    runsArrayAway = [[NSMutableArray alloc] init];
    ballsArrayHome = [[NSMutableArray alloc] init];
    ballsArrayAway = [[NSMutableArray alloc] init];
    foursArrayHome = [[NSMutableArray alloc] init];
    foursArrayAway = [[NSMutableArray alloc] init];
    sixsArrayHome = [[NSMutableArray alloc] init];
    sixsArrayAway = [[NSMutableArray alloc] init];

    
    // Get the fall of wickets string for each innings into an array (home array and a separate away array)
    fallOfWicketsArrayH =[instance returnArrayFromDatabase:[NSString stringWithFormat: @"SELECT FallOfWickets FROM Innings WHERE GameID = %d AND battingTeamID = %d AND InningNumber > 0", gameID,homeTeamID]];
    fallOfWicketsArrayA =[instance returnArrayFromDatabase:[NSString stringWithFormat: @"SELECT FallOfWickets FROM Innings WHERE GameID = %d AND battingTeamID = %d AND InningNumber > 0", gameID,awayTeamID]];

    //NSLog(@"Fall of wickets array home: %@",fallOfWicketsArrayH);
    //NSLog(@"Fall of wickets array away: %@",fallOfWicketsArrayA);
    
    //Decoding for the home team fall of wickets
    for (int i=0 ; i<[fallOfWicketsArrayH count] ; i++){
        NSLog(@"%@",[fallOfWicketsArrayH objectAtIndex:i]);
        [self decodeFallOfWicketsHome:i : [fallOfWicketsArrayH objectAtIndex:i]];
    }
    
    //Decoding for the away team fall of wickets
    for (int i=0 ; i<[fallOfWicketsArrayA count] ; i++){
        NSLog(@"%@",[fallOfWicketsArrayA objectAtIndex:i]);
        [self decodeFallOfWicketsAway:i : [fallOfWicketsArrayA objectAtIndex:i]];
    }
    
    //NSLog(@"Runs Home%@",runsArrayHome);
    //NSLog(@"Runs Away%@",runsArrayAway);
    
    //[self testing];   //Testing using
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"WILL APPEAR");
    /*
      
    // Create an instance of database controller so we can use its functions
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    // Retrieve max number of innings for home and away team using teamIDs from database
    homeNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, homeTeamID]];
    awayNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, awayTeamID]];
    
    [self.table reloadData];
    NSLog(@"RELOAD");
     */
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"DID APPEAR");
    
    /*
    // Create an instance of database controller so we can use its functions
    DatabaseController *instance = [[DatabaseController alloc] init];
    
    // Retrieve max number of innings for home and away team using teamIDs from database
    homeNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, homeTeamID]];
    awayNumberInnings = [instance returnIntFromDatabase:[NSString stringWithFormat: @"SELECT MAX(InningNumber) FROM Innings WHERE GameID = %d AND BattingTeamID = %d", gameID, awayTeamID]];
    
    [self.table reloadData];
     */
    NSLog(@"RELOAD");
    
}

- (void)viewDidUnload{
    [self setTableOfPlayers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
