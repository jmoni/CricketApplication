//
//  DatabaseController.m
//  CricketApplication
//
//  Created by Miranda Aperghis on 06/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "DatabaseController.h"
#import "ThirdViewController.h"
#import "sqlite3.h"
#include "SecondViewController.h"
#include "FirstViewController.h"

@interface DatabaseController ()
@end

@implementation DatabaseController
@synthesize saveButton = _saveButton;
@synthesize nextButton;
@synthesize tabBar;
@synthesize navBar;

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cricket.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
        return;
	}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cricket.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	NSLog(@"\nDatabase didn't exist");
	if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void) firstTabSave {
    //Adds hometeam name to the database, if the name already exists it doesn't add it again
	[self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS (TeamName) SELECT \"%@\" WHERE NOT EXISTS (SELECT 1 FROM TEAMS WHERE TeamName = \"%@\")", homeTeam, homeTeam]];
    //Adds awayteam name to the database, if the name already exists it doesn't add it again
	[self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS (TeamName) SELECT \"%@\" WHERE NOT EXISTS (SELECT 1 FROM TEAMS WHERE TeamName = \"%@\")", awayTeam, awayTeam]];
}

- (IBAction)next:(id)sender {
	if ([self selectedIndex] == 0) {
		[self firstTabSave];
		[[[tabBar items] objectAtIndex:1] setEnabled:YES];
        [self setSelectedIndex: [self selectedIndex]+1];
	} else if ([self selectedIndex] == 1) {
		if([homePlayersArray count] < 2 || [awayPlayersArray count] < 2){
			UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@""
														message:@"Each team must have at least two players" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[mes show];
		} else {
			[self secondTabSave];
			[[[tabBar items] objectAtIndex:2] setEnabled:YES];
			[self setSelectedIndex: [self selectedIndex]+1];
			[nextButton setStyle:UIBarButtonItemStyleDone];
			[nextButton setTitle:@"Share"];
			[nextButton setAction: @selector(share:)];
		}
	} else if ([self selectedIndex] == 2) {
		[self firstTabSave];
		[self secondTabSave];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self resignFirstResponder];
}

-(IBAction)share:(id) sender{
    NSLog(@"changed");
}
- (void) secondTabSave {
    //Set home teamID to be used in second view controller for when adding players from database
    homeTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
                                              @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", homeTeam]];
	//HOME TEAM
    for (int i = 0; i < [homePlayersArray count]; i++){
		[self insertStringIntoDatabase:[NSString stringWithFormat:
										@"INSERT INTO PLAYERS (TeamID, PlayerName, PreviouslyPlayed) SELECT %d, \"%@\", 1 WHERE NOT EXISTS (SELECT * FROM Players WHERE (PlayerName = \"%@\") AND (TeamID = %d))",
										homeTeamID, [homePlayersArray objectAtIndex:i], [homePlayersArray objectAtIndex:i], homeTeamID]];
	}
	//Set away teamID to be used in second view controller for when adding players from database
    awayTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
											  @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", awayTeam]];
	//AWAY TEAM
	for (int i = 0; i < [awayPlayersArray count]; i++){
		[self insertStringIntoDatabase:[NSString stringWithFormat:
										@"INSERT INTO PLAYERS (TeamID, PlayerName, PreviouslyPlayed) SELECT %d, \"%@\", 1 WHERE NOT EXISTS (SELECT * FROM Players WHERE (PlayerName = \"%@\") AND (TeamID = %d))",
										awayTeamID, [awayPlayersArray objectAtIndex:i], [awayPlayersArray objectAtIndex:i], awayTeamID]];
	}

}

- (void) thirdTabSave {
	[self insertStringIntoDatabase:[NSString stringWithFormat:
									@"INSERT INTO GAMES (HomeID, AwayID, GameDate, TossResult, Decision, MatchType, OversOrDays, UmpireOne, UmpireTwo) VALUES (%d, %d, '%@', \"%@\", \"%@\", \"%@\", %d, \"%@\", \"%@\")",
									homeTeamID, awayTeamID, strDate, tossWonBy, decision, matchType, numberOversOrDays, umpireOne, umpireTwo]];
	disableElements = YES;
    
    NSLog(@"START GAME");

    //First set all players in array to not played
    [self setPlayersNotPlayed];
    
    //Set players to last played in database based on list in team when game starts - Home Team
    for (int i=0 ; i<[homePlayersArray count] ; i++){
        [self updatePlayedPlayersHome : [homePlayersArray objectAtIndex:i]];
    }
    //Set players to last played in database based on list in team when game starts - Away Team
    for (int i=0 ; i<[awayPlayersArray count] ; i++){
        [self updatePlayedPlayersAway : [awayPlayersArray objectAtIndex:i]];
    }
    
}


//Call function to update the home players who last played
- (void)updatePlayedPlayersHome:(NSString *)name {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        
        NSString *string = [NSString stringWithFormat: @"UPDATE Players SET PreviouslyPlayed = 1 WHERE PlayerName = \"%@\" AND TEAMID = %d", name, homeTeamID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Update player who has played
            sqlite3_column_text(statement, 0);
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

//Call function to update the away players who last played
- (void)updatePlayedPlayersAway:(NSString *)name {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        
        NSString *string = [NSString stringWithFormat: @"UPDATE Players SET PreviouslyPlayed = 1 WHERE PlayerName = \"%@\" AND TEAMID = %d", name, awayTeamID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Update player who has played
            sqlite3_column_text(statement, 0);
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

//Call function to update the players who last played
- (void)setPlayersNotPlayed {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        
        NSString *string = [NSString stringWithFormat: @"UPDATE Players SET PreviouslyPlayed = 0"];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Update player who has played
            sqlite3_column_text(statement, 0);
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

- (int)returnIntFromDatabase:(NSString *)string {
	int returnThis = -1;
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
			returnThis = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
	return returnThis;
}

- (void)insertStringIntoDatabase:(NSString *)string {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			NSLog(@"\nAccess worked");
		} else {
			NSLog(@"\nAccess failed");
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createEditableCopyOfDatabaseIfNeeded];
	for (int i = 1; i < 3; i++){
		[[[tabBar items] objectAtIndex:i] setEnabled:FALSE];
	}
	[navBar setTitle:@"Cricket Application"];
}

- (void)viewDidUnload
{
    [self setSaveButton:nil];
    [self setNextButton:nil];
	[self setTabBar:nil];
	[self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
