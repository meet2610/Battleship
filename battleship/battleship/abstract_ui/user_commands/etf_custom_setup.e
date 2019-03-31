note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CUSTOM_SETUP
inherit
	ETF_CUSTOM_SETUP_INTERFACE
		redefine custom_setup end
create
	make
feature -- command
	custom_setup(dimension: INTEGER_64 ; ships: INTEGER_64 ; max_shots: INTEGER_64 ; num_bombs: INTEGER_64)
		-- Signals ETF_MODEL to output error messages if there is an error
		-- If there are no errors, creates a new game
		-- Stores information about the new game as MOVE MAKE_GAME in board history
		require else
			custom_setup_precond(dimension, ships, max_shots, num_bombs)
    	local
			new_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
			op: MAKE_GAME


    	do
			-- perform some update on the model state
			if (model.game_count < 1 ) then
			if (valid_setup(dimension, ships, max_shots, num_bombs)) then
				model.make_empty
				new_ships := model.generate_ships(false, dimension.as_integer_32, ships.as_integer_32)
		   model.setup_values (max_shots.as_integer_32, num_bombs.as_integer_32, ((ships.as_integer_32 * (ships.as_integer_32+1))/2).rounded)
		   model.set_new_game (true)

			place_new_ships(model.board, new_ships)
			create op.make(true)
				model.history.extend_history (op)
			end
			else

				if (model.game_over) then
				if (valid_setup(dimension, ships, max_shots, num_bombs)) then
				model.make_empty
				model.debug_gen.revert
				new_ships := model.generate_ships(false,dimension.as_integer_32, ships.as_integer_32)
		   model.setup_values (max_shots.as_integer_32, num_bombs.as_integer_32, ((ships.as_integer_32 * (ships.as_integer_32+1))/2).rounded)
		   model.set_new_game (true)

			place_new_ships(model.board, new_ships)
			end
				else
				model.set_game_active (true)
				end
				create op.make(true)
				model.history.extend_history (op)
			end



			etf_cmd_container.on_change.notify ([Current])


    	end

feature


	valid_setup(dimension64: INTEGER_64 ; ships64: INTEGER_64 ; max_shots64: INTEGER_64 ; num_bombs64: INTEGER_64) : BOOLEAN
		-- Checks if inputted setup is valid
		-- Sends error messages to ETF_MODEL
		local
		dimension: INTEGER_32
		ships: INTEGER_32
		max_shots: INTEGER_32
		num_bombs: INTEGER_32
		do
			Result := false
			dimension := dimension64.as_integer_32
			ships := ships64.as_integer_32
			max_shots := max_shots64.as_integer_32
			num_bombs := num_bombs64.as_integer_32

			if((dimension ~ 4) or (dimension ~ 5)) then
				if((ships <= 3) and (ships >= 1) and (num_bombs <= 3) and (num_bombs >= 1)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if(ships > 3) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 1) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
							model.setup_valid(true, "Too many shots")
						elseif (((ships * (ships+1))/2) > max_shots) then
							model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 1) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 3) then
						model.setup_valid(true, "Too many bombs")
					end
				end

			elseif ((dimension ~ 6) or (dimension ~ 7)) then
				if((ships <= 4) and (ships >= 2) and (num_bombs <= 4) and (num_bombs >= 2)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if (ships > 4) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 2) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
						model.setup_valid(true, "Too many shots")
					elseif (((ships * (ships+1))/2) > max_shots) then
						model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 2) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 4) then
						model.setup_valid(true, "Too many ships")
					end
				end
			elseif (dimension ~ 8) then
				if((ships <= 5) and (ships >= 2) and (num_bombs <= 5) and (num_bombs >= 2)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if (ships > 5) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 2) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
						model.setup_valid(true, "Too many shots")
					elseif (((ships * (ships+1))/2) > max_shots) then
						model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 2) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 5) then
						model.setup_valid(true, "Too many ships")
					end
				end
			elseif (dimension ~ 9) then
				if ((ships <= 5) and (ships >= 3) and (num_bombs <= 5) and (num_bombs >= 3)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if(ships > 5) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 3) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
						model.setup_valid(true, "Too many shots")
					elseif (((ships * (ships+1))/2) > max_shots) then
						model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 3) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 5) then
						model.setup_valid(true, "Too many ships")
					end
				end
			elseif ((dimension ~ 10) or (dimension ~ 11)) then
				if ((ships <= 6) and (ships >= 3) and (num_bombs <= 6) and (num_bombs >= 3)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if (ships > 6) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 3) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
						model.setup_valid(true, "Too many shots")
					elseif (((ships * (ships+1))/2) > max_shots) then
						model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 3) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 6) then
						model.setup_valid(true, "Too many ships")
					end
				end
			elseif (dimension ~ 12) then
				if((ships <= 7) and (ships >= 4) and (num_bombs <= 7) and (num_bombs >= 4)) then
					Result := (((ships * (ships+1))/2) <= max_shots) and (max_shots <= (dimension * dimension))
				end
				if(Result ~ false) then
					if(ships > 7) then
						model.setup_valid(true, "Too many ships")
					elseif (ships < 4) then
						model.setup_valid(true, "Not enough ships")
					elseif (max_shots > (dimension * dimension)) then
						model.setup_valid(true, "Too many shots")
					elseif (((ships * (ships+1))/2) > max_shots) then
						model.setup_valid(true, "Not enough shots")
					elseif (num_bombs < 4) then
						model.setup_valid(true, "Not enough bombs")
					elseif (num_bombs > 7) then
						model.setup_valid(true, "Too many ships")
					end
				end

			end
		end


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
--						board[new_ship.item.row + ii.item, new_ship.item.col] := create {SHIP_ALPHABET}.make ('v')
					end
				else
					-- Horizontal ship
					across
						1 |..| new_ship.item.size as ii
					loop
--						board[new_ship.item.row, new_ship.item.col + ii.item] := create {SHIP_ALPHABET}.make ('h')
					end
				end
			end
		end

end

