//
//  DatabaseController.h
//  CricketApplication
//
//  Created by Miranda Aperghis on 06/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

int homeTeamID;
int awayTeamID;
NSString *writableDBPath;
sqlite3 *cricketDB;
bool disableElements;
bool loadElements;
int currentGameID;

@interface DatabaseController : UITabBarController <UITabBarControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

- (void)firstTabSave;
- (void)secondTabSave;
- (void)thirdTabSave;
- (IBAction)next: (id) sender;
- (IBAction)share: (id) sender;
- (void)insertStringIntoDatabase:(NSString *)string;
- (void)retrieveTeamsInDatabase;
- (void)retrieveGamesInDatabaseWithFinishedStatus:(int)status;
- (void)removeGameInDatabase:(int)gameID;
- (void)updateCurrentGameFinshed;
- (NSString *)returnStringFromDatabase:(NSString *)string;
- (NSString *)returnDateOfMatchFromDatabase;
- (int)returnIntFromDatabase:(NSString *)string;
- (NSMutableArray *)returnPlayersFromDatabase:(NSString *)string;

@end
