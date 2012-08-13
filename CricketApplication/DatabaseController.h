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
@end
