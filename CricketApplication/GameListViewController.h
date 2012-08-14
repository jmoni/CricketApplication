//
//  GameListViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 14/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableArray *gamesInDatabase;
NSMutableArray *gamesInProgressInDatabase;

@interface GameListViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

- (IBAction)addNewGame:(id)sender;
@end
