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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)battingOrderSliderChanged:(id)sender {
	//NSLog([NSString stringWithFormat:@"after function: %d", initialSliderValue]);
	NSString *item = [arrayForDetailView objectAtIndex:(initialSliderValue-1)];
	[arrayForDetailView removeObject:item];
	[arrayForDetailView insertObject:item atIndex:(int)([battingOrderSlider value]-1)];
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

	}
}
- (IBAction)VCSlider:(id)sender {
	if (ViceCaptainSlider.on) {
		[CaptainSlider setOn:NO animated:YES];

	}
}
- (IBAction)WKSlider:(id)sender {
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NavBar.title = [arrayForDetailView objectAtIndex:rowForDetaiView];
	[battingOrderSlider setMaximumValue:([arrayForDetailView count]+0.9)];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
