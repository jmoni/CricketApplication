//
//  ThirdViewController.h
//  CricketApplication
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>{
    

}
@property (strong, nonatomic) IBOutlet UILabel *overTotal;
@property (strong, nonatomic) IBOutlet UILabel *fallOfWickets;
@property (strong, nonatomic) IBOutlet UIButton *bowlerButton;

-(IBAction)showActionSheet: (id) sender;
-(IBAction)hideActionSheet: (UIBarButtonItem *)_infoButtonItem;
-(IBAction)hideActionSheetB:(id)sender;
-(IBAction)showOutOptions:(id)sender;
-(IBAction)showExtrasOptions:(id)sender;
-(IBAction)noRuns:(id)sender;
-(IBAction)plusOne:(id)sender;
-(IBAction)four:(id)sender;
-(IBAction)six:(id)sender;
-(IBAction)confirm:(id)sender;
@end