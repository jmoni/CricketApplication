//
//  SecondViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate> {
	NSMutableArray *homePlayersArray;
	NSMutableArray *awayPlayersArray;
}

@property (strong, nonatomic) IBOutlet UITableView *homePlayersTable;
@property (strong, nonatomic) IBOutlet UITableView *awayPlayersTable;

@end
