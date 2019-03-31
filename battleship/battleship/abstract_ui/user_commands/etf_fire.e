note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit

	ETF_FIRE_INTERFACE
		redefine fire end

create
	make

feature -- command

	fire(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64])
		-- Signals ETF_MODEL to output error messages if there is an error
		-- If there are no errors, fires a SHOT
		-- Stores information about the bomb as MOVE FIRE in board history
		require else
			fire_precond(coordinate1)
		local
			temp: INTEGER
			op: FIRE
    	do
			-- perform some update on the model state
			if(not (model.game_over or (model.game_count < 1))) then
				create op.make (coordinate1)
			if (not model.no_more_shots) then
			if (model.valid_cordinates(coordinate1)) then



			if (not model.repeat_fire) then
				op.set_shot_valid (true)
				model.history.extend_history (op)

				model.update_shot
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
			end

			else
			model.set_invalid_cord (true)
			end
			else
			model.set_shot_msg (true)

			end
			if (not op.get_shot_valid) then
				model.history.extend_history (op)
			end
			else
			model.set_go_msg (true)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end



end
