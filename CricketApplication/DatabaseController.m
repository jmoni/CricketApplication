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


- (void) saveData : (id) sender
{
    NSString *docsDir;
     NSArray *dirPaths;
     
     // Get the documents directory
     dirPaths = NSSearchPathForDirectoriesInDomains(
     NSDocumentDirectory, NSUserDomainMask, YES);
     
     docsDir = [dirPaths objectAtIndex:0];
    NSLog(@"%@", docsDir);
    sqlite3_stmt    *statement;
    databasePath = [[NSString alloc] initWithString: @"/Users/miranda/Developer/CricketApplication/CricketApplication/cricket.db"];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO TEAMS (TeamID, TeamName) VALUES (20, \"Hello\")"];
      const char *insert_stmt = [insertSQL UTF8String];
      sqlite3_prepare_v2(cricketDB, insert_stmt,-1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
      {
          NSLog(@"Adding worked");
      } else {
          NSLog(@"Adding failed");
      }
      sqlite3_finalize(statement);
      sqlite3_close(cricketDB);
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
    /*NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:
                                     @"cricket.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status.text = @"Failed to create table";
            }
            
            sqlite3_close(contactDB);
            
        } else {
            status.text = @"Failed to open/create database";
        }
    }*/
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
