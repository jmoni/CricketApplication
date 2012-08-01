//
//  DetailViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *PlayerEditTextBox;
@property (strong, nonatomic) IBOutlet UISlider *battingOrderSlider;
@property (strong, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavBar;
@property (strong, nonatomic) IBOutlet UISwitch *CaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *ViceCaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *WicketKeeperSlider;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)battingOrderSliderChanged:(id)sender;
- (IBAction)battingOrderSliderChanging:(id)sender;
- (IBAction)getInitialSlideValue:(id)sender;
- (IBAction)CSlider:(id)sender;
- (IBAction)VCSlider:(id)sender;
- (IBAction)WKSlider:(id)sender;
@end
