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
    int i;
    int j;
    float black[4] = {0, 0, 0, 1};
    float white[4] = {1, 1, 1, 1};
    float gray[4] = {0.5, 0.5, 0.5, 1.0};

    float widthDelta = rect.size.width/3;
    float heightDelta = rect.size.height/3;

    char number = '1';

    CGRect numberRect;

    CGContextRef ctx = UICurrentContext();
    CGContextSetFillColor(ctx, gray);
    CGContextFillRect(ctx, rect);
    CGContextSetFillColor(ctx, black);
    CGContextStrokeRect(ctx, rect);

    CGContextSetFillColor(ctx, white);

    for ( j = 0; j < 3; j++ )
    {
        for ( i = 0; i < 3; i++)
        {
            numberRect = CGRectMake(rect.origin.x + (i * (rect.size.width/3) + 10),
                                    rect.origin.y + heightDelta + ( j * (rect.size.height/3) - 9),
                                    rect.size.height,
                                    rect.size.width);

            [self renderNumber: number inRect:numberRect];
            ++number;
        }
   } 
}

- (void)renderNumber:(char)number inRect:(CGRect)rect
{
    CGContextRef ctx = UICurrentContext();

    CGContextSaveGState(ctx);
    CGContextSelectFont(ctx, "Arial", rect.size.height/3, kCGEncodingMacRoman);
    CGAffineTransform t = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height/30);
    CGContextSetTextMatrix(ctx, t);

    CGContextShowTextAtPoint(ctx, 
                             rect.origin.x,
                             rect.origin.y, 
                             &number, 1);
    CGContextRestoreGState(ctx);
}

- (void)mouseDown:(GSEvent *)event 
{
    int i;
    int j;

    CGRect frame = [self frame];
    CGRect rect = [self bounds];
    CGRect numberRect;
    CGPoint point = GSEventGetLocationInWindow(event);
    point.x -= frame.origin.x;
    point.y -= frame.origin.y;

    float widthDelta = rect.size.width/3;
    float heightDelta = rect.size.height/3;

    char number = '1';

    for ( j = 0; j < 3; j++ )
    {
        for ( i = 0; i < 3; i++)
        {
            numberRect = CGRectMake(rect.origin.x + (i * (rect.size.width/3)),
                                    rect.origin.y + ( j * (rect.size.height/3)),
                                    heightDelta,
                                    widthDelta);

            if ( CGRectContainsPoint(numberRect, point) )   
            {
                value = number;
                break;
            }
            ++number;
        }
   } 
   [[self superview] selectNumber: value];
}

- (void)mouseDragged:(GSEvent *)event   
{
}

- (CGRect)bounds
{
    return [super bounds];
}

@end
