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

-(IBAction)showActionSheet: (id) sender;
-(IBAction)hideActionSheet: (UIBarButtonItem *)_infoButtonItem;
-(IBAction)hideActionSheetB:(id)sender;
-(IBAction)showOutOptions:(id)sender;

@end