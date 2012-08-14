//
//  GameListViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 13/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "GameListViewController.h"
#include "DatabaseController.h"
#include "scoreViewController.h"

@interface GameListViewController ()

@end

DatabaseController *instance;

@implementation GameListViewController
@synthesize mainTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	gamesInDatabase = [[NSMutableArray alloc] init];
	gamesInProgressInDatabase = [[NSMutableArray alloc] init];
	//next two lines in view did appear instead
	//instance = [[DatabaseController alloc] init];
	//[instance retrieveGamesInDatabase];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
	instance = [[DatabaseController alloc] init];
	[instance retrieveGamesInDatabaseWithFinishedStatus:0];
	[instance retrieveGamesInDatabaseWithFinishedStatus:1];
	[mainTableView reloadData];
}

- (void)viewDidUnload
{
	[self setMainTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 1 && [gamesInDatabase count] > 0) return @"Old Games";
	else if (section == 0 && [gamesInProgressInDatabase count] > 0) return @"Current Games";
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if(section == 1) return [gamesInDatabase count];
	else return [gamesInProgressInDatabase count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	[[cell textLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    if (indexPath.section == 1)
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@", [gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row]]];
	else if (indexPath.section == 0)
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@", [gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row]]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[instance removeGameInDatabase:indexPath.row];
        [gamesInDatabase removeObjectAtIndex:indexPath.row];
		[tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
	ScoreViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Score Card"];
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	
}

- (IBAction)addNewGame:(id)sender{
	DatabaseController *tabView = [self.storyboard instantiateViewControllerWithIdentifier:@"Database Controller"];
	[self.navigationController pushViewController:tabView animated:YES];
}

- (void)showScoreScreenWithGameID:(int)GameID{
	ScoreViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Score Card"];
	[self.navigationController pushViewController:detailViewController animated:YES];
	//show game for parsed gameID
}

@end
