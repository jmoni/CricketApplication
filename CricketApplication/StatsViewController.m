//
//  DetailViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "StatsViewController.h"
#include "SecondViewController.h"
#include "DatabaseController.h"

@interface StatsViewController ()

@end

int initialSliderValue;

@implementation StatsViewController
@synthesize playerEditTextBox;
@synthesize NavBar;
@synthesize CaptainSlider;
@synthesize ViceCaptainSlider;
@synthesize WicketKeeperSlider;
@synthesize ballsLabel;
@synthesize runsLabel;
@synthesize wayOutLabel;

- (IBAction)textFieldReturn:(id)sender
{
	[self changeArrayValue];
	[playerEditTextBox resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
	[self changeArrayValue];
	[playerEditTextBox resignFirstResponder];
}

- (void)changeArrayValue{
	[arrayForDetailView replaceObjectAtIndex:rowForDetaiView withObject:[playerEditTextBox text]];
}

- (IBAction)deletePlayer:(id)sender {
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@""
												message:[NSString stringWithFormat:@"Are you sure you want to delete %@", [playerEditTextBox text]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
	[mes show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self resignFirstResponder];
	}
	else
	{
		if(teamForDetailView == @"home"){
			if (homeCaptain >= buttonIndex) homeCaptain--;
			if (homeViceCaptain >= buttonIndex) homeViceCaptain--;
			if (homeWicketKeeper >= buttonIndex) homeWicketKeeper--;
		} else if(teamForDetailView == @"away"){
			if (awayCaptain >= buttonIndex) awayCaptain--;
			if (awayViceCaptain >= buttonIndex) awayViceCaptain--;
			if (awayWicketKeeper >= buttonIndex) awayWicketKeeper--;
		}
		[self resignFirstResponder];
		[arrayForDetailView removeObjectAtIndex:rowForDetaiView];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)nextPlayer:(id)sender {
	rowForDetaiView += 1;
	
	if ([teamForDetailView isEqualToString:@"home"]) {
		self.playerEditTextBox.text = [arrayForDetailView objectAtIndex:rowForDetaiView];
		if (homeCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (homeViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (homeWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	} else if ([teamForDetailView isEqualToString:@"away"]) {
		self.playerEditTextBox.text = [arrayForDetailView objectAtIndex:rowForDetaiView];
		if (awayCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (awayViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (awayWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	}
	[self viewDidLoad];
}

- (IBAction)previousPlayer:(id)sender {
	rowForDetaiView -= 1;
	if ([teamForDetailView isEqualToString:@"home"]) {
		self.playerEditTextBox.text = [homePlayersArray objectAtIndex:rowForDetaiView];
		if (homeCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (homeViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (homeWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	} else if ([teamForDetailView isEqualToString:@"away"]) {
		self.playerEditTextBox.text = [awayPlayersArray objectAtIndex:rowForDetaiView];
		if (awayCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (awayViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (awayWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	}
	[self viewDidLoad];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NavBar.title = [arrayForDetailView objectAtIndex:rowForDetaiView];
	if(disableElements){
		[playerEditTextBox setEnabled:NO];
		[CaptainSlider setEnabled:NO];
		[ViceCaptainSlider setEnabled:NO];
		[WicketKeeperSlider setEnabled:NO];
	}
}

- (void)viewDidUnload
{
	[self setPlayerEditTextBox:nil];
	[self setNavBar:nil];
	[self setCaptainSlider:nil];
	[self setViceCaptainSlider:nil];
	[self setWicketKeeperSlider:nil];
	[self setBallsLabel:nil];
	[self setRunsLabel:nil];
	[self setWayOutLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
