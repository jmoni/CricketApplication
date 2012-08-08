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

@interface DatabaseController : UITabBarController{
    UIBarButtonItem *saveButton;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;

- (IBAction)saveData:(id)sender;
- (void)firstTabSave;
- (void)secondTabSave;
- (void)thirdTabSave;
- (IBAction)next: (id) sender;
- (IBAction)share: (id) sender;
@end
