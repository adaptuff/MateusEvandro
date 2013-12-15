//
//  ButtonArray.m
//  TesteBotoes
//
//  Created by Mateus Pelegrino on 4/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ButtonArray.h"

@implementation ButtonArray
@synthesize buttonArray;
static ButtonArray *instance =nil;    
+(ButtonArray *)getInstance    
{    
    @synchronized(self)    
    {    
        if(instance==nil)    
        {    
            
            instance= [ButtonArray new];    
        }    
    }    
    return instance;    
}    

@end
