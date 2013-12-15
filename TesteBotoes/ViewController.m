//
//  ViewController.m
//  TesteBotoes
//
//  Created by Mateus Pelegrino on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

int contaBotoes;
int contaCliques;

@synthesize addButton;
@synthesize removeButton;
@synthesize doneButton;
@synthesize socket;
@synthesize udpSocket;
@synthesize label;
@synthesize labelStatus;
@synthesize textoIp;
@synthesize textoPorta;
@synthesize button;
@synthesize buttonArray;
@synthesize delegate;
//@synthesize array;

NSMutableArray *numberOfTouchesFromButton;
NSMutableArray *sizeOfButtons;
UITextField *dirField;
CGPoint ponto;
BOOL clicouConectar;
UIAlertView *alert;

static ViewController *sharedViewController = nil;


+ (ViewController *)sharedController {
    if (sharedViewController == nil) {
        sharedViewController = [[super allocWithZone:NULL] init];
    }
    return sharedViewController;
}


- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
    }
    return self;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedController] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  // denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

-(void)dealloc {
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    if(add && doneButton.enabled){
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        ponto = [touch locationInView:self.view];
        alert = [[UIAlertView alloc] initWithTitle:@"Set a button title:"
                                           message:@" "
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"OK", nil];
        [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
//        [alert setFrame:CGRectMake(1, 20, 2700, 400)];
        [alert show];
        
    }
    else{
        if ([socket isConnected]) {
            for (int i=0; i<allTouches.count; i++) {
                UITouch *touch = [[allTouches allObjects] objectAtIndex:i];
                ponto = [touch locationInView:self.view];
                NSData *data = [[NSString stringWithFormat:@"erro%d/%d",(int)ponto.x,(int)ponto.y] dataUsingEncoding:NSUTF8StringEncoding];
                [udpSocket sendData:data toHost:textoIp.text port:7590 /*[textoPorta.text stringByAppendingString:@"1"]*/ withTimeout:-1 tag:1];
            }
        }
    }
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        UIButton *botao = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        botao.frame = CGRectMake(ponto.x-25, ponto.y-25, 50, 50);
        [botao setBackgroundColor:[UIColor whiteColor]];
        NSString *textField = [alert textFieldAtIndex:0].text;
        [botao setTitle:[NSString stringWithFormat: @"%@", textField] forState:UIControlStateNormal];
    //    [textField release];
        [botao setTag:contaBotoes];
        contaBotoes++;
        [botao addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
//        [botao addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDragEnter];
    //    [botao addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchDragInside];
//        [botao addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventValueChanged];
        [botao addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchDragExit];
//        [botao addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDragOutside];
        [botao addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [botao addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchCancel];
        
        
        [self.view addSubview:botao];
        add = false;
        [addButton setAlpha:1.0];
        [self.view addSubview:addButton];
        [addButton setEnabled:true];
        [removeButton setAlpha:1.0];
        [self.view addSubview:removeButton];
        [removeButton setEnabled:true];
        [self.view addSubview:doneButton];
        [buttonArray addObject:botao];
        NSNumber* zero = [NSNumber numberWithInt:0];
        [numberOfTouchesFromButton addObject: zero];
        NSNumber* one = [NSNumber numberWithInt:1];
        [sizeOfButtons addObject: one];
       // [zero release];
    }
    else
    {
        add = false;
        [addButton setAlpha:1.0];
        [self.view addSubview:addButton];
        [addButton setEnabled:true];
        [removeButton setAlpha:1.0];
        [self.view addSubview:removeButton];
        [removeButton setEnabled:true];
        [self.view addSubview:doneButton];
    }
}


- (IBAction)buttonClicked:(id)sender
{
    if([sender tag] == 1){ // add button
        add = true;
        [addButton setAlpha:0.0];
        [addButton setEnabled:false];
        [removeButton setAlpha:0.0];
        [removeButton setEnabled:false];
    }
    else{
        if([sender tag ] == 2){ //remove button
            remove = true;
            [addButton setAlpha:0.0];
            [addButton setEnabled:false];
            [removeButton setAlpha:0.0];
            [removeButton setEnabled:false];
        }
        else{
            if([sender tag] == 3){ // Done button on edit phase
                [addButton setAlpha:0.0f];
                [addButton setEnabled:false];
                [removeButton setEnabled:false];
                [removeButton setAlpha:0.0f];
                [label setEnabled:true];
                [label setAlpha:1.0f];
                [self.view addSubview:label];
                [labelStatus setEnabled:true];
                [labelStatus setAlpha:1.0f];
                [self.view addSubview:labelStatus];
                [textoIp setEnabled:true];
                [textoIp setAlpha:1.0f];
                [self.view addSubview:textoIp];
                [textoPorta setEnabled:true];
                [textoPorta setAlpha:1.0f];
                [self.view addSubview:textoPorta];
                [doneButton setTitle:@"OK" forState:UIControlStateNormal];
                [doneButton setTag:4];
                
            }
            
            else{
                if(remove && ([doneButton tag]== 3)){ //text button clicked to be deleted
                    remove = false;
                    int index = [buttonArray indexOfObject:sender];
                    [numberOfTouchesFromButton removeObjectAtIndex:index];
                    [sizeOfButtons removeObjectAtIndex:index];
                    [buttonArray removeObject:sender];
                    [sender removeFromSuperview];
                    [addButton setAlpha:1.0];
                    [removeButton setAlpha:1.0];
                    [addButton setEnabled:true];
                    [removeButton setEnabled:true];
                }
                else{
                    if([sender tag] == 4){ //Try to connect
                        if(!clicouConectar){
                            
                            [socket connect:[textoIp text] porta:@"7589"];//[textoPorta text]];
                            [textoIp setAlpha:0];
                            [textoPorta setAlpha:0];
                            [label setAlpha:0];
                            clicouConectar = TRUE;
                            CGRect screenRect = [[UIScreen mainScreen] bounds];
                            CGFloat screenWidth = screenRect.size.width;
                            CGFloat screenHeight = screenRect.size.height;
                            NSMutableString *dadosIniciais = [NSMutableString stringWithFormat:@"%d/%d", (int)screenHeight, (int)screenWidth];
                            UIButton *botaoAux;
                            for (int i = 0; i < [buttonArray count]; i++) {
                                botaoAux = [buttonArray objectAtIndex:i];
                                [dadosIniciais appendFormat:@"%@%d%d%f",botaoAux.titleLabel.text,(int)botaoAux.center.x, (int)botaoAux.center.y,(float)sqrt(pow(botaoAux.bounds.size.width - botaoAux.bounds.size.width/2,2) + pow(botaoAux.bounds.size.height - botaoAux.bounds.size.height/2,2))];
                            }
                            [socket sendString:[NSString stringWithString:dadosIniciais]];
                            
                        }
                        else { // try to disconnect
                            [socket sendString:[NSString stringWithFormat:@"exit"]];
                            NSData *data = [[NSString stringWithFormat:@"exit"] dataUsingEncoding:NSUTF8StringEncoding];
                            [udpSocket sendData:data toHost:textoIp.text port:7590 /*[textoPorta.text stringByAppendingString:@"1"]*/ withTimeout:-1 tag:1];
                            [socket disconnect];
                            clicouConectar = FALSE;
                            [addButton setAlpha:1];
                            [addButton setEnabled:true];
                            [removeButton setEnabled:true];
                            [removeButton setAlpha:1];
                            [label setEnabled:false];
                            [label setAlpha:0.0f];
                            [doneButton setTag:3];
                            [doneButton setTitle:@"OK" forState:UIControlStateNormal];
                            [labelStatus setAlpha:0];
                            
                            
                        }
                    }
                    else{ // button clicked to send OTA
                        if(clicouConectar){
                            if([sender tag]!= 4){
                                if([socket isConnected]){
                                UIButton *button = (UIButton *)sender;
//                                [socket sendString:[NSString stringWithFormat:@"pull%@\n", [button titleLabel].text]];
                                  //send udp data
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                    NSData *data = [[NSString stringWithFormat:@"pull%@", [button titleLabel].text] dataUsingEncoding:NSUTF8StringEncoding];
                                    [udpSocket sendData:data toHost:textoIp.text port:7590 /*[textoPorta.text stringByAppendingString:@"1"]*/ withTimeout:-1 tag:1];
                //                    [data release];
                                    
                                int index = [buttonArray indexOfObject:button];
                                int value = [[numberOfTouchesFromButton objectAtIndex:index] intValue];
                                value++;
                                NSNumber* valueChanged = [NSNumber numberWithInt:value];
                                [numberOfTouchesFromButton replaceObjectAtIndex:index withObject:valueChanged];
                                contaCliques++;
                                if(contaCliques == 10){
                                    float average;
                                    int sizeOfButton;
                                    for (int i = 0; i<[numberOfTouchesFromButton count]; i++) {
                                        average = [[numberOfTouchesFromButton objectAtIndex:i] floatValue]/10;
                                        sizeOfButton = [[sizeOfButtons objectAtIndex:i] intValue];
                                        NSNumber* zero = [NSNumber numberWithInt:0];
                                        [numberOfTouchesFromButton replaceObjectAtIndex:i withObject:zero];
                              //          [zero release];
                                        NSLog(@"%f",average);
                                        if(average >= 0.4f && sizeOfButton <= 2){
                                            UIButton *button = [buttonArray objectAtIndex:i];
                                            [button setFrame:CGRectMake(button.center.x - (button.frame.size.width+10)/2, button.center.y - (button.frame.size.width+10)/2, button.frame.size.width+10, button.frame.size.height +10)];
                                            [buttonArray replaceObjectAtIndex:i withObject:button];
                                            sizeOfButton++;
                                            NSNumber *sizeNumber = [NSNumber numberWithInt:sizeOfButton];
                                            [sizeOfButtons replaceObjectAtIndex:i withObject:sizeNumber];
                                        }
                                    }
                                    contaCliques =0;
                                }
                            }
                        }
                        }
                    }
                }
            }
        }
    }
    
}


-(IBAction)buttonReleased:(id)sender{
    if([sender tag] == 4){
        wait((int *)20);
        if([socket isConnected]){
            [labelStatus setText:@"Status: Conectado"];
            [doneButton setTitle: @"Desconectar" forState: UIControlStateNormal];
        }
        else {
            [labelStatus setText:@"Status: Desconectado"];
            [doneButton setTitle: @"Ok" forState: UIControlStateNormal];
        }
        
    }
    else{
        if([sender tag] >=5){
            if(clicouConectar){
                if([socket isConnected]){
//Vibracao tava aqui
                    UIButton *button = (UIButton *)sender;
                    NSData *data = [[NSString stringWithFormat:@"push%@", [button titleLabel].text] dataUsingEncoding:NSUTF8StringEncoding];
                    [udpSocket sendData:data toHost:textoIp.text port:7590 /*[textoPorta.text stringByAppendingString:@"1"] */withTimeout:-1 tag:1];
           //         [data release];
                    //     [socket sendString:[NSString stringWithFormat:@"push%@\n", [button titleLabel].text]];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    contaBotoes =5;
    contaCliques = 0;
    add = false;
    remove = false;
    socket = [[SocketManager alloc] initSocketManager];
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	clicouConectar = FALSE;
    [label setEnabled:false];
    [label setAlpha:0.0f];
    [labelStatus setEnabled:false];
    [labelStatus setAlpha:0.0f];
    [textoIp setEnabled:false];
    [textoIp setAlpha:0.0f];
    [textoPorta setEnabled:false];
    [textoPorta setAlpha:0.0f];
    [textoIp setDelegate:self];
    [textoPorta setDelegate:self];
    //  array =[ButtonArray getInstance];
    buttonArray = [[NSMutableArray alloc] init];
    numberOfTouchesFromButton = [[NSMutableArray alloc] init];
    sizeOfButtons = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    contaBotoes = -1;
    [socket disconnect];
    //  [socket release];
    [doneButton setEnabled:true];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)textFieldShouldReturn:(id)sender {
    [sender resignFirstResponder];
    //  return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
@end
