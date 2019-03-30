note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make_empty

feature -- random generators

	rand_gen: RANDOM_GENERATOR
			-- random generator for normal mode
			-- it's important to keep this as an attribute
		attribute
			create Result.make_random
		end

	debug_gen: RANDOM_GENERATOR
			-- deterministic generator for debug mode
			-- it's important to keep this as an attribute
		attribute
			create Result.make_debug
		end

feature -- attributes

	board: ARRAY2 [SHIP_ALPHABET]

	board_s: INTEGER_32

	destroyed_ship: INTEGER_32

	ship_count: INTEGER_32

	thrown_shots: INTEGER_32

	no_more_bombs: BOOLEAN

	no_more_shots: BOOLEAN

	no_bombs_shots: BOOLEAN

	invalid_cord: BOOLEAN

	repeat_fire: BOOLEAN

	switch_debug: BOOLEAN

	miss: BOOLEAN

	hit: BOOLEAN

	sunk: BOOLEAN

	max_shots: INTEGER_32

	max_bombs: INTEGER_32

	thrown_bombs: INTEGER_32

	game_active: BOOLEAN

	game_count: INTEGER_32

	bomb_msg: BOOLEAN

	shot_msg: BOOLEAN

	ship_sunk: BOOLEAN

	ship_msg: STRING_8

	score: INTEGER_32

	bad_bomb_msg: BOOLEAN

	max_score: INTEGER_32

	new_game: BOOLEAN

	total_score: INTEGER_32

	go_msg: BOOLEAN

	no_game: STRING_8

	max_total_score: INTEGER_32

	game_started: BOOLEAN

	game_over: BOOLEAN

	ship_1: STRING_8

	ship_2: STRING_8

	played_move: BOOLEAN

	debug_mode: BOOLEAN

	valid_setup_msg : BOOLEAN

	valid_setup_out : STRING_8

	give_up_msg : BOOLEAN

	give_up_out : STRING_8

	prev_game_revert: BOOLEAN

	history : HISTORY

	no_undoredo : BOOLEAN

	no_undoredo_msg : STRING_8

	undoredo : BOOLEAN

	undoredo_msg : STRING_8

	ships: ARRAYED_LIST [TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]]
		attribute
			create Result.make_filled (0)
		end

	Row_indices: ARRAY [CHARACTER_8]
			-- creation
			--	make
			--			-- Initialization for `Current`.
			--		do
			--			create s.make_empty
			--			z := 0
			--		end
			--makes an empty board
		once
			Result := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

feature

	make_empty
			-- utilities
		do
			create board.make_filled (create {SHIP_ALPHABET}.make ('_'), 12, 12)
			create history.make
			history.wipe_out

			undoredo := False
			undoredo_msg := ""
			no_undoredo := False
			no_undoredo_msg := ""
			give_up_out := ""
			valid_setup_msg:= False
			valid_setup_out := ""
			game_started := False
			debug_mode := False
			no_more_bombs := False
			no_more_shots := False
			no_bombs_shots := False
			invalid_cord := False
			repeat_fire := False
			bad_bomb_msg := False
			miss := False
			hit := False
			game_active := False
			bomb_msg := False
			shot_msg := False
			new_game := False
			ship_msg := ""
			no_game := ""
			ship_1 := ""
			ship_2 := ""
			played_move := False
			repeat_fire := False
		end

feature

	generate_ships (is_debug_mode: BOOLEAN; board_size: INTEGER_32; num_ships: INTEGER_32): ARRAYED_LIST [TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]]
		local
			size: INTEGER_32
			c, r: INTEGER_32
			d: BOOLEAN
			gen: RANDOM_GENERATOR
			new_ship: TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]
		do
			board_s := board_size
			ship_count := num_ships
			game_started := True
			debug_mode := is_debug_mode
			if (not debug_mode) then
