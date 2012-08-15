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
#import "SHK.h"
#include "SecondViewController.h"
#include "FirstViewController.h"
#include "GameListViewController.h"

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
			[[[tabBar items] objectAtIndex:3] setEnabled:YES];
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
	// Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!" contentType:SHKURLContentTypeWebpage];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
	// but sometimes it may not find one. To be safe, set it explicitly
	[SHK setRootViewController:self];
	
	// Display the action sheet
	[actionSheet showFromTabBar:self.tabBar];
	[SHK flushOfflineQueue];
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
	currentGameID = [self returnIntFromDatabase:[NSString stringWithFormat:
												 @"SELECT GameID FROM GAMES"]];
	[self insertStringIntoDatabase:[NSString stringWithFormat:
									@"INSERT INTO INNINGS (GameID, BattingTeamID, InningNumber, FallOfWickets, Score) VALUES (%d, %d, 0, \"nil\", \"nil\")", currentGameID, homeTeamID]];
	disableElements = YES;
    
    NSLog(@"START GAME %d", currentGameID);
	
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

//Call function to update the games to finished
- (void)updateCurrentGameFinshed {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        
        NSString *string = [NSString stringWithFormat: @"UPDATE Games SET GameFinished = 1 WHERE GameID = %d", currentGameID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Update game to finished
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

- (NSString *)returnStringFromDatabase:(NSString *)string {
	NSString *returnThis = nil;
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
			returnThis = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
	return returnThis;
}

//Return an array of players
- (NSMutableArray *)returnArrayFromDatabase:(NSString *)string {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into array
            NSString *nameString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            //NSLog(@"%@",nameString);
            [temp addObject: nameString];
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
    return temp;
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

//Return teams in database and put into array
- (void)retrieveTeamsInDatabase {
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string = [NSString stringWithFormat: @"SELECT TeamName FROM TEAMS"];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into array
            NSString *nameString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            //NSLog(@"%@",nameString);
            [teamsInDatabase addObject: nameString];
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
    } else {
        NSLog(@"\nCould not access DB");
    }
}

//Return games in database and put into array
- (void)retrieveGamesInDatabaseWithFinishedStatus:(int)status {
	int counter = 0;
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string;
		if (status == 0)
			string = [NSString stringWithFormat: @"SELECT GameID, HomeID, AwayID, GameDate FROM GAMES WHERE GameFinished = %d", status];
		else
			string = @"SELECT GameID, HomeID, AwayID, GameDate FROM GAMES";
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		if (counter == 0 && status == 1) [gamesInDatabase removeAllObjects];
		if (counter == 0 && status == 0) [gamesInProgressInDatabase removeAllObjects];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into array
            NSString *nameString = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)];
			nameString = [NSString stringWithFormat:@"%@$%@", nameString, [self returnStringFromDatabase:[NSString stringWithFormat:
																   @"SELECT TeamName FROM TEAMS WHERE TeamID = %d", sqlite3_column_int(statement, 1)]]];
            nameString = [NSString stringWithFormat:@"%@ vs. %@", nameString,
						  [self returnStringFromDatabase:[NSString stringWithFormat:
														  @"SELECT TeamName FROM TEAMS WHERE TeamID = %d", sqlite3_column_int(statement, 2)]]];
			nameString = [NSString stringWithFormat:@"%@ on %s", nameString,sqlite3_column_text(statement, 3)];
			//NSLog(@"%@",nameString);
            if(status == 1)[gamesInDatabase addObject: nameString];
			if(status == 0)[gamesInProgressInDatabase addObject:nameString];
			counter++;
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
    } else {
        NSLog(@"\nCould not access DB");
    }
}

//Remove game in database
- (void)removeGameInDatabase:(int)gameID {
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string = [NSString stringWithFormat: @"DELETE FROM Innings WHERE GameID = (SELECT GameID FROM GAMES WHERE GameID = %d);", gameID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			NSLog(@"\nAccess worked");
		} else {
			NSLog(@"\nAccess failed");
		}
		string = [NSString stringWithFormat: @"DELETE FROM GAMES WHERE GameID = %d", gameID];
		stmt = [string UTF8String];
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

- (NSString *)returnDateOfMatchFromDatabase {
	NSString *nameString;
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string = [NSString stringWithFormat:@"SELECT GameDate FROM GAMES WHERE GameID = %d", currentGameID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into array
            nameString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
    } else {
        NSLog(@"\nCould not access DB");
    }
	return nameString;
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
	if (!loadElements){
		for (int i = 1; i < 4; i++){
			[[[tabBar items] objectAtIndex:i] setEnabled:FALSE];
		}
	} else {
		[nextButton setStyle:UIBarButtonItemStyleDone];
		[nextButton setTitle:@"Share"];
		[nextButton setAction: @selector(share:)];
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
