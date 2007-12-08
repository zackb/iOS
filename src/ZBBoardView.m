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
#import "ZBBoardView.h"
#import "ZBNumberChooser.h"
#import "SudokuController.h"
#import "ZBCell.h"

@implementation ZBBoardView : UIView

- (id)initWithFrame:(struct CGRect)frame    {
	self = [super initWithFrame:frame];
    controller = [[SudokuController alloc] initWithRect: [self bounds]];
    _previousHit = nil;
    showChooser = NO;
    return self;
}

- (void)drawRect:(CGRect)rect   {
    int i;
    float cellWidth = rect.size.width/DIMENSION;
    float cellHeight = (rect.size.height - NAVBAR_HEIGHT)/DIMENSION;
    float black[4] = {0, 0, 0, 1};
    float white[4] = {1, 1, 1, 1};
    CGContextRef ctx = UICurrentContext();
    NSMutableArray *cells = [controller cells];
    
//Draw Board
    //White background
    CGContextSetFillColor(ctx, white);
    CGContextFillRect(ctx, rect);

    for ( i = 0; i < [cells count]; i++ )   {
        ZBCell *_current = [cells objectAtIndex: i];
        [self renderCell: _current];
    }

    CGContextSetFillColor(ctx, black);
    for ( i = 0; i < rect.size.width; i++ ) {

        if ( i % 3 )    
            CGContextSetLineWidth(ctx, 1.0);
        else
            CGContextSetLineWidth(ctx, 3.0);

        //Vertical
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, i * cellWidth, NAVBAR_HEIGHT);
        CGContextAddLineToPoint(ctx, i * cellWidth, rect.size.height);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //Horizontal
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, 0, (i * cellHeight) + NAVBAR_HEIGHT);
        CGContextAddLineToPoint(ctx, rect.size.width, (i * cellHeight) + NAVBAR_HEIGHT);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

    if (showChooser)
    {
        if (_numberChooser)
        {
            [_numberChooser release];
            _numberChooser = nil;
        }
        _numberChooser = [[ZBNumberChooser alloc] initWithFrame: chooserRect]; 

        [self addSubview: _numberChooser];
    }
    else
    {
        if (_numberChooser != nil)
        {
            [_numberChooser removeFromSuperview];
            _numberChooser = nil;
        }
    }
}

- (void)mouseDown:(GSEvent *)event 
{
    CGPoint point = GSEventGetLocationInWindow(event);
    ZBCell *hit = [controller cellAtPoint: point];
    CGRect _rect;
    char newChar;

    _previousHit = nil;

    if ( hit)
    {
        if ([hit editable])
        {
 //           [hit hit];
            _rect = [hit rect];
            _rect.origin.x = point.x;
            _rect.origin.y = point.y;
            chooserRect = CGRectMake(_rect.origin.x - 75.0, _rect.origin.y - 75.0, 150.0, 150.0);
            if (showChooser)
            {
                showChooser = NO;
            }
            else
            {
                showChooser = YES;
            }
            _previousHit = hit;
        }
        else if (showChooser)
        {
            showChooser = NO;
        }
    }
    else if (showChooser)
    {
        showChooser = NO;
    }

    [self setNeedsDisplayInRect: [self frame]];
}

- (void)renderCell:(ZBCell *)cell    
{
    CGContextRef ctx = UICurrentContext();
    float white[4] = { 1.0, 1.0, 1.0, 1.0 };
    float black[4] = {0, 0, 0, 1};
    float gray[4] = {0, 0, 0, 0.5};

    CGRect rect = [cell rect];
    int number = [cell number];
    char cnumber = number + '0';

    switch ( number ) {
        case 0:
            CGContextSetFillColor(ctx, white);
            break;
        default:
            CGContextSetFillColor(ctx, white);

            if ( [cell editable] )  {
                CGContextSetFillColor(ctx, black);
            }
            else    {
                CGContextSetFillColor(ctx, gray);
            }

            CGContextSaveGState(ctx);
            CGContextSelectFont(ctx, "Arial", rect.size.height, kCGEncodingMacRoman);
            CGAffineTransform t = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height/30);
            CGContextSetTextMatrix(ctx, t);

            CGContextShowTextAtPoint(ctx, 
                                     rect.origin.x + 3,
                                     rect.origin.y + 34,
                                     &cnumber, 1);
            CGContextRestoreGState(ctx);
            break;
    }

}

- (void)selectNumber: (char)num
{
    showChooser = NO;

    if (_previousHit != nil)
    {
        [_previousHit setNumber: atoi(&num)];
    }
    [self setNeedsDisplay];
}

- (BOOL)isSolved
{
    return [controller is_solved];
}

- (void)newGame
{
    [controller loadBoardAndCells];
    [self setNeedsDisplay];
}

- (CGRect)bounds
{
    return [super bounds];
}

- (void)save
{
    [controller saveDataToDisk];
}

@end