--				debug_gen.revert
			end
			create Result.make (num_ships)
			if is_debug_mode then
				gen := debug_gen
			else
				gen := rand_gen
			end
			from
				size := num_ships
			until
				size = 0
			loop
				d := (gen.direction \\ 2 = 1)
				if d then
					c := (gen.column \\ board_size) + 1
					r := (gen.row \\ (board_size - size)) + 1
				else
					r := (gen.row \\ board_size) + 1
					c := (gen.column \\ (board_size - size)) + 1
				end
				new_ship := [size, r, c, d]
				if not collide_with (Result, new_ship) then
					Result.extend (new_ship)
					size := size - 1
				end
				gen.forth
			end
			ships := Result
			create history.make

		end

	collide_with_each_other (ship1, ship2: TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]): BOOLEAN
		local
			ship1_head_row, ship1_head_col, ship1_tail_row, ship1_tail_col: INTEGER_32
			ship2_head_row, ship2_head_col, ship2_tail_row, ship2_tail_col: INTEGER_32
		do
			ship1_tail_row := ship1.row
			ship1_tail_col := ship1.col
			if ship1.dir then
				ship1_tail_row := ship1_tail_row + 1
				ship1_head_row := ship1_tail_row + ship1.size - 1
				ship1_head_col := ship1_tail_col
			else
				ship1_tail_col := ship1_tail_col + 1
				ship1_head_col := ship1_tail_col + ship1.size - 1
				ship1_head_row := ship1_tail_row
			end
			ship2_tail_row := ship2.row
			ship2_tail_col := ship2.col
			if ship2.dir then
				ship2_tail_row := ship2_tail_row + 1
				ship2_head_row := ship2_tail_row + ship2.size - 1
				ship2_head_col := ship2_tail_col
			else
				ship2_tail_col := ship2_tail_col + 1
				ship2_head_col := ship2_tail_col + ship2.size - 1
				ship2_head_row := ship2_tail_row
			end
			Result := ship1_tail_col <= ship2_head_col and then ship1_head_col >= ship2_tail_col and then ship1_tail_row <= ship2_head_row and then ship1_head_row >= ship2_tail_row
		end

	collide_with (existing_ships: ARRAYED_LIST [TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]]; new_ship: TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN]): BOOLEAN
		do
			across
				existing_ships as existing_ship
			loop
				Result := Result or collide_with_each_other (new_ship, existing_ship.item)
			end
		ensure
				Result = across
					existing_ships as existing_ship
				some
					collide_with_each_other (new_ship, existing_ship.item)
				end
		end

	set_values (level: INTEGER_64)
		do
			if (prev_game_revert) then
				revert_values
				set_go_msg(false)
				give_up_msg := False
				prev_game_revert := False
				game_over := True
					played_move := False
			end
			if (level ~ 13) then
				max_shots := 8
				max_bombs := 2
				max_score := 3
			elseif (level ~ 14) then
				max_shots := 16
				max_bombs := 3
				max_score := 6
			elseif (level ~ 15) then
				max_shots := 24
				max_bombs := 5
				max_score := 15
			elseif (level ~ 16) then
				max_shots := 40
				max_bombs := 7
				max_score := 28
			end
			thrown_bombs := 0
			thrown_shots := 0
			destroyed_ship := 0
			if (switch_debug ~ debug_mode) then
				max_total_score := max_score + max_total_score
				score := 0
			else
				max_total_score := max_score
				switch_debug := debug_mode
				game_count := 0
				score := 0
				total_score := 0
			end
			game_count := game_count + 1
			game_over := False
		end

	setup_values (ms1 : INTEGER_32; mb1 : INTEGER_32; score1: INTEGER_32)
		do
			if (prev_game_revert) then
				revert_values
				prev_game_revert := False
				set_go_msg(false)
				game_over := False
				give_up_msg := False
					played_move := False
			end
			max_score:= score1
			max_bombs := mb1
			max_shots := ms1
			thrown_bombs := 0
			thrown_shots := 0
			destroyed_ship := 0
			if (switch_debug ~ debug_mode) then
				max_total_score := max_score + max_total_score
				score := 0
			else
				max_total_score := max_score
				switch_debug := debug_mode
				game_count := 0
				score := 0
				total_score := 0
			end
			game_count := game_count + 1
			game_over := False
		end

	revert_stuff
		do
			undoredo := False
			undoredo_msg := ""
			no_undoredo := False
			no_undoredo_msg := ""
			give_up_out := ""
			valid_setup_msg:= False
			valid_setup_out := ""
