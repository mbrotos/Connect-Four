%%Connect_Four.t
%%Adam Sorrenti
%%Mr. Ceccato
%%ICS 201a CPT
% _________                                     __       _____
% \_   ___ \  ____   ____   ____   ____   _____/  |_    /  |  |
% /    \  \/ /  _ \ /    \ /    \_/ __ \_/ ___\   __\  /   |  |_
% \     \___(  <_> )   |  \   |  \  ___/\  \___|  |   /    ^   /
%  \______  /\____/|___|  /___|  /\___  >\___  >__|   \____   |
%         \/            \/     \/     \/     \/            |__|

var font1 : int
font1 := Font.New ("arial:20:bold")

var playercolours : array 1 .. 2 of int
playercolours (1) := brightred
playercolours (2) := brightblue

const midx := maxx div 2
const midy := maxy div 2
var win : int := 0

%% Procedure to creates the game board and sets each spots value to 0  and sets up scorearray board
proc setup (var takenarray : array 1 .. 10, 1 .. 10 of int, var names : array 1 .. 2 of string, var scorearray : array 1 .. 2 of int)

    cls
    %% Draws Connect 4 Board
    drawfillbox (20, 130, 430, 530, purple)
    drawbox (20, 130, 430, 530, brightgreen)
    for c : 1 .. 10
	for w : 1 .. 10
	    drawfilloval (c * 40, 550 - w * 40, 10, 10, black)
	    drawoval (c * 40, 550 - w * 40, 10, 10, brightgreen)
	end for
    end for

    %% This sets up the top scorearrayboard
    locate (1, 25 div 2)
    colour (brightred)

    put names (1), " (", scorearray (1), ") " ..
    colour (brightgreen)

    put "vs " ..
    colour (79)

    put names (2), " (", scorearray (2), ") "

    %% Sets each oval to 0, representing it is not takenarray
    for a : 1 .. 10
	for b : 1 .. 10
	    takenarray (a, b) := 0
	end for
    end for

end setup


%%This proc gets the names of the players
proc getnames (var names : array 1 .. 2 of string)
    var temp : string

    put "Created By: Adam Sorrenti"
    put ""
    put ""
    put ""
    locate (4, 10)
    put "Welcome To My Connect 4 Game "
    put ""
    put "        *This is a 2 player game ONLY!*"
    put "__________________________________________________"

    put "__________________________________________________"

    put "__________________________________________________"

    put ""
    %% Gets players' 1 and 2's name
    for q : 1 .. 2
	put "Player ", q, ", what is your name?"
	colour (0)
	put ""
	get names (q)
	put ""
	colour (brightgreen)
    end for

end getnames

%% This proc is what give the falling chip animation
proc falling (col, row, player : int)
    var chipcolour : int
    chipcolour := playercolours (player) %% sets colour of chip to corresponding player

    %% Draws the chip in each row reaching the first empty one
    for q : 1 .. row
	drawfilloval (col * 40, 550 - q * 40, 10, 10, chipcolour)
	drawoval (col * 40, 550 - q * 40, 10, 10, brightgreen)

	delay (95)
	%% fills each chip in black as it goes down each row
	if q not= row then
	    drawfilloval (col * 40, 550 - q * 40, 10, 10, black)
	    drawoval (col * 40, 550 - q * 40, 10, 10, brightgreen)
	end if

    end for

end falling

%% This function finds the first empty spot in a given column
function findrow (col : int, takenarray : array 1 .. 10, 1 .. 10 of int) : int
    for decreasing e : 10 .. 1
	if takenarray (col, e) = 0 then
	    result e %% results out the first empty row
	end if
    end for
end findrow

%% This proc is responsible for drawing the chip at the top of the board and moving it as u press the arrow keys
proc turn (player : int, var names : array 1 .. 2 of string, var col, row : int, var takenarray : array 1 .. 10, 1 .. 10 of int)

    var key : string (1)
    drawfilloval (col * 40, 551, 10, 10, playercolours (player)) %% draws corresponding players' chip at the top of current column

    loop
	if hasch then
	    drawfilloval (col * 40, 551, 10, 10, black) %%if a key is pressed this fills in current chip black
	    getch (key)
	    if key = chr (203) then %% "if" statement for when left arrow is pressed
		if col = 1 then %% if left arrow key is pressed when in column 1 then
		    col := 10 %% set column to 10
		else %% if column is other than 1 then
		    col -= 1 %% -1 from given column
		end if
	    elsif key = chr (205) then %% "if" statement for when left arrow is pressed
		if col = 10 then %% if right arrow key is pressed when in column 1 then
		    col := 1 %% set column to 1
		else %% if column is other than 10
		    col += 1 %% +1 to given column
		end if

		%%ELSIF BELOW IS FOR DEBUGGING%%
	    % elsif key = chr (187) then
	    %     win := 1
	    
	    
	    end if
	    exit when win = 1

	    exit when key = chr (32) and takenarray (col, 1) = 0 %% Exits loop when key pressed = space or enter and first row is not takenarray
	    drawfilloval (col * 40, 551, 10, 10, playercolours (player))
	end if
    end loop

    row := findrow (col, takenarray) %% sets row := first empty row in a column
    takenarray (col, row) := player %% sets selected row and column as owned by given player
    falling (col, row, player) %%calls on to "falling" proc
