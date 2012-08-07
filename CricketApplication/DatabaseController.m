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

const char *dbpath;

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
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cricket.db"];
	//NSLog(@"Accessed DB at %@", writableDBPath);
	dbpath = [writableDBPath UTF8String];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
        return;
	}
	//NSLog(@"Accessed DB at %@", writableDBPath);
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cricket.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void) saveData:(id)sender{
    //[self insertStringIntoDatabase:[NSString stringWithFormat: @"INSERT INTO TEAMS VALUES (null, \"HELLOWORLD\")"]];
}

- (void)insertStringIntoDatabase:(NSString *)string {
	/*sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		NSLog(@"Accessed DB");
		NSString *insertSQL = string;
		const char *insert_stmt = [insertSQL UTF8String];
		sqlite3_prepare_v2(cricketDB, insert_stmt,-1, &statement, NULL);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			NSLog(@"Access worked");
		} else {
			NSLog(@"Access failed");
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"Could not access DB");
	}*/
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
    [self createEditableCopyOfDatabaseIfNeeded];
    [super viewDidLoad];
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
