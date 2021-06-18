---
*Note* this library is for the Sinclair QL and compatible systems and was first
released 18 June 1990 (exactly 30 years ago as I'm writing this). Enjoy!
---

# The Idea of a Standard Application Manager

 QJumps Extended Environment (EE) brought a new concept of programs and handling
of programs into the QL world: the concept of moveable, resizeable windows, of
mouse (pointer) based user input, and recently the concept of buttons. All
these in conjuction with most Qjump products provide both flexibility and a
standard user interface, so that, to quote from the Pointer Toolkit package,
the users knows how to use a program even before he opens the box.

All this sounds very desirable, and most programmers (both free-lance and
professional) who wished to support Qjump and their new system failed to do
so because of the complexity of the facilities provided. While on the one hand
this complexity is the most obvious reason why EE managed to stay in the market
it is also the greatest obstacle for (commercial) software writers in way of
developing programs to use it.

To understand the reasons why the Application Manager Project came into
existence and why is has to become what it is now, it is necessary to think
about Qjumps concept so far: there are several pieces of software that form the
EE and which are all, to a greater or lesser extend, interconnected. The
PTR_GEN file forms the basic level of pointer based input. It partly modifies
and extends the QDOS operating system to take care of non-destructive windows,
introduces new graphic objects (sprites, pattern, blobs, partial window save)
and allows pointer based input, of course. The second base level program is
the Hotkey System II or HOT_REXT, which itself was obviously intended as a
support program rather than a QDOS extensions, which by now grew up into
something of both, as it introduces Things, on which most Hotkey operations
are based. And then there is the Window Manager WMAN, a utility to have
a standard appearence of windows and menus.

On PTR_GEN level, almost everything is possible, but it takes a good deal
of programming to have jobs running only with this special extenion. The WMAN
goes a step further in which it allows the programmer to set up data structures
telling how the final window should look like. On the way up to this level,
the programmer will loose some flexibility for the advantage of not having
to write the whole window handling routines. In the over two years since the
Pointer Toolkit appeard on the market, it became obvious that even that level
is too complex for most applications and only a hand full of programmers
managed to write programs of the 'new, user friendly type'.

The Application Manager procedures and functions move up a further level,
where it now becomes terribly easy to write EE programs on the cost of loosing
further flexibility. It still stays a useful tool, but it takes only an evening
or so to write the menu interface for a program. If you are disappointed by
this, you can still go levels down again. The Application Manager uses both
Window Manager and Pointer Interface (and as they are currently implemented
as SuperBASIC procs/fns they require QPTR_REXT).

The idea behind Application Manager Extensions (what about calling it
SPACE for the rest of the documentation - say Standard Pointer Application
Creation Extensions .. or something) was that Applications (and sometimes
utilities) always have (or should have) a standard form or appearence.

First of all there is the main window, the area in which the job will do
all its work. It is nice to have a title on top of it, so that the user could
identify the job. Then there are some standard items that may exist in all
applications. <ESC>ape to leave a program and a move item to move the window
around the screen should be present in all Applications. The resize item may
be present, depending on if it makes sense, the same is for the wake item
which is usually used to refresh the display. All maintainance-items appear
in the same line as the title, with wake and esc on its right, and size and/or
resize on its left.

The Application may have command items that correspond to the function
keys. As the are 10 F-keys available (F1-F5,ShF1-ShF5) lets assume a maximum of
ten command items, where the first (F1) should always be HELP. But.. I hear
people shouting from the back.. what if I want to have more commands? Easy,
as I allow the use of sub-commands. Sub-Commands are collected under a command
item, which when selected pulls-down a list of all sub-commands. For example
there may be a command item named <Files> and then some associted sub-commands
like <save file>,<load file>,<print file>.. etc. This concept allows you to
define 100+ commands, fairly enough. Command items start in the second window
line and, depending on the windows width, continue in the following line(s).

The most part of the primary window is allocated to an application window.
Later versions of SPACE will allow menu windows there, but up to now it is the
applications duty to take care of this window.

Furthermore there are some routines supplied to enter a string and to
select an item from a list of choices. These may only be used when the main
Application is already defined.

SPACE is implemented as a set of SuperBASIC procedures, currently starting
at linenumber 31000, but this may be changed. There procedures must be present
if their facilities are to be used. They can be QLiberated without the windows,
lines and names options (rel 3.xx). There are some SuperBASIC extensions in
addition to QPTR that make the interface to Things etc. They must be LRESPR'd
to use SPACE. They can be linked to the Qliberator code using the compiler
option REMark $$asmb=flp1_spacextn_bin,0,10. The QLiberated job requires at
least 1024 bytes stack space (REMark $$stak=1024) or better more.

SPACE may be used free of charge if credits are given in the program and/or
documentation. For convenience, all final versions should be QLiberated (Turbo
doesn't allow the use of QPTR extensions as far as I know). Commercial programs
that use SPACE are to be registered by myself (send me a free disk). Otherwise
SPACE a public domain program that will be constantly improved. It may freely
be copied but be aware that QPTR is a commercial programm courtesty of QJump
and must not be copied!

Please do not make any changes in the SPACE programm. If you want to see
something changed or added, write me short letter. This is not because of any
proud feelings but because of the need to have consistent parameters and reactions
as further versions should support programs written under older ones. If you
have problems or want something to be explained in greater detail (which is
possible) or if some procedures behave strange, i.e. not in the way described
here, then don't hestitat to write. The only purpose of SPACE to have more
programs supporting QJumps extended environment.

If you find SPACE useful (which I find it is!) then tell me. This will
help me to start/continue converting it into assembler (possibly to Thing
Extensions if Tony Tebby, the mind behind Qjump, supplies more detailed
information on that).

## Application Manager Procedures

The following section lists all procedures that may be used by the
application program. There is an *Application ID* that is unique for
each application window, so you have the possibility to have more than one
main window at a time (although I don't know what it's use might be). This
ID must be specified by each access to the application window.

All procedures may be compiled with QLiberator, the necessary decision if
the program runs as a job or interpreted by SuperBASIC is made via the jobs
name, so take care that you compiled job has a name! In principle, there is
no need for the programmer to determine whether the program is compiled or
not.


**Thanks:**

Here I would like to express my special thanks to Tony Tebby, who is
responsible for the whole extended environment, for his help and support.
The same is for Jochen Merz, who was so kind to give me more detailed
information on some of the twilight topics in the new EE.

_Software and Documentation written in June, 1990 by Oliver Fink_

### Create (setup) a standard application window

    id=CR_APP(w,h,x,y,title$,events,commands$,pointer,colour)

This function creates the definition of a standard application window,
and returns its ID. This `id` is floating point (long integer). The
given the cooridnates `w - width`, `h - height` (in pixels) refer to
the (sub-)window that may be used by the programmers code, **not** the jobs main
window. The main window must allow space for all command/event items as well
as the title. As this is liable to vary according to the number of commands
that are allowed, it's size is internally calculated. There is no need for the
programmer to know this size, he only has to assure that it fits on the
screen. The programmer can be sure that the window he is allowed to use (the
application window) will have the exact size given here.

The coordinates `x,y` give the position where the pointer should appear
when the window is drawn first time. These coorinates are relative to the top left
hand corner of the main window. The title is given as `title$`. There should
be no backslash character in the title, as if a backslash is found then the
following string is taken as the item text for the button.

The `events` parameter is an integer, and its bits determine
how the manager should react on standard events. Standard events are
a move, wake, sleep etc. An item for each bit is then placed into the windows
title column. The move and resize items are drawn on the left, wake and esc or
sleep on it's right. It is assumed that either esc or sleep (Zzzz) is present.
The meanings of the bits are as following:

       Bit (value)                   action
          0   (1)             draw ESCape item       (unset)
                              draw sleep (Zzzz) item (set)
          1   (2)             draw wake (flash) item
          2   (4)             draw resize item
          3   (8)             draw move item
          4/5 (16/32)         unused (yet)
          6   (64)            return when window was moved
          7   (128)           return when pointer in window (unset)
                              return when hit in window     (set)

The following parameter, `commands$` may either be a null string (`""`) or
an string array. If it is a null string, then there are no selectable commands.
If it is an (one-dimensional) array, this hold the names of the command items.
There may be up to nine commands (i.e. 0..9) that can be selected with F1-F10.
The names may be up to 10 characters long. It is a convention that the first
item (F1) is treated as help.

The `pointer` parameter may be a single variable or a one dimensional array
with two float numbers (long integer). The first element pointer(0) holds the
address of the sprite to be used as pointer for the main window, the second
element is the sprite for the appl. window. If only a single value is given,
then this sprite is used for both windows. If an value (address) is given as `0`,
then the default pointer (arrow) is used.

The `colour` is used for the background (paper) of the application window.

### Create a sub-command window

    CR_MENU id,comm_nr,sub_commands$,pointer

This command allows to set up a sub-command window. There will be as
many sub-commands as elements in the one-dimensional array `sub-commands$`.
The sub-commands will be grouped under the main command with its number given
in `comm_nr` (0-9). Logically, that command must have been defined in the
main application window. The `pointer` variable holds the address of the
pointer sprite (or `0`).

As this command requires the application `id`, it has to be executed after the
CR_APP function. You can set up as many sub-command windows as you have
commands items in you application window, but there's no need for each
command item to have sub-commands.



### Draw the application window

    DR_APP #ch,id

This command draws the jobs application window. It will be positioned
at the current pointer position. The `ch` is the channel that will be
used for drawing. As, when the program is interpreted, the SuperBASIC windows
determine the outline of the whole job, the application is drawn as a pull
down window and not as a primary window, this will only happen when compiled.
At that stage, the given channel will be used. But to allow programs to be
run interpreted, this channel always has to be supplied. This channel should
**not** be used for other purposes. Usually, an application is only drawn
once.


### Set a channel to convert the application window

    DR_CHAN #ch,id

The given window will be redrawn to cover the area of the application window.
It will have the exact size given in the creation function. The paper and ink
colours are set according to selectable items. This command is also used
internally to set the window area after a return from `RD_APP`.


### Remove application from the screen/memory

    RM_APP id

The given application is removed (unset) from the screen and the
memory occupied is released. The application id is no longer valid and
should not be used anymore. This command is usually one of the last commands
in a program.

### Read the pointer in an application

    reason=RD_APP(#ch,#ach,id)

This command is the one used most often. It provides the program with the
information about the users action. This command displays the pointer and then,
is possible, take the action required.

The channel `ch` has to be the same as set by `DR_APP`. The other channel
`ach` has, after the command has finished, been set to the programmers
window, i.e. the window that may be used by the programmers code.

If the window was prepared to take a move event, then a hit on that item
results in the following action: the pointer takes the shape of the move
item and allows the user to move the window around. This window is then
redrawn at its new position. If bit 6 was set in
the events parameter of `CR_APP` then the functions returns the move value
as a result (`=8`).

If the resize item was allowed then the pointer changes to the resize sprite
reads the size change and return the resize value (`=4`). The distance the
resize pointer moved can be obtained by accessing the X_PTR/Y_PTR values.
When the wake item has been hit, then this function returns the wake value
(`=2`), and when someone hit the ESC item, it will return the value `1`, that is
if the cancel/esc item has been asked to be there.

If there is a Zzzz (sleep) item instead of an cancel item, then the applications
window will be removed from the screen and replaced by a tiny button. The
text of the item in this button will be either the jobs name or the button
name given in the title$ of `CR_APP` (this can be done by placing a backslash
followed by the button name at the end of the title$. This is especially
useful for buttons under SuperBASIC testing, as SuperBASIC has no jobname.)
If the QPAC2 Button Frame Thing (v1.01) is installed, then the button is slotted
into it, otherwise it will appear at the current pointer position and will
be moveable when hit. When the button is 'done' (ENTER/right mouse button),
the application window will be redrawn. The function returns with the wake
value (`=2`) as the application window will need a redraw, too.

When a command item is activated, that has no sub-commands, the function
returns with the command value (`=10`). If the command has a sub-command
window, this will be drawn and read. If then no action is selected and the
sub-command is left via the ESC option, the function will re-read the
main window again. If a sub-command was selected, then the function returns
with the value 10,too.

When the pointer is in the application window, the function returns according
to bit 7 in the events parameter of CR_APP. The value returned will be
zero (=0). A list of return values is given here:

       value                         reason
          0                   the pointer hit/moved in the application
                                window
          1                   the ESCape item was selected
          2                   the wake item was selected or
                                the button was activated
          4                   the resize item was selected
          8                   the move item was selected
         10                   a (sub-) command was selected

There are several functions to get more information on what happened
during the application pointer was read.

#### Information functions

    result=COMM_NR(id)

This function returns the number (`0`..`9`) of the selected command. If no
command was selected, it returns `-1`.

    result=SUBC_NR(id)

This function returns the number of the selected sub-command. If no
sub-command was selected, it returns `-1`.

    result=X_PTR(id)

This function returns the x-position (in pixels) of the pointer
relative to the application windows origin, or the x distance the pointer
moved during resize. If the return of the application pointer read was
different from `10` and `4` then the value will be `-1`.

    result=Y_PTR(id)

This function returns the y-position (in pixels) of the pointer
relative to the application windows origin, or the y distance the pointer
moved during resize. If the return of the application pointer read was
different from `10` and `4` then the value will be `-1`.

    result=APP_EVENT(id)

This function way be used to examine more closely what happened in the
application window. It returns the keystroke and/or the event that occured
during the pointer read. Remember that Enter/ESC/Space... are converted to
event keystrokes (see QPTR Pointer Toolkit Documentation page 37).

#### Pop-up box - selection routine

    result=BX_SELECT(info$,items$,pointer)

This routine pops-up a window with the information given in the
one-dimensional info$ array and draws the possible choices given in
the items$ array. One of the choices can then be selected with the
pointer. The number of choice is returned as the result. The items$ array
must have more than one element.

The size of the pop-up box is determined by the length of the info$ strings
and the number of elements in info$.



#### Pop-up box - string input routine

    result$=BX_INPUT$(info$,default$,pointer)

This is a general routine to enter a string via a small pop-up box.
Usually this is used to enter a filename or so. The one-dimensional array
`info$` hold the information printed in the box. The `default$`
is a string supplied to the user for editing.

The size of the pop-up box is determined by the length of the `info$` strings
and the number of elements in `info$`.