end turn

%%                                                                          *************************************
%%                                                                          **|THIS IS THE HEART OF THE BEAUTY|**
%%                                                                          *************************************

%% I go more indepth of what this proc does in the comments
function checker (player, col, row : int, var takenarray : array 1 .. 10, 1 .. 10 of int) : boolean
    var right, left, rightup, downright, upleft, downleft, down : int := 0
    var downTrend, rightTrend, leftTrend, rightupTrend, downrightTrend, upleftTrend, downleftTrend : boolean := false
    %% When the trend is not broken this means all the chips(so far) before the one played are not owned by the player

    for ab : 1 .. 3

	%% DOWN COUNT
	if row + ab <= 10 then %% if the row+ab from the chip just played is <= 10 then
	    if takenarray (col, row + ab) = player and downTrend = false then %% if row+ab from the chip just played is owned by the player and all the chips below it are owned by the player then
		down += 1 %% +1 to down count
	    elsif takenarray (col, row + ab) not= player then %% elsif row+ab from the chip just played is not owned by the player then
		downTrend := true %% down trend is broken
	    end if
	end if

	%% LEFT COUNT
	if col - ab >= 1 then %% if column-ab from the chip just played is >=1 then
	    if takenarray (col - ab, row) = player and leftTrend = false then %% if col-ab from the chip just played is owned by the player and left is not broken then
		left += 1 %% +1 to left count
	    elsif takenarray (col - ab, row) not= player then %% elsif col-ab from the chip just played is not owned by the player then
		leftTrend := true %% left trend is broken
	    end if
	end if
	%% RIGHT COUNT
	if col + ab <= 10 then %% if col+ab frome the chip just played is <=10 then
	    if takenarray (col + ab, row) = player and rightTrend = false then %% col+ab from the chip just played is owned by the player and the right trend is not broken then
		right += 1 %% +1 to right count
	    elsif takenarray (col + ab, row) not= player then %% elsif col+ab from the chip just played is not owned by the player then
		rightTrend := true %% right trend is broken
	    end if
	end if

	%% DOWNRIGHT COUNT
	if col + ab <= 10 and row + ab <= 10 then %% if the col+ab and the row+ab frome the chip just played is <=10 then
	    if takenarray (col + ab, row + ab) = player and downrightTrend = false then
		%% if the col+ab and the row+ab from the chip just played is owned by the player and the downright trend is not broken then
		downright += 1 %% +1 downright count
	    elsif takenarray (col + ab, row + ab) not= player then %% else if the col+ab and the row+ab from the chip just played is not owned by the player then
		downrightTrend := true %% downright trend has been broken
	    end if
	end if

	%% UPRIGHT COUNT
	if col + ab <= 10 and row - ab >= 1 then %% if col+ab from the chip just played is <=10 and row-ab from the chip just played is >=1 then
	    if takenarray (col + ab, row - ab) = player and rightupTrend = false then %% if col+ab and row-ab from the chip just played is owned by the player and the rightup trend is not broken then
		rightup += 1 %% +1 to rightup count
	    elsif takenarray (col + ab, row - ab) not= player then %% Elsif col+ab and row-ab is not owned by the player then
		rightupTrend := true %% rightupTrend is broken
	    end if
	end if

	%% DOWNLEFT COUNT
	if col - ab >= 1 and row + ab <= 10 then %% if col-ab from the chip just played is >=1 and row+ab from the chip just played is <=10 then
	    if takenarray (col - ab, row + ab) = player and downleftTrend = false then %% if col-ab and the row+ab is owned by the player and the downleft trend is not broken then
		downleft += 1 %% +1 to downleft count
	    elsif takenarray (col - ab, row + ab) not= player then %% Elsif col-ab and row+ab from the chip just played is not owned by the player then
		downleftTrend := true %% downleftTrend is broken
	    end if
	end if

	%% UPLEFT COUNT
	if col - ab >= 1 and row - ab >= 1 then %% if col-ab and row-ab is >=1 then
	    if takenarray (col - ab, row - ab) = player and upleftTrend = false then %% if col-ab and row-ab is owned by the player and the upleftTrend is not broken then
		upleft += 1 %% +1 to upleft count
	    elsif takenarray (col - ab, row - ab) not= player then %% Elsif col-ab and row-ab from the chip just played is not owned by the player then
		upleftTrend := true %% upleftTrend is broken
	    end if
	end if
    end for
    %%% Comment range below %%% FOR DEBUGING
    % if win = 1 then
    %     result true
    % end if
    %%%
    if down >= 3 or right + left >= 3 or rightup + downleft >= 3 or upleft + downright >= 3 then %if the pieces down, left/right, upleft/downright or rightup/downleft is = or > the 3 then
	result true %% result = true // because 3 down, left/right, upleft/downright or rightup/downleft + the 1 chip you just played = CONNECT4!!
    else
	result false
    end if
