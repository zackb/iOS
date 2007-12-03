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

#import "ZBCell.h"
//#import </usr/include/objc/objc-class.h>

@implementation ZBCell

- (id)initWithRect:(CGRect)rect {
    _rect = rect;
    [self setNumber: 0];
    [self setEditable: YES];
    return self;
}

- (CGRect)rect  {
    return _rect;
}

- (void)hit 
{
    int number = [self number];
    if ( [self editable])
    {

        if ( number == 9 )
        {
            [self setNumber: 0];
        }
        else
        {
            [self setNumber: number + 1];
        }
    }
}

- (int)number
{
    return _number;
}

- (void)setNumber:(int)number
{
    _number = number;
}

- (BOOL)editable
{
    return _editable;
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
}

- (void) encodeWithCoder:(NSCoder *)coder
{
    NSNumber *iEditable = nil;
    if ( [self editable] )
    {
        iEditable = [NSNumber numberWithInt: 1];
    }
    else
    {
        iEditable = [NSNumber numberWithInt: 0];
    }
    [coder encodeObject: [NSNumber numberWithInt: [self number]] forKey: @"number"];
    [coder encodeObject: iEditable  forKey: @"editable"];
    [coder encodeObject: [NSNumber numberWithFloat: _rect.origin.x]  forKey: @"x"];
    [coder encodeObject: [NSNumber numberWithFloat: _rect.origin.y]  forKey: @"y"];
    [coder encodeObject: [NSNumber numberWithFloat: _rect.size.width]  forKey: @"width"];
    [coder encodeObject: [NSNumber numberWithFloat: _rect.size.height]  forKey: @"height"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    [self setNumber: [[coder decodeObjectForKey: @"number"] intValue]];
    
    [self setEditable: [[coder decodeObjectForKey: @"editable"] intValue] == 1 ? YES : NO];

    _rect.origin.x = [[coder decodeObjectForKey: @"x"] floatValue];
    _rect.origin.y = [[coder decodeObjectForKey: @"y"] floatValue];
    _rect.size.width = [[coder decodeObjectForKey: @"width"] floatValue];
    _rect.size.height = [[coder decodeObjectForKey: @"height"] floatValue];

    return self;
}

@end
