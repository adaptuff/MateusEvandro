//
//  ButtonArray.h
//  TesteBotoes
//
//  Created by Mateus Pelegrino on 4/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonArray : NSObject{
    NSMutableArray *buttonArray;     

}    
    @property(nonatomic,retain)NSMutableArray *buttonArray;    
    
    +(ButtonArray*)getInstance;    
    
@end  