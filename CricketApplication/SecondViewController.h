//
//  SecondViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableArray *homePlayersArray;
NSMutableArray *awayPlayersArray;
NSMutableArray *arrayForDetailView;
int rowForDetaiView;
NSString *teamForDetailView;
int homeCaptain;
int homeViceCaptain;
int homeWicketKeeper;
int awayCaptain;
int awayViceCaptain;
int awayWicketKeeper;
@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *homePlayersTable;
@property (strong, nonatomic) IBOutlet UITableView *awayPlayersTable;

@end