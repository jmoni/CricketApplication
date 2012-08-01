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
	[homePlayersTable reloadData];
	[awayPlayersTable reloadData];
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
	if([tableView isEqual:homePlayersTable]) {
		NSString *item = [homePlayersArray objectAtIndex:fromIndexPath.row];
		[homePlayersArray removeObject:item];
		[homePlayersArray insertObject:item atIndex:toIndexPath.row];
	} else if ([tableView isEqual:awayPlayersTable]) {
		NSString *item = [awayPlayersArray objectAtIndex:fromIndexPath.row];
		[awayPlayersArray removeObject:item];
		[awayPlayersArray insertObject:item atIndex:toIndexPath.row];
	}
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	rowForDetaiView = indexPath.row;
	DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
	
	if ([tableView isEqual:homePlayersTable])
		arrayForDetailView = homePlayersArray;
	else if ([tableView isEqual:awayPlayersTable])
		arrayForDetailView = awayPlayersArray;

	[self.navigationController pushViewController:detail animated:YES];
	
	if ([tableView isEqual:homePlayersTable])
		detail.PlayerEditTextBox.text = [homePlayersArray objectAtIndex:indexPath.row];
	else if ([tableView isEqual:awayPlayersTable])
		detail.PlayerEditTextBox.text = [awayPlayersArray objectAtIndex:indexPath.row];
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