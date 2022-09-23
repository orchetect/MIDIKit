# HUI Text: Characters and Strings

Character encodings for HUI text displays.

## Overview

HUI surfaces contain 3 distinct types of visual text displays:

1. The main large display: 2 rows of 40 characters each.
2. The main time display: 8 7-segment digits, the first seven of which can optionally display a trailing dot.
   - This is used to display current timecode, elapsed time, musical bars & beats, or frame number.
   - The current display mode is indicated by a corresponding LED lighting up next to the time display with a label indicating which time format is being displayed.
3. Channel names and Select Assign text: each 4 characters long. 

It is important to know that each of these 3 text displays have different character sets. So each display has their own strongly-typed string and character types, containing the respective character sets available to each.

Text change events are only applicable to ``HUIHostEvent`` and are only ever transmitted to a remote HUI surface to update its text displays.

## Topics

### Display Identification

- ``HUISmallDisplay``

### Large Display (40 x 2 chars)

- ``HUILargeDisplayCharacter``
- ``HUILargeDisplayString``

### Small Displays (4 chars)

- ``HUISmallDisplayCharacter``
- ``HUISmallDisplayString``

### Time Display

- ``HUITimeDisplayCharacter``
- ``HUITimeDisplayString``
