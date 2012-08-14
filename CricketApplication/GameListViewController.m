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
	instance = [[DatabaseController alloc] init];
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
	if (section == 1 && [gamesInDatabase count] > 0) return @"Game Summary";
	else if (section == 0 && [gamesInProgressInDatabase count] > 0) return @"Games in Progress";
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
	for (int i = 0; i < [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] length]; i++){
		unichar ch = [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] characterAtIndex:i];
		if (ch == '$') {
			if (indexPath.section == 1)
				[[cell textLabel] setText:[NSString stringWithFormat:@"%@", [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] substringFromIndex:i+1]]];
			else if (indexPath.section == 0)
				[[cell textLabel] setText:[NSString stringWithFormat:@"%@", [[gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row] substringFromIndex:i+1]]];
			
		}
	}
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
		if (indexPath.section == 1){
			for (int i = 0; i < [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] length]; i++){
				unichar ch = [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] characterAtIndex:i];
				if (ch == '$') {
						[instance removeGameInDatabase:
						 [[NSString stringWithFormat:@"%@", [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] substringToIndex:i]] integerValue]];
				}
			}
		} else if (indexPath.section == 0){
			for (int i = 0; i < [[gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row] length]; i++){
				unichar ch = [[gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row] characterAtIndex:i];
				if (ch == '$') {
					[instance removeGameInDatabase:
					 [[NSString stringWithFormat:@"%@", [[gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row] substringToIndex:i]] integerValue]];
				}
			}
		}
		//[instance removeGameInDatabase:(int)[gamesInDatabase objectAtIndex:indexPath.row]];
        //[gamesInDatabase removeObjectAtIndex:indexPath.row];
		[self viewDidAppear:YES];
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
	for (int i = 0; i < [[gamesInDatabase objectAtIndex:indexPath.row] length]; i++){
		unichar ch = [[gamesInDatabase objectAtIndex:indexPath.row] characterAtIndex:i];
		if (ch == '$') {
			if (indexPath.section == 1)
				currentGameID = [[NSString stringWithFormat:@"%@", [[gamesInDatabase objectAtIndex:[gamesInDatabase count]-1-indexPath.row] substringToIndex:i]] integerValue];
			else if (indexPath.section == 0)
				currentGameID = [[NSString stringWithFormat:@"%@", [[gamesInProgressInDatabase objectAtIndex:[gamesInProgressInDatabase count]-1-indexPath.row] substringToIndex:i]] integerValue];
		}
	}
	NSLog(@"%d", currentGameID);
    if (indexPath. section == 1){
		ScoreViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Score Card"];
		[self.navigationController pushViewController:detailViewController animated:YES];
	} else {
		disableElements = YES;
		loadElements = YES;
		DatabaseController *tabView = [self.storyboard instantiateViewControllerWithIdentifier:@"Database Controller"];
		[self.navigationController pushViewController:tabView animated:YES];
	}
	
}

- (IBAction)addNewGame:(id)sender{
	disableElements = NO;
	loadElements = NO;
	DatabaseController *tabView = [self.storyboard instantiateViewControllerWithIdentifier:@"Database Controller"];
	[self.navigationController pushViewController:tabView animated:YES];
}

- (void)showScoreScreenWithGameID:(int)GameID{
	ScoreViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Score Card"];
	[self.navigationController pushViewController:detailViewController animated:YES];
	//show game for parsed gameID
}

@end
