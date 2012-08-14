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
@synthesize playerNames;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playerNames count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MyCutstomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    // Set the values in the table
    cell.lblName.text = [playerNames objectAtIndex:indexPath.row];
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
    
    //Creates the string for the title of the first team's innings
    NSString *a = @"Innings ";
    if (battingTeam == @"home") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,homeTeam];
    else if (battingTeam == @"away") _firstTeamBatTitle.text = [NSString stringWithFormat:@"%@%@",a,awayTeam];
    
    
    // Do any additional setup after loading the view.
    
    //Get the players names
    if (battingTeam == @"home") playerNames = [[NSArray alloc] initWithArray:homePlayersArray];
	else if (battingTeam == @"away") playerNames = [[NSArray alloc] initWithArray:awayPlayersArray];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    int c = currentGameID;
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
