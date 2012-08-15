//
//  SecondViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "SecondViewController.h"
#import "sqlite3.h"
#include "DetailViewController.h"
#include "StatsViewController.h"
#include "DatabaseController.h"
#include "FirstViewController.h"
#include "ThirdViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeNavBarEditButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *awayNavBarEditButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeNavBarAddButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *awayNavBarAddButton;

@end

@implementation SecondViewController
@synthesize homePlayersTable;
@synthesize awayPlayersTable;
@synthesize homeWonToss;
@synthesize awayWonToss;
@synthesize battingButton;
@synthesize fieldingButton;
@synthesize homeNavBarEditButton;
@synthesize awayNavBarEditButton;
@synthesize homeNavBarAddButton;
@synthesize awayNavBarAddButton;
int homePlayersCount = 12;
int awayPlayersCount = 12;
UIImage *captainIcon;
UIImage *viceCaptainIcon;
UIImage *wicketKeeperIcon;
UIImage *captainWicketKeeper;
UIImage *viceCaptainWicketKeeper;
int hID;
int aID;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if ([tableView isEqual:homePlayersTable] && section == 1) return homeTeam;
	else if ([tableView isEqual:awayPlayersTable] && section == 1) return awayTeam;
	else if ([tableView isEqual:homePlayersTable] && section == 0 && [homeOutPlayers count] > 0) return @"Out Players";
	else if ([tableView isEqual:awayPlayersTable] && section == 0 && [awayOutPlayers count] > 0) return @"Out Players";
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int cellNumber = 0;
	if ([tableView isEqual:homePlayersTable] && section == 1) cellNumber = [homePlayersArray count];
	else if ([tableView isEqual:awayPlayersTable] && section == 1) cellNumber = [awayPlayersArray count];
	else if ([tableView isEqual:homePlayersTable] && section == 0) cellNumber = [homeOutPlayers count];
	else if ([tableView isEqual:awayPlayersTable] && section == 0) cellNumber = [awayOutPlayers count];
    return cellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    // configure your cell here...
	cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, 32.0, 32.0);
	button.frame = frame;
	
	if ([tableView isEqual:homePlayersTable])
    {
		if(indexPath.section == 1){
			cell.textLabel.text = [homePlayersArray objectAtIndex:indexPath.row];
			if (homeCaptain == indexPath.row && homeWicketKeeper == indexPath.row) {
				[button setBackgroundImage:captainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeViceCaptain == indexPath.row && homeWicketKeeper == indexPath.row) {
				[button setBackgroundImage:viceCaptainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeCaptain == indexPath.row) {
				[button setBackgroundImage:captainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeViceCaptain == indexPath.row) {
				[button setBackgroundImage:viceCaptainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeWicketKeeper == indexPath.row) {
				[button setBackgroundImage:wicketKeeperIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else {
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
		} else {
			cell.textLabel.text = [homeOutPlayers objectAtIndex:indexPath.row];
			if (homeCaptain == indexPath.row+100 && homeWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:captainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeViceCaptain == indexPath.row+100 && homeWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:viceCaptainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeCaptain == indexPath.row+100) {
				[button setBackgroundImage:captainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeViceCaptain == indexPath.row+100) {
				[button setBackgroundImage:viceCaptainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (homeWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:wicketKeeperIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else {
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
		}
	} else if ([tableView isEqual:awayPlayersTable]) {
		if(indexPath.section == 1){
			cell.textLabel.text = [awayPlayersArray objectAtIndex:indexPath.row];
			if (awayCaptain == indexPath.row && awayWicketKeeper == indexPath.row) {
				[button setBackgroundImage:captainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayViceCaptain == indexPath.row && awayWicketKeeper == indexPath.row) {
				[button setBackgroundImage:viceCaptainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayCaptain == indexPath.row) {
				[button setBackgroundImage:captainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayViceCaptain == indexPath.row) {
				[button setBackgroundImage:viceCaptainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayWicketKeeper == indexPath.row) {
				[button setBackgroundImage:wicketKeeperIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else {
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
		} else {
			cell.textLabel.text = [awayOutPlayers objectAtIndex:indexPath.row];
			if (awayCaptain == indexPath.row+100 && awayWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:captainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayViceCaptain == indexPath.row+100 && awayWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:viceCaptainWicketKeeper forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayCaptain == indexPath.row+100) {
				[button setBackgroundImage:captainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayViceCaptain == indexPath.row+100) {
				[button setBackgroundImage:viceCaptainIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else if (awayWicketKeeper == indexPath.row+100) {
				[button setBackgroundImage:wicketKeeperIcon forState:UIControlStateNormal];
				[cell setAccessoryView:button];
			} else {
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
		}
	}
    return cell;
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (disableElements) return NO;
	else return YES;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	if([tableView isEqual:homePlayersTable]) {
		NSString *item = [homePlayersArray objectAtIndex:fromIndexPath.row];
		[homePlayersArray removeObject:item];
		[homePlayersArray insertObject:item atIndex:toIndexPath.row];
		if (homeCaptain == fromIndexPath.row) {
			homeCaptain = toIndexPath.row;
		} else if (homeCaptain > fromIndexPath.row && homeCaptain <= toIndexPath.row) {
			homeCaptain--;
		} else if (homeCaptain < fromIndexPath.row && homeCaptain >= toIndexPath.row) {
			homeCaptain++;
		}
		if (homeViceCaptain == fromIndexPath.row) {
			homeViceCaptain = toIndexPath.row;
		} else if (homeViceCaptain > fromIndexPath.row && homeViceCaptain <= toIndexPath.row) {
			homeViceCaptain--;
		} else if (homeViceCaptain < fromIndexPath.row && homeViceCaptain >= toIndexPath.row) {
			homeViceCaptain++;
		}
		if (homeWicketKeeper == fromIndexPath.row) {
			homeWicketKeeper = toIndexPath.row;
		}else if (homeWicketKeeper > fromIndexPath.row && homeWicketKeeper <= toIndexPath.row) {
			homeWicketKeeper--;
		} else if (homeWicketKeeper < fromIndexPath.row && homeWicketKeeper >= toIndexPath.row) {
			homeWicketKeeper++;
		}
	} else if ([tableView isEqual:awayPlayersTable]) {
		NSString *item = [awayPlayersArray objectAtIndex:fromIndexPath.row];
		[awayPlayersArray removeObject:item];
		[awayPlayersArray insertObject:item atIndex:toIndexPath.row];
		if (awayCaptain == fromIndexPath.row) {
			awayCaptain = toIndexPath.row;
		} else if (awayCaptain > fromIndexPath.row && awayCaptain <= toIndexPath.row) {
			awayCaptain--;
		} else if (awayCaptain < fromIndexPath.row && awayCaptain >= toIndexPath.row) {
			awayCaptain++;
		}
		if (awayViceCaptain == fromIndexPath.row) {
			awayViceCaptain = toIndexPath.row;
		} else if (awayViceCaptain > fromIndexPath.row && awayViceCaptain <= toIndexPath.row) {
			awayViceCaptain--;
		} else if (awayViceCaptain < fromIndexPath.row && awayViceCaptain >= toIndexPath.row) {
			awayViceCaptain++;
		}
		if (awayWicketKeeper == fromIndexPath.row) {
			awayWicketKeeper = toIndexPath.row;
		}else if (awayWicketKeeper > fromIndexPath.row && awayWicketKeeper <= toIndexPath.row) {
			awayWicketKeeper--;
		} else if (awayWicketKeeper < fromIndexPath.row && awayWicketKeeper >= toIndexPath.row) {
			awayWicketKeeper++;
		}
	}
	//NSLog(@"awayCaptain:%d\nawayViceCaptain:%d\nawayWicketKeeper%d\n", awayCaptain, awayViceCaptain, awayWicketKeeper);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if(disableElements) return NO;
	else return YES;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if([tableView isEqual:homePlayersTable]){
        NSString *a = [homePlayersArray objectAtIndex:indexPath.row];
        NSLog(@"Remove the name : %@",a);
        //[playersInDatabase addObject:a];
        NSLog(@"Add players %@", playersInDatabase);
    }
    else if([tableView isEqual:awayPlayersTable]){
        NSString *a = [awayPlayersArray objectAtIndex:indexPath.row];
        NSLog(@"Remove the name : %@",a);
        //[playersInDatabase addObject:a];
        NSLog(@"Add players %@", playersInDatabase);
    }
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete && [tableView isEqual:homePlayersTable]) {
		if (homeCaptain > indexPath.row) homeCaptain--;
		if (homeViceCaptain > indexPath.row) homeViceCaptain--;
		if (homeWicketKeeper > indexPath.row) homeWicketKeeper--;
        [homePlayersArray removeObjectAtIndex:indexPath.row];
		[homePlayersTable reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleDelete && [tableView isEqual:awayPlayersTable]) {
        if (awayCaptain > indexPath.row) awayCaptain--;
		if (awayViceCaptain > indexPath.row) awayViceCaptain--;
		if (awayWicketKeeper > indexPath.row) awayWicketKeeper--;
		[awayPlayersArray removeObjectAtIndex:indexPath.row];
		[awayPlayersTable reloadData];
    }
}

//Selected row open up detail view page
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	rowForDetaiView = indexPath.row;
	DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
	StatsViewController *stats = [self.storyboard instantiateViewControllerWithIdentifier:@"Stats"];
	
	if ([tableView isEqual:homePlayersTable]) {
		if (indexPath.section == 1)
			arrayForDetailView = homePlayersArray;
		else
			arrayForDetailView = homeOutPlayers;
		teamForDetailView = @"home";
	} else if ([tableView isEqual:awayPlayersTable]) {
		if (indexPath.section == 1)
			arrayForDetailView = awayPlayersArray;
		else
			arrayForDetailView = awayOutPlayers;
		teamForDetailView = @"away";
	}
	
	if ([tableView isEqual:homePlayersTable] && indexPath.section == 1) {
		[self.navigationController pushViewController:detail animated:YES];
		detail.playerEditTextBox.text = [homePlayersArray objectAtIndex:indexPath.row];
		if (homeCaptain == indexPath.row)
			[detail.CaptainSlider setOn:YES animated:YES];
		else if (homeViceCaptain == indexPath.row)
			[detail.ViceCaptainSlider setOn:YES animated:YES];
		if (homeWicketKeeper == indexPath.row)
			[detail.WicketKeeperSlider setOn:YES animated:YES];
	} else if ([tableView isEqual:awayPlayersTable] && indexPath.section == 1) {
		[self.navigationController pushViewController:detail animated:YES];
		detail.playerEditTextBox.text = [awayPlayersArray objectAtIndex:indexPath.row];
		if (awayCaptain == indexPath.row)
			[detail.CaptainSlider setOn:YES animated:YES];
		else if (awayViceCaptain == indexPath.row)
			[detail.ViceCaptainSlider setOn:YES animated:YES];
		if (awayWicketKeeper == indexPath.row)
			[detail.WicketKeeperSlider setOn:YES animated:YES];
	} else if ([tableView isEqual:homePlayersTable] && indexPath.section == 0) {
		[self.navigationController pushViewController:stats animated:YES];
		stats.playerEditTextBox.text = [homeOutPlayers objectAtIndex:indexPath.row];
		if (homeCaptain == indexPath.row+100)
			[stats.CaptainSlider setOn:YES animated:YES];
		else if (homeViceCaptain == indexPath.row+100)
			[stats.ViceCaptainSlider setOn:YES animated:YES];
		if (homeWicketKeeper == indexPath.row+100)
			[stats.WicketKeeperSlider setOn:YES animated:YES];
		stats.ballsLabel.text = [NSString stringWithFormat:@"%.0f", batStats[1][indexPath.row+[homePlayersArray count]]];
		stats.runsLabel.text = [NSString stringWithFormat:@"%.0f", batStats[2][indexPath.row+[homePlayersArray count]]];
		stats.wayOutLabel.text = [self decodeWayOutNumber:indexPath.row forTeam:@"home"];
	} else if ([tableView isEqual:awayPlayersTable] && indexPath.section == 0) {
		[self.navigationController pushViewController:stats animated:YES];
		stats.playerEditTextBox.text = [awayOutPlayers objectAtIndex:indexPath.row];
		if (awayCaptain == indexPath.row+100)
			[stats.CaptainSlider setOn:YES animated:YES];
		else if (awayViceCaptain == indexPath.row+100)
			[stats.ViceCaptainSlider setOn:YES animated:YES];
		if (awayWicketKeeper == indexPath.row+100)
			[stats.WicketKeeperSlider setOn:YES animated:YES];
		stats.ballsLabel.text = [NSString stringWithFormat:@"%.0f", batStats[1][indexPath.row+[awayPlayersArray count]]];
		stats.runsLabel.text = [NSString stringWithFormat:@"%.0f", batStats[2][indexPath.row+[awayPlayersArray count]]];
		stats.wayOutLabel.text = [self decodeWayOutNumber:indexPath.row forTeam:@"away"];
	}

	detail.battingOrderSlider.value = indexPath.row+1.9;
	detail.sliderValueLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
}

- (NSString *) decodeWayOutNumber:(int)player forTeam:(NSString *)team{
	int temp;
	if ([team isEqualToString:@"home"]){
		temp = batStats[3][player+[homePlayersArray count]];
		NSLog(@"%d", temp);
		if (temp > 199) return [NSString stringWithFormat:@"Stumped by %@", [awayPlayersArray objectAtIndex:temp-200]];
		if (temp > 99) return [NSString stringWithFormat:@"Caught by %@", [awayPlayersArray objectAtIndex:temp-100]];
	} else {
		temp = batStats[3][player+[awayPlayersArray count]];
		if (temp > 199) return [NSString stringWithFormat:@"Stumped by %@", [homePlayersArray objectAtIndex:temp-200]];
		if (temp > 99) return [NSString stringWithFormat:@"Caught by %@", [homePlayersArray objectAtIndex:temp-100]];
	}
	if (temp == 0) return @"Bowled";
	if (temp == 2) return @"LBW";
	if (temp == 3) return @"Run Out";
	if (temp == 5) return @"Hit Wicket";
	if (temp == 6) return @"Handled Ball";
	if (temp == 7) return @"Hit Ball Twice";
	if (temp == 8) return @"Obstucting Field";
	if (temp == 9) return @"Timed Out";
	return nil;
}

- (IBAction)EditTable:(id)sender{
	//NSLog(@"Sender of edit button is: %@\"", sender);
	if(homePlayersTable.editing && [sender isEqual:homeNavBarEditButton])
	{
		[homePlayersTable setEditing:NO animated:NO];
		[homePlayersTable reloadData];
		homeNavBarEditButton.title = @"Edit";
		homeNavBarEditButton.style = UIBarButtonItemStylePlain;
	}
	else if(awayPlayersTable.editing && [sender isEqual:awayNavBarEditButton])
	{
		[awayPlayersTable setEditing:NO animated:NO];
		[awayPlayersTable reloadData];
		awayNavBarEditButton.title = @"Edit";
		awayNavBarEditButton.style = UIBarButtonItemStylePlain;
	}
	else if([sender isEqual:homeNavBarEditButton])
	{
		[homePlayersTable setEditing:YES animated:YES];
		[homePlayersTable reloadData];
		homeNavBarEditButton.title = @"Done";
		homeNavBarEditButton.style = UIBarButtonItemStyleDone;
	}
	else if([sender isEqual:awayNavBarEditButton])
	{
		[awayPlayersTable setEditing:YES animated:YES];
		[awayPlayersTable reloadData];
		awayNavBarEditButton.title = @"Done";
		awayNavBarEditButton.style = UIBarButtonItemStyleDone;
	}
}

- (IBAction)AddCell:(id)sender {
	if ([sender isEqual:homeNavBarAddButton]) {
		[homePlayersArray addObject:[NSString stringWithFormat:@"Player %d", homePlayersCount]];
		[homePlayersTable reloadData];
		homePlayersCount++;
        //[displayPlayers addObject:[NSString stringWithFormat:@"Player %d", homePlayersCount]];
        
	} else if ([sender isEqual:awayNavBarAddButton]) {
		[awayPlayersArray addObject:[NSString stringWithFormat:@"Player %d", awayPlayersCount]];
		[awayPlayersTable reloadData];
        //[displayPlayers addObject:[NSString stringWithFormat:@"Player %d", homePlayersCount]];
		awayPlayersCount++;
	}

}

- (void)tossButtonManage
{
    if (homeWonToss.selected)
	{
        [homeWonToss setSelected:NO];
		[awayWonToss setSelected:YES];
		tossWonBy = @"away";
		if (battingButton.selected) battingTeam = @"away";
		else battingTeam = @"home";
    }
    else
	{
        [homeWonToss setSelected:YES];
		[awayWonToss setSelected:NO];
		tossWonBy = @"home";
		if (battingButton.selected) battingTeam = @"home";
		else battingTeam = @"away";
    }
}

- (void)decisionButtonManage
{
    if (battingButton.selected)
	{
        [battingButton setSelected:NO];
		[fieldingButton setSelected:YES];
		decision = @"field";
		if (homeWonToss.selected) battingTeam = @"away";
		else battingTeam = @"home";
    }
    else
	{
        [battingButton setSelected:YES];
		[fieldingButton setSelected:NO];
		decision = @"bat";
		if (homeWonToss.selected) battingTeam = @"home";
		else battingTeam = @"away";
    }
}


//Add Home Players
-(void) addHomePlayers{
    DatabaseController *instance = [[DatabaseController alloc]init];

    //Get the TeamID home team (greater than 0) from the database if there are already players on the team and if not set to -1
    int c = [instance returnIntFromDatabase:[NSString stringWithFormat:
                                         @"SELECT TeamID FROM PLAYERS WHERE TeamID = '%d'",
                                         homeTeamID]];
    //Players aren't in database - hometeam
    if (c == -1){
        for (int i = 1; i < 12; i++){
            [homePlayersArray addObject:[NSString stringWithFormat:@"Player %2d", i]];
        }
    }
    //Players are in database - hometeam
    else{
        homePlayersArray = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TEAMID = '%d' AND PreviouslyPlayed = 1",
                                 homeTeamID]];
    }
}


//Add Away Players
-(void) addAwayPlayers{
    DatabaseController *instance = [[DatabaseController alloc]init];

    //Get the TeamID away team (greater than 0) from the database if there are already players on the team and if not set to -1
    int c = [instance returnIntFromDatabase:[NSString stringWithFormat:
                                     @"SELECT TeamID FROM PLAYERS WHERE TeamID = '%d'",
                                     awayTeamID]];
    //Players aren't in database - awayteam
    if (c == -1){
        for (int i = 1; i < 12; i++){
            [awayPlayersArray addObject:[NSString stringWithFormat:@"Player %2d", i]];
        }
    }
    //Players are in database - hometeam
    else{
        awayPlayersArray = [instance returnArrayFromDatabase:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TEAMID = '%d' AND PreviouslyPlayed = 1",
                                 awayTeamID]];
    }
}

-(void)getTeamIDs{
    DatabaseController *instance = [[DatabaseController alloc]init];
    //Set away teamID to be used in second view controller for when adding players from database
    awayTeamID = [instance returnIntFromDatabase:[NSString stringWithFormat:
											  @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", awayTeam]];
    //Set home teamID to be used in second view controller for when adding players from database
    homeTeamID = [instance returnIntFromDatabase:[NSString stringWithFormat:
                                              @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", homeTeam]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
	//Button listener allocation
    [homeWonToss addTarget:self action:@selector(tossButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[awayWonToss addTarget:self action:@selector(tossButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[battingButton addTarget:self action:@selector(decisionButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[fieldingButton addTarget:self action:@selector(decisionButtonManage) forControlEvents:UIControlEventTouchUpInside];
	
	//Setting initial players table values
	homePlayersArray = [[NSMutableArray alloc] init];
	awayPlayersArray = [[NSMutableArray alloc] init];
	homeOutPlayers = [[NSMutableArray alloc] init];
	awayOutPlayers = [[NSMutableArray alloc] init];
	
    
    [self getTeamIDs];
    hID = homeTeamID;
    aID = awayTeamID;
    
    [self addHomePlayers];
    [self addAwayPlayers];
    	
	homeViceCaptain = 1;
	awayViceCaptain = 1;
	
	captainIcon = [UIImage imageNamed:@"CaptainIcon.png"];
	viceCaptainIcon = [UIImage imageNamed:@"ViceCaptainIcon.png"];
	wicketKeeperIcon = [UIImage imageNamed:@"WicketKeeperIcon.png"];
	captainWicketKeeper = [UIImage imageNamed:@"captainWicketKeeper.png"];
	viceCaptainWicketKeeper = [UIImage imageNamed:@"viceCaptainWicketKeeper.png"];
	battingTeam = @"home";
	tossWonBy = @"home";
	decision = @"bat";
}

- (void)viewDidAppear:(BOOL)animated {
    
    hID = homeTeamID;
    aID = awayTeamID;
    
    [self getTeamIDs];
    
    // IDs have changed so add new players
    if (hID != homeTeamID){
        [homePlayersArray removeAllObjects];
        [self addHomePlayers];        
    }
    
    if (aID != awayTeamID){
        [awayPlayersArray removeAllObjects];
        [self addAwayPlayers];
    }
    hID = homeTeamID;
    aID = awayTeamID;
    
    DatabaseController *instance = [[DatabaseController alloc] init];
    [instance firstTabSave];
    
	[homePlayersTable reloadData];
	[awayPlayersTable reloadData];
	if(disableElements){
		[homeWonToss setEnabled:NO];
		[awayWonToss setEnabled:NO];
		[battingButton setEnabled:NO];
		[fieldingButton setEnabled:NO];
		[homeNavBarAddButton setEnabled:NO];
		[homeNavBarEditButton setEnabled:NO];
		[awayNavBarAddButton setEnabled:NO];
		[awayNavBarEditButton setEnabled:NO];
	}
	
}


- (void)viewDidUnload
{
	[self setHomePlayersTable:nil];
	[self setAwayPlayersTable:nil];
	[self setHomeNavBarEditButton:nil];
	[self setAwayNavBarEditButton:nil];
	[self setHomeNavBarAddButton:nil];
	[self setAwayNavBarAddButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	[self setHomeWonToss:nil];
	[self setAwayWonToss:nil];
	[self setBattingButton:nil];
	[self setFieldingButton:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end