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
#include "DatabaseController.h"
#include "FirstViewController.h"

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

    
    [self getTeamIDs];
    hID = homeTeamID;
    aID = awayTeamID;
    
    [self addHomePlayers];
    [self addAwayPlayers];
    
    NSLog(@"The first time the view loaded h = %d , a = %d",hID,aID);
      
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

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"APPEAR!");
    
    NSLog(@"In appear the view loaded h = %d , a = %d",hID,aID);
    
    
    hID = homeTeamID;
    aID = awayTeamID;
    
    NSLog(@"In appear second the view loaded h = %d , a = %d",hID,aID);
    [self getTeamIDs];
    
    if (hID != homeTeamID){
        [homePlayersArray removeAllObjects];
        [self addHomePlayers];
        NSLog(@"Reload home");
        
    }
    
    if (aID != awayTeamID){
        [awayPlayersArray removeAllObjects];
        [self addAwayPlayers];
          NSLog(@"Reload away");
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
	}

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int cellNumber = 0;
	if ([tableView isEqual:homePlayersTable]) cellNumber = [homePlayersArray count];
	else if ([tableView isEqual:awayPlayersTable]) cellNumber = [awayPlayersArray count];
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
	} else if ([tableView isEqual:awayPlayersTable]) {
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
		} else
			[cell setAccessoryView:nil];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
    return cell;
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete && [tableView isEqual:homePlayersTable]) {
        [homePlayersArray removeObjectAtIndex:indexPath.row];
		[homePlayersTable reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleDelete && [tableView isEqual:awayPlayersTable]) {
        [awayPlayersArray removeObjectAtIndex:indexPath.row];
		[awayPlayersTable reloadData];
    }
}

//Selected row open up detail view page
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	rowForDetaiView = indexPath.row;
	DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
	
	if ([tableView isEqual:homePlayersTable]) {
		arrayForDetailView = homePlayersArray;
		teamForDetailView = @"home";
	} else if ([tableView isEqual:awayPlayersTable]) {
		arrayForDetailView = awayPlayersArray;
		teamForDetailView = @"away";
	}

	[self.navigationController pushViewController:detail animated:YES];
	
	if ([tableView isEqual:homePlayersTable]) {
		detail.playerEditTextBox.text = [homePlayersArray objectAtIndex:indexPath.row];
		if (homeCaptain == indexPath.row)
			[detail.CaptainSlider setOn:YES animated:YES];
		else if (homeViceCaptain == indexPath.row)
			[detail.ViceCaptainSlider setOn:YES animated:YES];
		if (homeWicketKeeper == indexPath.row)
			[detail.WicketKeeperSlider setOn:YES animated:YES];
	} else if ([tableView isEqual:awayPlayersTable]) {
		detail.playerEditTextBox.text = [awayPlayersArray objectAtIndex:indexPath.row];
		if (awayCaptain == indexPath.row)
			[detail.CaptainSlider setOn:YES animated:YES];
		else if (awayViceCaptain == indexPath.row)
			[detail.ViceCaptainSlider setOn:YES animated:YES];
		if (awayWicketKeeper == indexPath.row)
			[detail.WicketKeeperSlider setOn:YES animated:YES];
	}
	detail.battingOrderSlider.value = indexPath.row+1.9;
	detail.sliderValueLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (IBAction)accessoryButtonPressed:(id)sender tableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
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
	} else if ([sender isEqual:awayNavBarAddButton]) {
		[awayPlayersArray addObject:[NSString stringWithFormat:@"Player %d", awayPlayersCount]];
		[awayPlayersTable reloadData];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//Add Home Players
-(void) addHomePlayers{
    //Get the TeamID home team (greater than 0) from the database if there are already players on the team and if not set to -1
    
    NSLog(@"%d", homeTeamID);
    
    int c = [self returnIntFromDatabase:[NSString stringWithFormat:
                                         @"SELECT TeamID FROM PLAYERS WHERE TeamID = '%d'",
                                         homeTeamID]];
    //Players aren't in database - hometeam
    if (c == -1){
        for (int i = 1; i < 12; i++){
            [homePlayersArray addObject:[NSString stringWithFormat:@"Player %d", i]];
        }
    }
    //Players are in database - hometeam
    else{
        [self returnPlayersHome:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TEAMID = '%d'",
                                 homeTeamID]];
    }
}


//Add Away Players
-(void) addAwayPlayers{
    //Get the TeamID away team (greater than 0) from the database if there are already players on the team and if not set to -1
    int c = [self returnIntFromDatabase:[NSString stringWithFormat:
                                     @"SELECT TeamID FROM PLAYERS WHERE TeamID = '%d'",
                                     awayTeamID]];
    //Players aren't in database - awayteam
    if (c == -1){
        for (int i = 1; i < 12; i++){
            [awayPlayersArray addObject:[NSString stringWithFormat:@"Player %d", i]];
        }
    }
    //Players are in database - hometeam
    else{
        [self returnPlayersAway:[NSString stringWithFormat:@"SELECT PlayerName FROM Players WHERE TEAMID = '%d'",
                                 awayTeamID]];
    }
}

//Call function to reload home team players from database
- (void)returnPlayersHome:(NSString *)string {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Put players into home array
            [homePlayersArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

//Call function to reload away team players from database
- (void)returnPlayersAway:(NSString *)string {
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
            //Put players into away array
            [awayPlayersArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
}

//Return an int from the database (an id)s
- (int)returnIntFromDatabase:(NSString *)string {
	int returnThis = -1;
	const char *dbpath = [writableDBPath UTF8String];
	sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSLog(@"\nAccess worked");
			returnThis = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		sqlite3_close(cricketDB);
	} else {
		NSLog(@"\nCould not access DB");
	}
	return returnThis;
}

-(void) getTeamIDs{
    //Set away teamID to be used in second view controller for when adding players from database
    awayTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
											  @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", awayTeam]];
    //Set home teamID to be used in second view controller for when adding players from database
    homeTeamID = [self returnIntFromDatabase:[NSString stringWithFormat:
                                              @"SELECT TeamID FROM TEAMS WHERE TeamName = '%@'", homeTeam]];
}

@end