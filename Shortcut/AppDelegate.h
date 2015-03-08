//
//  AppDelegate.h
//  Shortcut
//
//  Created by Rahul Malik on 18/10/14.
//  Copyright (c) 2014 Rahul Malik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSEWindow.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>{
    IBOutlet NSTableView *myTable;
    IBOutlet NSSearchField *searchField;
    NSEWindow *window;
    NSStatusItem *statusItem;
    NSMutableArray *backUpData;
}
@property(nonatomic,strong)NSMutableArray *dataarray;
@end

