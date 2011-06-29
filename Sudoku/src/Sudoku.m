/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | Sudoku - iPhone Sudoku Game                                            |
// +------------------------------------------------------------------------+
// | Copyright (c) 2007 Zack Bartel                                         |
// +------------------------------------------------------------------------+
// | This program is free software; you can redistribute it and/or          |
// | modify it under the terms of the GNU General Public License            | 
// | as published by the Free Software Foundation; either version 2         | 
// | of the License, or (at your option) any later version.                 |
// |                                                                        |
// | This program is distributed in the hope that it will be useful,        |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of         |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          |
// | GNU General Public License for more details.                           |
// |                                                                        |
// | You should have received a copy of the GNU General Public License      |
// | along with this program; if not, write to the Free Software            |
// | Foundation, Inc., 59 Temple Place - Suite 330,                         |
// | Boston, MA  02111-1307, USA.                                           |
// +------------------------------------------------------------------------+
// | Author: Zack Bartel <zack@bartel.com>                                  |
// +------------------------------------------------------------------------+ 

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UIAlertSheet.h>
#import "Sudoku.h"
#import "ZBBoardView.h"

@implementation Sudoku : UIApplication

- (void) initApplication    {
    
    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0.0f;

    _window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];


    [_window orderFront: self];
    [_window makeKey: self];
    [_window _setHidden: NO];
 
    _nav = [[UINavigationBar alloc] initWithFrame: CGRectMake( 0.0f, 0.0f, NAVBAR_WIDTH, NAVBAR_HEIGHT)];

    [_nav showButtonsWithLeftTitle: @"New" rightTitle: @"Check" leftBack: NO];
    [_nav setDelegate: self];
    [_nav setBarStyle: 3];
    [_nav enableAnimation];

    _boardView = [[ZBBoardView alloc] initWithFrame: rect];
    [_boardView addSubview: _nav];
    [_window setContentView: _boardView]; 

}

- (void) navigationBar: (UINavigationBar *)navBar buttonClicked: (int)button    {
    switch (button) {
        case 0: //Right button
            if ( [_boardView isSolved] )
            {
                [self alertEvent: @"Solved!"];
            }
            else
            {
                [self alertEvent: @"Not Solved"];
            }
            break;
        case 1: //Left button
            [self alertEvent: nil];
            break;
    }
}

- (void) alertEvent:(NSString*)message    {
    if (message == nil)
    {
       alert = [[UIAlertSheet alloc] initWithTitle: @"Sudoku" 
            buttons: [NSArray arrayWithObjects: @"Yes", @"No", nil]
            defaultButtonIndex: 1
            delegate: self
            context: nil];                     

        [alert setBodyText: @"New Game?"];
    }
    else
    {
       alert = [[UIAlertSheet alloc] initWithTitle: @"Sudoku" 
            buttons: [NSArray arrayWithObjects: @"OK", nil]
            defaultButtonIndex: 1
            delegate: self
            context: nil];                     

        [alert setBodyText: message];
    }
    [alert popupAlertAnimated:YES];
}

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button   {
    if (button == 1 && [sheet buttonCount] == 2)
    {
            [_boardView newGame];
    }
    [alert dismiss];
    [alert release];
}

- (void) applicationDidFinishLaunching: (id) unused
{
    [self initApplication];
}

/*
- (void) applicationSuspend: (struct __GSEvent *)event
{
    NSLog(@"applicationWillSuspend");
}
*/
- (void) applicationWillTerminate
{
    [_boardView save];
}


@end


