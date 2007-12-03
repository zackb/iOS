/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | Sudoku - iPhone Sudoku Game                                            |
// +------------------------------------------------------------------------+
// | Copyright (c) 2006 Zack Bartel                                         |
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
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIView-Geometry.h>
#import "Sudoku.h"
#import "ZBNumberChooser.h"

@implementation ZBNumberChooser : UIView

- (id)initWithFrame:(struct CGRect)frame    {
	self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect   
{
    float black[4] = {0, 0, 0, 1};
    CGContextRef ctx = UICurrentContext();
    CGContextSetFillColor(ctx, black);
    CGContextFillRect(ctx, rect);
}

- (void)mouseDown:(GSEvent *)event 
{

}

- (void)mouseDragged:(GSEvent *)event   
{
}

- (CGRect)bounds
{
    return [super bounds];
}

@end
