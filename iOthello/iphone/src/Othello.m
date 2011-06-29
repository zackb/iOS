/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | Othello - iPhone Othello Game                                            |
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
#import "Othello.h"
#import "ZBOthelloView.h"

@implementation Othello : UIApplication

- (void) initApplication    
{
    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0.0f;

    _window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];

    [_window orderFront: self];
    [_window makeKey: self];
    [_window _setHidden: NO];
 
    _boardView = [[ZBOthelloView alloc] initWithFrame: rect];
    [_window setContentView: _boardView]; 
    [self setStatusBarMode: 1 duration:2];

}

- (void) applicationDidFinishLaunching: (id) unused
{
    [self initApplication];
}

@end


