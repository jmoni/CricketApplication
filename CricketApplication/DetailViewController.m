//
//  DetailViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "DetailViewController.h"
#include "SecondViewController.h"

@interface DetailViewController ()

@end

int initialSliderValue;

@implementation DetailViewController
@synthesize playerEditTextBox;
@synthesize battingOrderSlider;
@synthesize sliderValueLabel;
@synthesize NavBar;
@synthesize CaptainSlider;
@synthesize ViceCaptainSlider;
@synthesize WicketKeeperSlider;
@synthesize previousPlayerButton;
@synthesize nextPlayerButton;

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
		[self resignFirstResponder];
		[arrayForDetailView removeObjectAtIndex:rowForDetaiView];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)nextPlayer:(id)sender {
	rowForDetaiView += 1;
	
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
	self.battingOrderSlider.value = rowForDetaiView+1.9;
	self.sliderValueLabel.text = [NSString stringWithFormat:@"%d", rowForDetaiView+1];
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
	self.battingOrderSlider.value = rowForDetaiView+1.9;
	self.sliderValueLabel.text = [NSString stringWithFormat:@"%d", rowForDetaiView+1];
	[self viewDidLoad];
}

- (IBAction)battingOrderSliderChanged:(id)sender {
	//NSLog([NSString stringWithFormat:@"after function: %d", initialSliderValue]);
	NSString *item = [arrayForDetailView objectAtIndex:(initialSliderValue-1)];
	[arrayForDetailView removeObject:item];
	[arrayForDetailView insertObject:item atIndex:(int)([battingOrderSlider value]-1)];
	if ([teamForDetailView isEqualToString:@"home"]) {
		if (homeCaptain == (initialSliderValue-1)) {
			homeCaptain = (int)([battingOrderSlider value]-1);
		} else if (homeCaptain > (initialSliderValue-1) && homeCaptain <= (int)([battingOrderSlider value]-1)) {
			homeCaptain--;
		} else if (homeCaptain < (initialSliderValue-1) && homeCaptain >= (int)([battingOrderSlider value]-1)) {
			homeCaptain++;
		}
		if (homeViceCaptain == (initialSliderValue-1)) {
			homeViceCaptain = (int)([battingOrderSlider value]-1);
		} else if (homeViceCaptain > (initialSliderValue-1) && homeViceCaptain <= (int)([battingOrderSlider value]-1)) {
			homeViceCaptain--;
		} else if (homeViceCaptain < (initialSliderValue-1) && homeViceCaptain >= (int)([battingOrderSlider value]-1)) {
			homeViceCaptain++;
		}
		if (homeWicketKeeper == (initialSliderValue-1)) {
			homeWicketKeeper = (int)([battingOrderSlider value]-1);
		}else if (homeWicketKeeper > (initialSliderValue-1) && homeWicketKeeper <= (int)([battingOrderSlider value]-1)) {
			homeWicketKeeper--;
		} else if (homeWicketKeeper < (initialSliderValue-1) && homeWicketKeeper >= (int)([battingOrderSlider value]-1)) {
			homeWicketKeeper++;
		}
	} else {
		if (awayCaptain == (initialSliderValue-1)) {
			awayCaptain = (int)([battingOrderSlider value]-1);
		} else if (awayCaptain > (initialSliderValue-1) && awayCaptain <= (int)([battingOrderSlider value]-1)) {
			awayCaptain--;
		} else if (awayCaptain < (initialSliderValue-1) && awayCaptain >= (int)([battingOrderSlider value]-1)) {
			awayCaptain++;
		}
		if (awayViceCaptain == (initialSliderValue-1)) {
			awayViceCaptain = (int)([battingOrderSlider value]-1);
		} else if (awayViceCaptain > (initialSliderValue-1) && awayViceCaptain <= (int)([battingOrderSlider value]-1)) {
			awayViceCaptain--;
		} else if (awayViceCaptain < (initialSliderValue-1) && awayViceCaptain >= (int)([battingOrderSlider value]-1)) {
			awayViceCaptain++;
		}
		if (awayWicketKeeper == (initialSliderValue-1)) {
			awayWicketKeeper = (int)([battingOrderSlider value]-1);
		}else if (awayWicketKeeper > (initialSliderValue-1) && awayWicketKeeper <= (int)([battingOrderSlider value]-1)) {
			awayWicketKeeper--;
		} else if (awayWicketKeeper < (initialSliderValue-1) && awayWicketKeeper >= (int)([battingOrderSlider value]-1)) {
			awayWicketKeeper++;
		}
	}
	rowForDetaiView = (int)([battingOrderSlider value]-1);
}

- (IBAction)battingOrderSliderChanging:(id)sender {
	sliderValueLabel.text = [NSString stringWithFormat:@"%d", (int)[battingOrderSlider value]];
}

- (IBAction)getInitialSlideValue:(id)sender {
	//NSLog([NSString stringWithFormat:@"%d", (int)[battingOrderSlider value]]);
	initialSliderValue = (int)[battingOrderSlider value];
}

- (IBAction)CSlider:(id)sender {
	if (CaptainSlider.on) {
		[ViceCaptainSlider setOn:NO animated:YES];
		if ([teamForDetailView isEqualToString:@"home"])
			homeCaptain = (int)[battingOrderSlider value]-1;
		else
			awayCaptain = (int)[battingOrderSlider value]-1;
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeCaptain == (int)[battingOrderSlider value]-1)
				homeCaptain = -1;
		} else {
			if (awayCaptain == (int)[battingOrderSlider value]-1)
				awayCaptain = -1;
		}
	}
}
- (IBAction)VCSlider:(id)sender {
	if (ViceCaptainSlider.on) {
		[CaptainSlider setOn:NO animated:YES];
		if ([teamForDetailView isEqualToString:@"home"])
			homeViceCaptain = (int)[battingOrderSlider value]-1;
		else
			awayViceCaptain = (int)[battingOrderSlider value]-1;
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeViceCaptain == (int)[battingOrderSlider value]-1)
				homeViceCaptain = -1;
		} else {
			if (awayViceCaptain == (int)[battingOrderSlider value]-1)
				awayViceCaptain = -1;
		}
	}
}
- (IBAction)WKSlider:(id)sender {
	if (WicketKeeperSlider.on) {
		if ([teamForDetailView isEqualToString:@"home"])
			homeWicketKeeper = (int)[battingOrderSlider value]-1;
		else
			awayWicketKeeper = (int)[battingOrderSlider value]-1;
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeWicketKeeper == (int)[battingOrderSlider value]-1)
				homeWicketKeeper = -1;
		} else {
			if (awayWicketKeeper == (int)[battingOrderSlider value]-1)
				awayWicketKeeper = -1;
		}
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NavBar.title = [arrayForDetailView objectAtIndex:rowForDetaiView];
	[battingOrderSlider setMaximumValue:([arrayForDetailView count]+0.9)];
	if (rowForDetaiView == 0){
		[previousPlayerButton setEnabled:NO];
	} else {
		[previousPlayerButton setEnabled:YES];
	}
	if (rowForDetaiView == [arrayForDetailView count]-1){
		[nextPlayerButton setEnabled:NO];
	} else {
		[nextPlayerButton setEnabled:YES];
	}
}

- (void)viewDidUnload
{
	[self setPlayerEditTextBox:nil];
	[self setNavBar:nil];
	[self setCaptainSlider:nil];
	[self setViceCaptainSlider:nil];
	[self setWicketKeeperSlider:nil];
	[self setBattingOrderSlider:nil];
	[self setSliderValueLabel:nil];
	[self setNextPlayerButton:nil];
	[self setPreviousPlayerButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
