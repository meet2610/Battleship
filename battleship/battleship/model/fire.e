note
	description: "Summary description for {FIRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIRE

inherit
	MOVE
		rename out as out1 end

create
	make

feature {NONE} -- constructor
	coordinate1 : TUPLE[row: INTEGER_64; column: INTEGER_64]
	undo_msg : STRING_8
	state: INTEGER
	undo_score : INTEGER
	valid_shot : BOOLEAN

	make(coord1: TUPLE[row: INTEGER_64; column: INTEGER_64])
		do
			coordinate1 := coord1
			undo_msg := ""
			state := 0
			undo_score:= 0
			valid_shot := False

		end

feature
	
	set_undo_msg (msg: STRING_8)
		-- stores the message output of ETF_MODEL for the given move
		do
			undo_msg := msg
		end

	set_state (i: INTEGER)
		-- stores the state number at which this move occured
		do
			state := i
		end
	set_undo_score (i: INTEGER)
		-- stores the change in score that occured by this move
		do
			undo_score:= i
		end

	set_shot_valid (b: BOOLEAN)
		-- stores information regarding if this shot was valid or not
		do
			valid_shot := b
		end

	get_shot_valid : BOOLEAN
		-- returns if move was valid
		do
			Result := valid_shot
		end
	get_undo_msg: STRING_8
		-- returns the output message from ETF_MODEL that was stored
		do
			Result := undo_msg
		end
	get_state: INTEGER
		-- returns the state at which this move occured
		do
			Result := state
		end
	get_undo_score: INTEGER
		-- returns how much the score changed by with this move
		do
			Result := undo_score
		end

	execute

	local
			temp: INTEGER


    	do
			-- perform some update on the model state
			if (valid_shot) then
			if (model.debug_mode) then
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
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
						model.set_hit (true)
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
						model.set_hit (true)
						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
			end
			else
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('O')
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
						model.set_hit (true)
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
						model.set_hit (true)
						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
				end
				model.update_shot
			end

    	end


	undo
		local
			temp: INTEGER
		do
			if (valid_shot) then


			if (model.debug_mode) then
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
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
--						model.set_hit (true)
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end
					else
--					model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
						from
						temp:= s.item.col + 1
					until
						temp = s.item.col + 1 + s.item.size
					loop
					if ((s.item.row ~ coordinate1.row) and (temp ~ coordinate1.column)) then
					model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('h')
--						model.set_hit (true)
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
			end
			else
				model.board[coordinate1.row.as_integer_32, coordinate1.column.as_integer_32] := create {SHIP_ALPHABET}.make ('_')
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
--						model.set_hit (true)
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
--						model.set_hit (true)
--						model.ship_hit (s.item)
					end
					temp := temp+1
					end

					end
				end
			end
			model.undo_shot
			model.undo_score (undo_score)
			end


		end

	redo
		do
			execute
		end

end
