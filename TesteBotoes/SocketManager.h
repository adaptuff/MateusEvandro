//
//  SocketManager.h
//  TestePontos
//
//  Created by Mateus Pelegrino on 07/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface SocketManager : NSObject {

	GCDAsyncSocket *socket;
	BOOL isRunning;
	NSData *dadoEscrito;

}
@property (nonatomic, retain)GCDAsyncSocket *socket;
@property (nonatomic, retain)NSData *dadoEscrito;


-(SocketManager *)initSocketManager;
-(void) connect:(NSString *)ip porta:(NSString *)porta;
-(void) disconnect;
-(void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port;
-(void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag;
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error;
-(void)sendString:(NSString *)msg;
-(BOOL)isConnected;


@end
