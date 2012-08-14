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
#import "DatabaseController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize firstTeamBatTitle = _firstTeamBatTitle;
@synthesize tableOfPlayers = _tableOfPlayers;
@synthesize playerNamesHome;
@synthesize playerNamesAway;

int gameID;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 && battingTeam == @"home") return [NSString stringWithFormat:@"First Innings : %@",homeTeam];
    else if (section == 0 && battingTeam == @"away") return [NSString stringWithFormat:@"First Innings : %@",awayTeam];
    else if (section == 1 && battingTeam == @"home") return [NSString stringWithFormat:@"Second Innings : %@",awayTeam];
    else if (section == 1 && battingTeam == @"away") return [NSString stringWithFormat:@"Second Innings : %@",homeTeam];
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     int cellNumber = 0;
     if ([tableView isEqual:homePlayersTable] && section == 1) cellNumber = [homePlayersArray count];
     else if ([tableView isEqual:awayPlayersTable] && section == 1) cellNumber = [awayPlayersArray count];
     */
    if (battingTeam == @"home") return [playerNamesHome count];
    else if (battingTeam == @"away") return [playerNamesAway count];
    else return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MyCutstomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    // Set the values in the table
    
    if (indexPath.section == 0){
        if (battingTeam == @"home") cell.lblName.text = [playerNamesHome objectAtIndex:indexPath.row];
        else cell.lblName.text = [playerNamesAway objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1){
        if (battingTeam == @"home") cell.lblName.text = [playerNamesAway objectAtIndex:indexPath.row];
        else cell.lblName.text = [playerNamesHome objectAtIndex:indexPath.row];
    }
    
    cell.lblR.text = @"R";
    cell.lblM.text = @"M";
    cell.lblB.text = @"B";
    cell.lbl4s.text =@"4";
    cell.lbl6s.text =@"6";
    cell.lblSR.text =@"SR";
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
    
    gameID = 0;
    
    //Creates the string for the title of the first team's innings
    NSString *a = @"Innings ";
    if (battingTeam == @"home") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,homeTeam];
    else if (battingTeam == @"away") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,awayTeam];
    
    
    // Do any additional setup after loading the view.
    
    //Get the players names
    playerNamesHome = [[NSArray alloc] initWithArray:homePlayersArray];
	playerNamesAway = [[NSArray alloc] initWithArray:awayPlayersArray];
    


}

- (void)viewDidAppear:(BOOL)animated{
   // int c = currentGameID;
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
