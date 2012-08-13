//
//  ScoreViewController.m
//  CricketApplication
//
//  Created by Miranda Aperghis on 13/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "ScoreViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize firstTeamBatTitle = _firstTeamBatTitle;
@synthesize tableOfPlayers = _tableOfPlayers;
@synthesize playerNames = _playerNames;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playerNames count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.playerNames objectAtIndex: [indexPath row]];
    
    return cell;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *a = @"Innings ";
    if (battingTeam == @"home") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,homeTeam];
    else if (battingTeam == @"away") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,awayTeam];
    
    
    // Do any additional setup after loading the view.
    if (battingTeam == @"home") self.playerNames = [[NSArray alloc] initWithArray:homePlayersArray];
	else if (battingTeam == @"away") self.playerNames = [[NSArray alloc] initWithArray:awayPlayersArray];
    
    
}

- (void)viewDidUnload
{
    [self setFirstTeamBatTitle:nil];
    [self setTableOfPlayers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
