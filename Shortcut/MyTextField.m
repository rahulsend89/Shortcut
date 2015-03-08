//
//  MyTextField.m
//  Shortcut
//
//  Created by Rahul Malik on 08/03/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField
-(void)keyUp:(NSEvent *)theEvent {
    if([theEvent keyCode] == 125){
        [[NSApp delegate] keyUp:theEvent];
    }
    if([theEvent keyCode]==36){
        [[NSApp delegate] keyDown:theEvent];
    }
}
@end
