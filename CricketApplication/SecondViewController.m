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

@interface SecondViewController ()
@property (strong, nonatomic) IBOutlet UIButton *homeWonToss;
@property (strong, nonatomic) IBOutlet UIButton *awayWonToss;
@property (strong, nonatomic) IBOutlet UIButton *battingButton;
@property (strong, nonatomic) IBOutlet UIButton *fieldingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editHomePlayers;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editAwayPlayers;
@property (strong, nonatomic) IBOutlet UINavigationBar *homeNavBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeNavBarEditButton;

@end

@implementation SecondViewController
@synthesize homePlayersTable;
@synthesize awayPlayersTable;
@synthesize homeWonToss;
@synthesize awayWonToss;
@synthesize battingButton;
@synthesize fieldingButton;
@synthesize editHomePlayers;
@synthesize editAwayPlayers;
@synthesize homeNavBar;
@synthesize homeNavBarEditButton;
int homePlayersCount = 12;
int awayPlayersCount = 12;

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
	for (int i = 1; i < 12; i++){
		[homePlayersArray addObject:[NSString stringWithFormat:@"Player %d", i]];
		[awayPlayersArray addObject:[NSString stringWithFormat:@"Player %d", i]];
	}
}

- (void)viewDidUnload
{
	[self setHomePlayersTable:nil];
	[self setAwayPlayersTable:nil];
	[self setEditHomePlayers:nil];
	[self setEditAwayPlayers:nil];
	[self setHomeNavBar:nil];
	[self setHomeNavBarEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	[self setHomeWonToss:nil];
	[self setAwayWonToss:nil];
	[self setBattingButton:nil];
	[self setFieldingButton:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[homePlayersTable reloadData];
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
	
	if ([tableView isEqual:homePlayersTable])
    {
		cell.textLabel.text = [homePlayersArray objectAtIndex:indexPath.row];
	} else if ([tableView isEqual:awayPlayersTable]) {
		cell.textLabel.text = [awayPlayersArray objectAtIndex:indexPath.row];
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
	NSString *item = [homePlayersArray objectAtIndex:fromIndexPath.row];
	[homePlayersArray removeObject:item];
	[homePlayersArray insertObject:item atIndex:toIndexPath.row];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [homePlayersArray removeObjectAtIndex:indexPath.row];
		[homePlayersTable reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	rowForDetaiView = indexPath.row;
	DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
	[self.navigationController pushViewController:detail animated:YES];
	
	detail.PlayerEditTextBox.text = [homePlayersArray objectAtIndex:indexPath.row];
}

- (IBAction)EditTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[homePlayersTable setEditing:NO animated:NO];
		[homePlayersTable reloadData];
		homeNavBarEditButton.title = @"Edit";
		homeNavBarEditButton.style = UIBarButtonItemStylePlain;
	}
	else
	{
		[super setEditing:YES animated:YES];
		[homePlayersTable setEditing:YES animated:YES];
		[homePlayersTable reloadData];
		homeNavBarEditButton.title = @"Done";
		homeNavBarEditButton.style = UIBarButtonItemStyleDone;
	}
}

- (IBAction)AddCell:(id)sender {
	[homePlayersArray addObject:[NSString stringWithFormat:@"Player %d", homePlayersCount]];
	[homePlayersTable reloadData];
	homePlayersCount++;

}

- (void)tossButtonManage
{
    if (homeWonToss.selected)
	{
        [homeWonToss setSelected:NO];
		[awayWonToss setSelected:YES];
    }
    else
	{
        [homeWonToss setSelected:YES];
		[awayWonToss setSelected:NO];
    }
}

- (void)decisionButtonManage
{
    if (battingButton.selected)
	{
        [battingButton setSelected:NO];
		[fieldingButton setSelected:YES];
    }
    else
	{
        [battingButton setSelected:YES];
		[fieldingButton setSelected:NO];
    }
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end