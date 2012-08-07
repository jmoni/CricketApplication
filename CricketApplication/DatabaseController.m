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
	//NSLog(@"%@", documentsDirectory);
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cricket.db"];
	//const char *dbpath = [writableDBPath UTF8String];
	//NSLog(@"Accessed DB at %@", writableDBPath);
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
		//NSLog(@"\nDatabase exists already at %s", dbpath);
        return;
	}
	//NSLog(@"Accessed DB at %@", writableDBPath);
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cricket.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	NSLog(@"\nDatabase didn't exist");
	if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void) saveData:(id)sender{
    [self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS (TeamName) VALUES (\"HELLOWORLD\")"]];
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