--			game_started := False
--			debug_mode := False
--			no_more_bombs := False
--			no_more_shots := False
			no_bombs_shots := False
			invalid_cord := False
			repeat_fire := False
			bad_bomb_msg := False
			miss := False
			hit := False
--			game_active := False
			bomb_msg := False
			shot_msg := False
			new_game := False
			ship_msg := ""
			no_game := ""
			ship_1 := ""
			ship_2 := ""
--			played_move := False
			repeat_fire := False
		end
	revert_values
		  do
		  	max_total_score := max_total_score - max_score
		  	total_score := total_score - score
		  	score:= 0
		  	game_count := game_count -1

		  end

	undoredo_change (b: BOOLEAN; msg: STRING_8)
		do

			undoredo := b
			undoredo_msg := msg

		end

	set_undoredo (b: BOOLEAN; msg: STRING_8)
		do
			no_undoredo := b
			no_undoredo_msg := msg

		end

	undo_bomb
		do
			thrown_bombs := thrown_bombs -1
			if (thrown_bombs ~ 0 and thrown_shots ~ 0) then
				played_move := False
			end
			no_more_bombs := False
		end

	undo_shot
		do
			thrown_shots := thrown_shots -1
			if (thrown_bombs ~ 0 and thrown_shots ~ 0) then
				played_move := False
			end
			no_more_shots := False
		end

	undo_score (i: INTEGER)
		do
			score := score - i
			total_score := total_score - i
			if (i > 0) then
				destroyed_ship := destroyed_ship - 1
			end
		end

	update_bomb
		do
			thrown_bombs := thrown_bombs + 1
			played_move := true
			if (thrown_bombs = max_bombs) then
				no_more_bombs := True
			end
		end

	update_shot
		do
			played_move := true
			thrown_shots := thrown_shots + 1
			if (thrown_shots = max_shots) then
				no_more_shots := True
			end
		end

	valid_cordinates (cord: TUPLE [row: INTEGER_64; column: INTEGER_64]): BOOLEAN
		do
			Result := False
			if (cord.row <= board_s.to_integer_64 and cord.row >= 1 and cord.column <= board_s.to_integer_64 and cord.column >= 1) then
				Result := True
			end
			if (Result) then
				repeat_fire := (board [cord.row.as_integer_32, cord.column.as_integer_32].item = 'X' or board [cord.row.as_integer_32, cord.column.as_integer_32].item = 'O') or repeat_fire

			end
		end

	valid_bomb (cord1: TUPLE [row: INTEGER_64; column: INTEGER_64]; cord2: TUPLE [row: INTEGER_64; column: INTEGER_64]): BOOLEAN
		do
			Result := False
			if (cord1.column ~ cord2.column) then
				Result := ((cord1.row.as_integer_32 ~ (cord2.row.as_integer_32 + 1)) or (cord1.row.as_integer_32 ~ (cord2.row.as_integer_32 - 1)))
			elseif (cord1.row.as_integer_32 ~ cord2.row.as_integer_32) then
				Result := ((cord1.column.as_integer_32 ~ (cord2.column.as_integer_32 + 1)) or (cord1.column.as_integer_32 ~ (cord2.column.as_integer_32 - 1)))
			end
			bad_bomb (not Result)
			if (Result) then
				repeat_fire := (board [cord1.row.as_integer_32, cord1.column.as_integer_32].item = 'X' or board [cord1.row.as_integer_32, cord1.column.as_integer_32].item = 'O')
				repeat_fire := (board [cord2.row.as_integer_32, cord2.column.as_integer_32].item = 'X' or board [cord2.row.as_integer_32, cord2.column.as_integer_32].item = 'O') or repeat_fire
			end
		end



	setup_valid (b: BOOLEAN; msg: STRING_8)
		do
			valid_setup_msg := b

			if (game_count > 0) then
				valid_setup_out := " " + msg + " -> Start a new game%N"
			else
				valid_setup_out := " " + msg + " -> Start a new game"
			end
		end

	giveup( b:BOOLEAN; msg: STRING_8)
		do
			give_up_msg := b
			give_up_out := " " + msg + "%N"

		end

	bad_bomb (b: BOOLEAN)
		do
			bad_bomb_msg := b
		end

	set_game_active (b: BOOLEAN)
		do
			game_active := b
		end

	set_invalid_cord (b: BOOLEAN)
		do
			invalid_cord := b
		end

	set_bomb_msg (b: BOOLEAN)
		do
			bomb_msg := b
		end

	set_shot_msg (b: BOOLEAN)
		do
			shot_msg := b
		end

	set_miss (b: BOOLEAN)
		do
			miss := b
		end

	set_hit (b: BOOLEAN)
		do
			hit := b
		end

	set_new_game (b: BOOLEAN)
		do
			new_game := b
		end

	set_go_msg (b: BOOLEAN)
		do
			go_msg := b
			if (game_count > 0) then
				no_game := " Game not started -> Start a new game%N"
			else
				no_game := " Game not started -> Start a new game"
			end
		end

	ship_hit (sh: TUPLE [size: INTEGER_32; row: INTEGER_32; col: INTEGER_32; dir: BOOLEAN])
			-- output
			-- Return string representation of current game.
			-- You may reuse this routine.
		local
			temp: INTEGER_32
			sunk_count: INTEGER_32
		do
			sunk_count := 0
			if (sh.dir) then
				from
					temp := sh.row + 1
				until
					temp = sh.row + 1 + sh.size
				loop
					if (board [temp, sh.col].item.is_equal ('X')) then
						sunk_count := sunk_count + 1
					end
					temp := temp + 1
				end
			else
				from
					temp := sh.col + 1
				until
					temp = sh.col + 1 + sh.size
				loop
					if (board [sh.row, temp].item.is_equal ('X')) then
						sunk_count := sunk_count + 1
					end
					temp := temp + 1
				end
			end
			if (sunk_count ~ sh.size) then
				ship_sunk := True
				if (ship_1.is_equal ("")) then
					ship_1 := "" + sh.size.out + "x1"
				else
					ship_2 := "" + sh.size.out + "x1"
				end
				if (ship_2.is_equal ("") or ship_2.is_equal (ship_1)) then
					ship_msg := " OK -> " + sh.size.out + "x1 ship sunk! Keep Firing!%N"
				else
					ship_msg := " OK -> " + ship_1 + " and " + ship_2 + " ships sunk! Keep Firing!%N"
				end
				score := score + sh.size
				if (history.on_item) then
					history.item.set_undo_score (sh.size)
				end
				total_score := sh.size + total_score
				destroyed_ship := destroyed_ship + 1
			end
			if (score ~ max_score) then
				if (ship_2.is_equal ("") or ship_2.is_equal (ship_1)) then
					ship_msg := " OK -> " + sh.size.out + "x1 ship sunk! You Win!%N"
				else
					ship_msg := " OK -> " + ship_1 + " and " + ship_2 + " ships sunk! You Win!%N"
				end
				game_active := False
				game_over := True
			end
			if (no_more_shots and no_more_bombs) then
				if (ship_2.is_equal ("") or ship_2.is_equal (ship_1)) then
					ship_msg := " OK -> " + sh.size.out + "x1 ship sunk! Game Over!%N"
				else
					ship_msg := " OK -> " + ship_1 + " and " + ship_2 + " ships sunk! Game Over!%N"
				end
				game_active := False
				game_over := True
			end
		end

