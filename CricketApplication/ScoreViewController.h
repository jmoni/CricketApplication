//
//  ScoreViewController.h
//  CricketApplication
//
//  Created by Miranda Aperghis on 13/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCutstomViewCell.h"

@interface ScoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *playerNamesHome;
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (strong, nonatomic) IBOutlet UITableView *tableOfPlayers;
@property (strong, nonatomic) NSArray *playerNamesHome;
@property (strong, nonatomic) NSArray *playerNamesAway;
@property (strong, nonatomic) IBOutlet UITableView *table;


@end
