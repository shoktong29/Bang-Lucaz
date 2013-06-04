//
//  Defines.h
//  Bang
//
//  Created by Martin on 6/1/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#ifndef Bang_Defines_h
#define Bang_Defines_h

//Returns UIColor from hex
#define UICOLOR_FROM_HEX(x) [UIColor colorWithRed:(((NSUInteger) (x & 0xff0000) >> 16) /255.) \
green:(((NSUInteger) (x & 0x00ff00) >> 8) / 255.) \
blue:(((NSUInteger) (x & 0x0000ff)) / 255.) \
alpha:1.0];


#endif