feature

	out: STRING_8
			-- New string containing terse printable representation
			-- of current object
		local
			fi: FORMAT_INTEGER
		do
			create fi.make (2)
			create Result.make_from_string ("")


			if (z = 0) then
				Result.append (" OK -> Start a new game")
			elseif (game_active) then
				if (not played_move) then
					Result.append (" Game already started -> Fire Away!%N")
				else
					Result.append (" Game already started -> Keep Firing!%N")
				end
				game_active := False
			elseif (undoredo) then
				Result.append (undoredo_msg)
					ship_sunk := False
				ship_1 := ""
				ship_2 := ""
				ship_msg := ""
			elseif (bomb_msg) then
				Result.append (" No bombs remaining -> Keep Firing!%N")
				bomb_msg := False
			elseif (shot_msg) then
				Result.append (" No shots remaining -> Keep Firing!%N")
				shot_msg := False
			elseif (bad_bomb_msg) then
				if (played_move) then
					Result.append (" Bomb coordinates must be adjacent -> Keep Firing!%N")
				else
					Result.append (" Bomb coordinates must be adjacent -> Fire Away!%N")
				end
				bad_bomb_msg := False
			elseif (invalid_cord) then
				if (played_move) then
					Result.append (" Invalid coordinate -> Keep Firing!%N")
				else
					Result.append (" Invalid coordinate -> Fire Away!%N")
				end

				invalid_cord := False

			elseif (new_game) then
				Result.append (" OK -> Fire Away!%N")
				new_game := False
			elseif (go_msg) then
				Result.append (no_game)
				go_msg := False
			elseif (give_up_msg) then
				Result.append (give_up_out)