end checker

proc outcheck (var again : string) %% This proc gets keys while letting text stay on screen
    var key : string (1)
    if hasch then %% if any key is pressed then
	getch (key) %% get that key and store it in 'key'
	if key = chr (110) or key = chr (78) then %% if key = n then
	    again := "n"
	elsif key = chr (121) or key = chr (89) then %% elsif key = y then
	    again := "y"
	end if
    end if

end outcheck

%% This proc brings everything together
proc game
    %%sets scorearray for each player := 0
    var scorearray : array 1 .. 2 of int
    for q : 1 .. 2
	scorearray (q) := 0
    end for
    var key : string (1)
    var names : array 1 .. 2 of string
    var takenarray : array 1 .. 10, 1 .. 10 of int
    var player, col, row : int := 1
    var winwind, tab, outwind : int := 1
    var tie : boolean
    var temp : string := " "
    var again : string := " "
    %% 'getnames' tab
    tab := Window.Open ("screen:20;50,position:middle;middle,title:Connect 4 CPT")
    colourback (black) %%sets textback to black
    colour (brightgreen) %%sets text to brightgreen
    cls %% clears screen to back background black
    getnames (names) %% calls on to 'getnames' proc
    %%closes 'getnames' tab
    Window.Close (tab)
    %%game tab
    tab := Window.Open ("graphics:450;590,position:middle;middle,title:Connect 4 CPT")
    colourback (black)

    loop
	setup (takenarray, names, scorearray)
	col := 1
	tie := false
	for q : 1 .. 100 %% 1..100 is the max amount of turns possible
	    turn (player, names, col, row, takenarray)
	    exit when checker (player, col, row, takenarray) = true %% EXITS WHEN SOMEONE CONNECTS 4
	    if q = 100 then %% if q=100 max turns has been reach therefor
		tie := true %% IT'S A TIE
	    end if

	    if player = 1 then %% Switches between players
		player := 2
	    elsif player = 2 then
		player := 1
	    end if
	end for
	winwind := Window.Open ("graphics:midx;midy,position:middle;middle,title:Connect 4")
	colour (brightgreen)
	colourback (black)
	cls

	if player = 1 then %% For displaying which player won
	    temp := "ONE"
	else
	    temp := "TWO"
	end if
	locate (10, 26)
	put "PLAYER ", temp, " WINS THE GAME!!"
	locate (25 div 2, 21)
	put "Wanna play again? Please Enter(y or n)"

	if tie = false then %% if its not a tie then
	    scorearray (player) += 1 %% +1 scorearray to player who won
	elsif tie = true then
	    put "IT IS A DRAW!"
	end if
	if player = 1 then
	    Music.PlayFile ("Player_one.mp3")
	elsif player = 2 then
	    Music.PlayFile ("Player_two.mp3")
	end if

	loop
	    outcheck (again)
	    exit when again = "Y" or again = "y" or again = "N" or again = "n"
	end loop
	if again = "y" or again = "Y" then
	    again := " "
	    win := 0
	    Window.Close (winwind)
	else
	    Window.Close (winwind)
	    Window.Close (tab)
	    outwind := Window.Open ("graphics:190;110,position:middle;middle,title:Connect 4")
	    Window.SetActive (outwind)
	    colour (brightgreen)
	    colourback (black)
	    cls
	    locate (3, 5)
	    put "GAME OVER!!"
	    Music.PlayFile ("GAME OVER.mp3")

	end if
	delay (225)
	Window.SetActive (tab)

	%sets the playing window as the active window and closes the winner window
	exit when again = "n" or again = "N"
	%exits the playing loop when they answer n to playing again
    end loop
    delay (100)
    Window.Close (outwind)
end game

game %% LET THE GAMES BEGIN
