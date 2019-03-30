note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOMB
inherit

	ETF_BOMB_INTERFACE
		redefine bomb end
create
	make
feature -- command
	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			bomb_precond(coordinate1, coordinate2)
		local
			temp: INTEGER
			op: BOMB
    	do
			-- perform some update on the model state
			if(not (model.game_over or (model.game_count < 1))) then
				create op.make (coordinate1, coordinate2, false)
			if(not model.no_more_bombs) then
			if (model.valid_bomb(coordinate1,coordinate2)) then

			if (model.valid_cordinates(coordinate1) and model.valid_cordinates(coordinate2)) then




			if (not model.repeat_fire) then
				model.update_bomb
				op.set_bomb_valid (true)
				model.history.extend_history (op)
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
			end

		--		model.bad_bomb (false)

			else
				model.set_invalid_cord (true)
			end

			end
			else
				model.set_bomb_msg(true)

			end
			if (not op.get_bomb_valid) then
				model.history.extend_history (op)
			end
			else
			model.set_go_msg (true)
			end



			etf_cmd_container.on_change.notify ([Current])
    	end



end