--				set_go_msg(true)
				game_over := True
--				game_active := False
			elseif (valid_setup_msg) then
				Result.append (valid_setup_out)
				valid_setup_out := ""
				valid_setup_msg := false
			elseif (repeat_fire) then
				Result.append (" Already fired there -> Keep Firing!%N")
				repeat_fire := False
			elseif (ship_sunk) then
				Result.append (ship_msg)
				ship_sunk := False
				ship_1 := ""
				ship_2 := ""
				ship_msg := ""
			elseif (no_undoredo) then
				Result.append (no_undoredo_msg)
				set_undoredo (false, "")
				undoredo := true


			elseif (hit) then
				if (no_more_bombs and no_more_shots) then
					Result.append (" OK -> Hit! Game Over!%N")
					game_over := True
					played_move := False
				else
					Result.append (" OK -> Hit! Keep Firing!%N")
					played_move := True
				end
			elseif (not hit) then
				if (no_more_bombs and no_more_shots) then
					Result.append (" OK -> Miss! Game Over!%N")
					game_over := True
					played_move := False
				else
					Result.append (" OK -> Miss! Keep Firing!%N")
					played_move := True
				end
			end
			if (game_over) then
				history.wipe_out
			end
			if(history.on_item and not (undoredo)) then
				history.item.set_undo_msg(Result.out)
				history.item.set_state (z)
			else
				undoredo_change (false, "")
			end
			Result.prepend("  state " + z.out)
			if (game_started) then
				Result.append ("   ")
			end
			across
				1 |..| board_s as i
			loop
				Result.append (" " + fi.formatted (i.item))
			end
			across
				1 |..| board_s as i
			loop
				Result.append ("%N  " + Row_indices [i.item].out)
				across
					1 |..| board_s as j
				loop
					Result.append ("  " + board [i.item, j.item].out)
				end
			end
			if (game_started) then
				Result.append (stats)
			end
			if(give_up_msg) then
					game_over := True
					played_move := False

					give_up_msg := False

					prev_game_revert:= True

			end
