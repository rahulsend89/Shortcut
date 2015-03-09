//
//  MyTableView.m
//  Shortcut
//
//  Created by Rahul Malik on 09/03/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView
-(void)keyUp:(NSEvent*)theEvent{
    [[NSApp delegate] keyUp:theEvent];
    [super keyUp:theEvent];
}
-(void)keyDown:(NSEvent*)event{
    if([event keyCode] == 53){
        [[NSApp delegate] closeWindow];
    }
    [[NSApp delegate] keyDown:event];
    [super keyDown:event];
}
@end
