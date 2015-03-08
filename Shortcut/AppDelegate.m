//
//  AppDelegate.m
//  Shortcut
//
//  Created by Rahul Malik on 18/10/14.
//  Copyright (c) 2014 Rahul Malik. All rights reserved.
//

#import "AppDelegate.h"
#import "EBLaunchServices.h"
#import "JFHotkeyManager.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSEWindow *window;

@end

@implementation AppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSApp activateIgnoringOtherApps:YES];
    JFHotkeyManager *hkm = [[JFHotkeyManager alloc] init];
    [hkm bind:@"command shift space" target:self action:@selector(openWindow)];
    [hkm bind:@"escape" target:self action:@selector(closeWindow)];
    NSArray *ar = [EBLaunchServices allItemsFromList:kLSSharedFileListFavoriteItems];
    _dataarray = [[[NSMutableArray alloc] init] retain];
    for (EBLaunchServicesListItem*obj in ar) {
        if(![obj.name isEqualToString:@"AirDrop"] && ![obj.name isEqualToString:@"iCloud"] && ![obj.name isEqualToString:@"All My Files"]){
            NSLog(@"obj : %@",obj.name);
            [_dataarray addObject:obj];
        }
    }
    backUpData = [[NSMutableArray arrayWithArray:_dataarray] retain];
    myTable.delegate = self;
    myTable.dataSource = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadMycell];
    });
    allCharsInSet = [[[NSMutableArray alloc] init] retain];
    for (int count = 65; count<92; count++) {
		[allCharsInSet addObject:[[NSString alloc] initWithFormat:@"%c",count]];
	}    
}
-(void)setDataarray:(NSMutableArray *)dataarray{
    _dataarray = backUpData;
    if(!dataarray){
        [myTable reloadData];
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",(NSString*)dataarray]];
    _dataarray = [[_dataarray filteredArrayUsingPredicate:predicate] mutableCopy];
    if([_dataarray count] == 1){
        [self goToFile:[_dataarray objectAtIndex:0]];
    }
    [myTable reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [myTable selectRowIndexes:indexSet byExtendingSelection:YES];
    [searchField resignFirstResponder];
    [myTable becomeFirstResponder];
    [window selectNextKeyView:myTable];
}
-(void) mouseDown: (id) sender
{
    NSInteger rowIndex = [sender selectedRow];
    [self goToFile:[_dataarray objectAtIndex:rowIndex]];
}
-(void)keyUp:(NSEvent*)theEvent{
    if(![[[self window] firstResponder] isKindOfClass:[NSTextView class]]){
        if([allCharsInSet containsObject:[[theEvent charactersIgnoringModifiers] uppercaseString]]){
            [myTable resignFirstResponder];
            [[self window] makeFirstResponder:searchField];
        }
        return;
    }
    
    switch([theEvent keyCode]) {
        case 125: {
            int index = 0;
            if([[searchField stringValue] length]>1){
                index = 1;
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
            [myTable selectRowIndexes:indexSet byExtendingSelection:NO];
            [searchField resignFirstResponder];
            [[self window] makeFirstResponder:myTable];
            break;
        }
    }
}
-(void)keyDown:(NSEvent*)event{
    if([event keyCode]==36){
        NSInteger rowIndex = [myTable selectedRow];
        if(rowIndex!=-1){
            [self goToFile:[_dataarray objectAtIndex:rowIndex]];
        }
    }
}
-(void)openWindow{
    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:nil];
    [searchField selectText:@""];
    [[self window] makeFirstResponder:searchField];
    [[searchField currentEditor] setSelectedRange:NSMakeRange([[searchField stringValue] length], 0)];
}
-(void)closeWindow{
    [window close];
    [NSApp activateIgnoringOtherApps:NO];
}
-(void)reloadMycell{
    [myTable reloadData];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (void)goToFile:(EBLaunchServicesListItem*) obj {
    [window close];
    [[NSWorkspace sharedWorkspace] openURL:obj.url];
    [searchField setStringValue:@""];
    _dataarray = backUpData;
    [myTable reloadData];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_dataarray count];
}
-(void)awakeFromNib{
    [myTable setTarget:self];
    [myTable setDoubleAction:@selector(mouseDown:)];
    [myTable setNextResponder:self];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setAction:@selector(openWindow)];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"image"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"alternate_image"]];
}
- (IBAction)searchAction:(id)sender {
//        NSInteger rowIndex = [myTable selectedRow];
//        [self goToFile:[_dataarray objectAtIndex:rowIndex]];
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *identifier = [tableColumn identifier];
    if( [identifier isEqualToString:@"MainCell"] )
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:nil];
        EBLaunchServicesListItem* obj = (EBLaunchServicesListItem*)[_dataarray objectAtIndex:row];
        cellView.textField.stringValue = obj.name;
        cellView.imageView.image = obj.icon;
        return cellView;
    }
    return nil;
}



@end
