//  /Library/webserver/documents/ipad/inserir_coordenada.php LEMBRAR!
//  HTTPConnection.m
//  TestePontos
//  Created by Mateus Pelegrino on 07/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.

//TCP/ip Mode

#import "SocketManager.h"
#import "ViewController.h"

@implementation SocketManager
@synthesize socket;
@synthesize dadoEscrito;
ButtonArray *array;
NSMutableData *imgData;

-(SocketManager *)initSocketManager {
	if(self = [super init])
	{    
    
	socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	}
	return self;
}

-(void) disconnect {
	if([socket isConnected])
		[socket disconnect];
}

-(BOOL) isConnected {
	return [socket isConnected];
	
}
-(void) connect:(NSString *)ip porta:(NSString *)porta {
	if (![socket isConnected]) {
        [socket disconnect];
		BOOL connected = [socket connectToHost:ip onPort:[porta integerValue] error:nil];
		if (connected) {
            NSLog(@"SocketManager:Conectando a: %@", ip);
			[socket readDataWithTimeout:-1 tag:0];
		}
		
	}
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connectado ao server %@:%hu", host, port);
    [[[[UIAlertView alloc] initWithTitle:@"SOCKET CONECTADO" message:(@"CONECTADO A %h", host) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease] show];
    [socket readDataWithTimeout:-1 tag:0];
    
    
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag{
    [socket readDataWithTimeout:-1 tag:0];
	NSData *truncatedData = [data subdataWithRange:NSMakeRange(0, [data length])];
	NSString *message = [[[NSString alloc] initWithData:truncatedData encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"%@",message);
    NSArray *mensagemSeparada = [message componentsSeparatedByString:@"/"];
    for(int i =0; i< [[[ViewController sharedController]buttonArray] count]; i++){
        UIButton *button = (UIButton *) [[[ViewController sharedController]buttonArray] objectAtIndex:i];
        if([button.titleLabel.text isEqualToString:[mensagemSeparada objectAtIndex:1]]){
            if([[mensagemSeparada objectAtIndex:0] isEqualToString:@"incr"]){ // INCREASE SIZE OF BUTTON ON mensagemSeparada[2]
                [button setFrame:CGRectMake(button.center.x - (button.frame.size.width+[[mensagemSeparada objectAtIndex:2] intValue])/2, button.center.y - (button.frame.size.width+[[mensagemSeparada objectAtIndex:2] intValue])/2, button.frame.size.width+[[mensagemSeparada objectAtIndex:2] intValue], button.frame.size.height +[[mensagemSeparada objectAtIndex:2] intValue])];
                [[[ViewController sharedController]buttonArray] replaceObjectAtIndex:i withObject:button];
                }
            else{
                if([[mensagemSeparada objectAtIndex:0] isEqualToString:@"decr"]){ // DECREASE SIZE OF BUTTON ON mensagemSeparada[2]
                    [button setFrame:CGRectMake(button.center.x + (button.frame.size.width-[[mensagemSeparada objectAtIndex:2] intValue])/2, button.center.y + (button.frame.size.width-[[mensagemSeparada objectAtIndex:2] intValue])/2, button.frame.size.width-[[mensagemSeparada objectAtIndex:2] intValue], button.frame.size.height -[[mensagemSeparada objectAtIndex:2] intValue])];
                    [[[ViewController sharedController]buttonArray] replaceObjectAtIndex:i withObject:button];
                }
                else{ //CHANGE POSITION OF BUTTON
                    if([[mensagemSeparada objectAtIndex:0] isEqualToString:@"move"]){ // MOVE BUTTON ON mensagemSeparada[2],mensagemSeparada[3]
                        [button setFrame:CGRectMake([[mensagemSeparada objectAtIndex:2] intValue] , [[mensagemSeparada objectAtIndex:3] intValue], button.frame.size.width, button.frame.size.height)];
                        [[[ViewController sharedController]buttonArray] replaceObjectAtIndex:i withObject:button];
                    }
                }
            }
            }
    }

	/*
    //ANTIGO E FUNCIONAL PARA RECEBER E EXIBIR MSG!
	NSString *txt = [[NSString alloc] init];
	txt = [txt stringByAppendingFormat:@"%@ \n",message];			
	NSLog(@"%@",txt);
	*/
	
	
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error{
	NSString *txt = [[[NSString alloc]init]autorelease];	
	txt = [txt stringByAppendingFormat:@"Host Desconectou \n"];
	NSLog(@"%@ \n",txt);
    [[[[UIAlertView alloc] initWithTitle:@"HOST" message:(@"DESCONECTOU") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease] show];
    ViewController *vc = [[ViewController alloc] init];
    [vc.labelStatus setText:@"Status: Desconectado"];
    [vc release];
	[socket disconnect];
	
}

//Send String via TCP/IP
-(void)sendString:(NSString *)msg{
	
	NSLog(msg);
	if([socket isConnected]){
		dadoEscrito = [msg dataUsingEncoding:NSUTF8StringEncoding];
	//	NSLog(@"%@",msg);
        
        //UIButton *button = (UIButton *) [[[ViewController sharedController]buttonArray] objectAtIndex:0];
       // NSLog(@"%@",button.titleLabel.text);
		[socket writeData:dadoEscrito withTimeout:-1 tag:0];
        
	} 
}
@end
