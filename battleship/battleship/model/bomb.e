note
	description: "Summary description for {BOMB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOMB

inherit
	MOVE
		rename out as out1 end

create
	make

feature {NONE} -- constructor
	coordinate1 : TUPLE[row: INTEGER_64; column: INTEGER_64]
	coordinate2 : TUPLE[row: INTEGER_64; column: INTEGER_64]
	undo_score: INTEGER
	undo_msg : STRING_8
	state: INTEGER
	valid_bomb : BOOLEAN

	make(coord1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coord2: TUPLE[row: INTEGER_64; column: INTEGER_64]; valid: BOOLEAN)
		do
			coordinate1 := coord1
			coordinate2 := coord2
			undo_msg := ""
			undo_score := 0
			valid_bomb := valid

		end

feature

	set_undo_msg (msg: STRING_8)
		do
			undo_msg := msg
		end

	set_state (i: INTEGER)
		do
			state := i
		end
	set_undo_score (i: INTEGER)
		do
			undo_score:= i
		end

	set_bomb_valid (b: BOOLEAN)
		do
			valid_bomb := b
		end

	get_bomb_valid : BOOLEAN
		do
			Result := valid_bomb
		end
	get_undo_msg: STRING_8
		do
			Result := undo_msg
		end
	get_state: INTEGER
		do
			Result := state
		end
	get_undo_score: INTEGER
		do
			Result := undo_score
		end



	execute
		local
			temp: INTEGER
    	do
			-- perform some update on the model state
			if valid_bomb then

			if (model.debug_mode) then
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
				model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
				model.set_hit (false)
				across model.ships as s
				loop
					if (s.item.dir) then
					from
						temp:= s.item.row + 1
					until
						temp = s.item.row + 1 + s.item.size
					loop
					if ((temp ~ coordinate1.row) and (s.item.col ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					if ((temp ~ coordinate2.row) and (s.item.col ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					temp := temp+1
					end
					else
						from
						temp:= s.item.col + 1
					until
						temp = s.item.col + 1 + s.item.size
					loop
					if ((s.item.row ~ coordinate1.row) and (temp ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					if ((s.item.row ~ coordinate2.row) and (temp ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
			else
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
				model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
				model.set_hit (false)
				across model.ships as s
				loop
					if (s.item.dir) then
					from
						temp:= s.item.row + 1
					until
						temp = s.item.row + 1 + s.item.size
					loop
					if ((temp ~ coordinate1.row) and (s.item.col ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					if ((temp ~ coordinate2.row) and (s.item.col ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					temp := temp+1
					end
					else
						from
						temp:= s.item.col + 1
					until
						temp = s.item.col + 1 + s.item.size
					loop
					if ((s.item.row ~ coordinate1.row) and (temp ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					if ((s.item.row ~ coordinate2.row) and (temp ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('X')
						if(not model.hit) then
						model.set_hit (true)
						end
						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
				end
				model.update_bomb
				end
		end

	undo
		local
			temp: INTEGER
		do
			if valid_bomb then

			if (model.debug_mode) then

				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
				model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--				model.set_hit (false)
				across model.ships as s
				loop
					if (s.item.dir) then
					from
						temp:= s.item.row + 1
					until
						temp = s.item.row + 1 + s.item.size
					loop
					if ((temp ~ coordinate1.row) and (s.item.col ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('v')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					if ((temp ~ coordinate2.row) and (s.item.col ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('v')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end
					else
						from
						temp:= s.item.col + 1
					until
						temp = s.item.col + 1 + s.item.size
					loop
					if ((s.item.row ~ coordinate1.row) and (temp ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('h')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					if ((s.item.row ~ coordinate2.row) and (temp ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('h')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
			else
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
				model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--				model.set_hit (false)
				across model.ships as s
				loop
					if (s.item.dir) then
					from
						temp:= s.item.row + 1
					until
						temp = s.item.row + 1 + s.item.size
					loop
					if ((temp ~ coordinate1.row) and (s.item.col ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					if ((temp ~ coordinate2.row) and (s.item.col ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end
					else
						from
						temp:= s.item.col + 1
					until
						temp = s.item.col + 1 + s.item.size
					loop
					if ((s.item.row ~ coordinate1.row) and (temp ~ coordinate1.column)) then
						model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					if ((s.item.row ~ coordinate2.row) and (temp ~ coordinate2.column)) then
						model.board[coordinate2.row.as_integer_32, coordinate2.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
--						if(not model.hit) then
--						model.set_hit (true)
--						end
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
				end
					model.undo_bomb
					model.undo_score (undo_score)
				end



		end

	redo
		do
			execute
		end

end
