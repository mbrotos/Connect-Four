# Connect-Four
This was a cumulative project created in 2016 for my grade 10 computer science course (ICS 201). Turing, a Pascal-like programming language was used to create this game. We also explored parallel port interfacing using the native parallelput command in other projects.

## Scoring Algorithm
``` turing
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
	%% RIGHT COUNT ....
  
	%% DOWNRIGHT COUNT
	if col + ab <= 10 and row + ab <= 10 then %% if the col+ab and the row+ab frome the chip just played is <=10 then
	    if takenarray (col + ab, row + ab) = player and downrightTrend = false then
		%% if the col+ab and the row+ab from the chip just played is owned by the player and the downright trend is not broken then
		downright += 1 %% +1 downright count
	    elsif takenarray (col + ab, row + ab) not= player then %% else if the col+ab and the row+ab from the chip just played is not owned by the player then
		downrightTrend := true %% downright trend has been broken
	    end if
	end if

	%% UPRIGHT COUNT ...

	%% DOWNLEFT COUNT ...

	%% UPLEFT COUNT ...
  
  ...
end checker
```



## Screenshots
<img src="/images/setup.png" alt="drawing" width="500"/>

<img src="/images/game.png" alt="drawing" width="500"/>
