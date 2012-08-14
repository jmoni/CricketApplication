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
    NSArray *playerNames;
    BOOL searching;
    BOOL letUserSelectRow;
}
@property (strong, nonatomic) IBOutlet UILabel *firstTeamBatTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableOfPlayers;
@property (strong, nonatomic) NSArray *playerNames;


@end
