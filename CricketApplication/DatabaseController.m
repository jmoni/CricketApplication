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

- (void) saveData:(id)sender{
	if ([self selectedIndex] == 0) {
		[self firstTabSave];
	} else if ([self selectedIndex] == 1) {
		[self firstTabSave];
		[self secondTabSave];
	} else if ([self selectedIndex] == 2) {
		//[self thirdTabSave];
		[self firstTabSave];
		[self secondTabSave];
	}
}


//@"IF EXISTS (SELECT * FROM TEAMS WHERE TeamName = \"%@\") BEGIN END ELSE BEGIN INSERT INTO TEAMS (TeamName) VALUES (\"%@\") END"


- (void) firstTabSave {
    //Adds hometeam name to the database, if the name already exists it doesn't add it again
	[self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS (TeamName) SELECT \"%@\" WHERE NOT EXISTS (SELECT 1 FROM TEAMS WHERE TeamName = \"%@\")", homeTeam, homeTeam]];
    //Adds awayteam name to the database, if the name already exists it doesn't add it again
	[self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS (TeamName) SELECT \"%@\" WHERE NOT EXISTS (SELECT 1 FROM TEAMS WHERE TeamName = \"%@\")", awayTeam, awayTeam]];
}

- (IBAction)next: (id) sender
{
    [self setSelectedIndex: [self selectedIndex]+1];
}

- (void) secondTabSave {
	//HOME TEAM
	homeTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
								 @"SELECT TeamID FROM TEAMS WHERE TeamName == '%@'", homeTeam]];
	for (int i = 0; i < [homePlayersArray count]; i++){
		[self insertStringIntoDatabase:[NSString stringWithFormat:
										@"INSERT INTO PLAYERS (TeamID, PlayerName) SELECT %d, \"%@\" WHERE NOT EXISTS (SELECT * FROM Players WHERE (PlayerName = \"%@\") AND (TeamID = %d))",
										homeTeamID, [homePlayersArray objectAtIndex:i], [homePlayersArray objectAtIndex:i], homeTeamID]];
	}
	
	//AWAY TEAM
	awayTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
											  @"SELECT TeamID FROM TEAMS WHERE TeamName == '%@'", awayTeam]];
	for (int i = 0; i < [awayPlayersArray count]; i++){
		[self insertStringIntoDatabase:[NSString stringWithFormat:
										@"INSERT INTO PLAYERS (TeamID, PlayerName) SELECT %d, \"%@\" WHERE NOT EXISTS (SELECT * FROM Players WHERE (PlayerName = \"%@\") AND (TeamID = %d))",
										awayTeamID, [awayPlayersArray objectAtIndex:i], [awayPlayersArray objectAtIndex:i], awayTeamID]];
	}
	
}

- (void) thirdTabSave {
	[self insertStringIntoDatabase:[NSString stringWithFormat:
									@"INSERT INTO GAMES (HomeID, AwayID, GameDate, TossResult, Decision, MatchType, OversOrDays, UmpireOne, UmpireTwo) VALUES (%d, %d, '%@', \"%@\", \"%@\", \"%@\", %d, \"%@\", \"%@\")",
									homeTeamID, awayTeamID, strDate, tossWonBy, decision, matchType, numberOversOrDays, umpireOne, umpireTwo]];
	disableElements = YES;
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
	NSUInteger indexToRemove = 1;
	NSMutableArray *controllersToKeep = [NSMutableArray arrayWithArray:self.viewControllers];
	UIViewController *removedViewController;
	for (int i = 0; i < 2; i++){
		removedViewController = [controllersToKeep objectAtIndex:indexToRemove];
		[controllersToKeep removeObjectAtIndex:indexToRemove];
		[self setViewControllers:controllersToKeep animated:YES];
	}
}

- (void)viewDidUnload
{
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