--			Result.append("%NHistory count: " + history.count.out)
--		revert_stuff
			default_update
		end

	stats: STRING_8
		do
			create Result.make_from_string ("")
			if (not (debug_mode ~ True)) then
				Result.append ("%N  Current Game: " + game_count.out)
			else
				Result.append ("%N  Current Game (debug): " + game_count.out)
			end
			Result.append ("%N  Shots: " + thrown_shots.out + "/" + max_shots.out)
			Result.append ("%N  Bombs: " + thrown_bombs.out + "/" + max_bombs.out)
			Result.append ("%N  Score: " + score.out + "/" + max_score.out)
			Result.append (" (Total: " + total_score.out + "/" + max_total_score.out + ")")
			Result.append ("%N  Ships: " + destroyed_ship.out + "/" + ship_count.out)
			Result.append ("%N")
			if (debug_mode) then
				Result.append (ships_out)
			else
				Result.append (sunk_ship)
			end
		end

	ships_out: STRING_8
		local
			temp: INTEGER_32
			sunk_count: INTEGER_32
			sunk_ship_count: INTEGER_32
		do
			create Result.make_from_string ("")
			sunk_ship_count := 0
			across
				ships as sh
			loop
				sunk_count := 0
				Result.append ("    " + sh.item.size.out + "x1: ")
				if (sh.item.dir) then
					from
						temp := sh.item.row + 1
					until
						temp = sh.item.row + 1 + sh.item.size
					loop
						if (sh.item.col >= 10) then
							Result.append ("[" + Row_indices.at (temp).out + "," + sh.item.col.out + "]->" + board [temp, sh.item.col].item.out)
						else
						Result.append ("[" + Row_indices.at (temp).out + ", " + sh.item.col.out + "]->" + board [temp, sh.item.col].item.out)
						end
						if (not (temp = sh.item.row + sh.item.size)) then
							Result.append (";")
						end
						temp := temp + 1
					end
				else
					from
						temp := sh.item.col + 1
					until
						temp = sh.item.col + 1 + sh.item.size
					loop
						if (temp >= 10) then
						Result.append ("[" + Row_indices.at (sh.item.row).out + "," + temp.out + "]->" + board [sh.item.row, temp].item.out)
						else
						Result.append ("[" + Row_indices.at (sh.item.row).out + ", " + temp.out + "]->" + board [sh.item.row, temp].item.out)
						end
						if (not (temp = sh.item.col + sh.item.size)) then
							Result.append (";")
						end
						temp := temp + 1
					end
				end
				if (not sh.is_last) then
					Result.append ("%N")
				end
			end
			if (sunk_ship_count ~ ship_count) then
				game_started := False
				game_over := True
			end
		end

	sunk_ship: STRING_8
		local
			temp: INTEGER_32
			sunk_count: INTEGER_32
			sunk_ship_count: INTEGER_32
		do
			create Result.make_from_string ("")
			sunk_ship_count := 0
			across
				ships as sh
			loop
				sunk_count := 0
				if (sh.item.dir) then
					from
						temp := sh.item.row + 1
					until
						temp = sh.item.row + 1 + sh.item.size
					loop
						if (board [temp, sh.item.col].item.is_equal ('X')) then
							sunk_count := sunk_count + 1
						end
						temp := temp + 1
					end
				else
					from
						temp := sh.item.col + 1
					until
						temp = sh.item.col + 1 + sh.item.size
					loop
						if (board [sh.item.row, temp].item.is_equal ('X')) then
							sunk_count := sunk_count + 1
						end
						temp := temp + 1
					end
				end
				if (sunk_count ~ sh.item.size) then
					Result.append ("    " + sh.item.size.out + "x" + "1: Sunk")
					sunk_ship_count := sunk_ship_count + 1
				else
					Result.append ("    " + sh.item.size.out + "x" + "1: Not Sunk")
				end
				if (not sh.is_last) then
					Result.append ("%N")
				end
			end
			if (sunk_ship_count ~ ship_count) then
				game_started := False
				game_over := True
			end
		end

feature

	z: INTEGER_32

feature

	default_update
		do
			z := z + 1
		end

	reset
		do
			make_empty
		end

end -- class ETF_MODEL

