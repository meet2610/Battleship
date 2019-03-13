note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DEBUG_TEST
inherit
	ETF_DEBUG_TEST_INTERFACE
		redefine debug_test end
create
	make
feature -- command
	debug_test(level: INTEGER_64)
		require else
			debug_test_precond(level)
    		local
			new_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
			op : MAKE_GAME


    	do
			-- perform some update on the model state
			if (model.game_count < 1 ) then
			model.make_empty
			new_ships := model.generate_ships (false,2,1)

			if (level ~ 13) then
				new_ships:= model.generate_ships (true,4, 2)
			elseif (level ~ 14) then
				new_ships:= model.generate_ships (true,6, 3)
			elseif (level ~ 15) then
				new_ships:= model.generate_ships (true,8, 5)
			elseif (level ~ 16) then
				new_ships:= model.generate_ships (true,12, 7)

			end
		   model.set_values (level)
		   model.set_new_game (true)

			place_new_ships(model.board, new_ships)

			else
				if (model.game_over) then
					model.make_empty
			new_ships := model.generate_ships (false,2,1)

			if (level ~ 13) then
				new_ships:= model.generate_ships (true,4, 2)
			elseif (level ~ 14) then
				new_ships:= model.generate_ships (true,6, 3)
			elseif (level ~ 15) then
				new_ships:= model.generate_ships (true,8, 5)
			elseif (level ~ 16) then
				new_ships:= model.generate_ships (true,12, 7)

			end
		   model.set_values (level)
		   model.set_new_game (true)

			place_new_ships(model.board, new_ships)
				else
				model.set_game_active (true)
				end
			end

--			if(model.game_count > 0) then
				create op.make(true)
				model.history.extend_history (op)
--			end

			etf_cmd_container.on_change.notify ([Current])


    	end

feature

	place_new_ships(board: ARRAY2[SHIP_ALPHABET]; new_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]])
			-- Place the randomly generated positions of `new_ships' onto the `board'.
			-- Notice that when a ship's row and column are given,
			-- its coordinate starts with (row + 1, col) for a vertical ship,
			-- and starts with (row, col + 1) for a horizontal ship.
		require
			across new_ships.lower |..| new_ships.upper as i1 all
			across new_ships.lower |..| new_ships.upper as j1 all
				i1.item /= j1.item implies not model.collide_with_each_other (new_ships[i1.item], new_ships[j1.item])
			end
			end
		do
			across
				new_ships as new_ship
			loop
				if new_ship.item.dir then
					-- Vertical ship
					across
						1 |..| new_ship.item.size as ii
					loop
						board[new_ship.item.row + ii.item, new_ship.item.col] := create {SHIP_ALPHABET}.make ('v')
					end
				else
					-- Horizontal ship
					across
						1 |..| new_ship.item.size as ii
					loop
						board[new_ship.item.row, new_ship.item.col + ii.item] := create {SHIP_ALPHABET}.make ('h')
					end
				end
			end
		end

end
