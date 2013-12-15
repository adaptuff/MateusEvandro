//
//  ViewController.h
//  TesteBotoes
//
//  Created by Mateus Pelegrino on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "SocketManager.h"
#import "ButtonArray.h"
#import <AudioToolbox/AudioServices.h>


@protocol ViewControllerDelegate
- (NSMutableArray *)getButtonArray;
@end

@interface ViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    
    
    bool add;
    bool remove;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *removeButton;
    IBOutlet UIButton *doneButton;
    SocketManager *socket;
    GCDAsyncUdpSocket *udpSocket;
    IBOutlet UILabel *label;
	IBOutlet UILabel *labelStatus;
	IBOutlet UITextField *textoIp;
	IBOutlet UITextField *textoPorta;
	IBOutlet UIButton *button;
    NSMutableArray  *buttonArray;
    id <ViewControllerDelegate> delegate;
  //  ButtonArray *array;
}
    @property (nonatomic, retain) IBOutlet UIButton *addButton;
    @property (nonatomic, retain) IBOutlet UIButton *removeButton;
    @property (nonatomic, retain) IBOutlet UIButton *doneButton;
    @property (nonatomic, retain) SocketManager *socket;
    @property (nonatomic, retain) GCDAsyncUdpSocket *udpSocket;
  //  @property (nonatomic, retain) ButtonArray *array;
    @property (nonatomic, retain) IBOutlet UILabel *label;
    @property (nonatomic, retain) IBOutlet UILabel *labelStatus;
    @property (nonatomic, retain) IBOutlet UITextField *textoIp;
    @property (nonatomic, retain) IBOutlet UITextField *textoPorta;
    @property (nonatomic, retain) IBOutlet UIButton *button;
    @property (nonatomic, retain) NSMutableArray  *buttonArray;
    @property (nonatomic, assign) id  <ViewControllerDelegate> delegate; 
    
-(IBAction)textFieldShouldReturn:(id)sender;
+ (ViewController *)sharedController;
    

    
@end
