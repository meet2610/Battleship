note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
		-- redos the previously un-done move
		-- Sends error messages to ETF_MODEL
		-- Sends the re-done move's message to ETF_MODEL
		local
			s : STRING_8
    	do

			-- perform some update on the model state
			if (not model.history.after) then
				model.history.forth
			end

			-- redo
			if (model.history.on_item and (not model.history.after)) then

				model.history.item.redo

				if (model.history.on_item) then
				s := " (= state " + model.history.item.get_state.out + ")" + model.history.item.get_undo_msg + ""
				else
					s := " Nothing to redo -> Fire Away!%N" -- " (= state 1) OK -> Fire Away!%N"
				end
				model.undoredo_change (true, s)

			else
				if(not model.history.before) then
				model.history.back
				end
				if(not (model.game_over or (model.game_count < 1))) then
					if (model.played_move) then
						model.set_undoredo (true, " Nothing to redo -> Keep Firing!%N")
					else
						model.set_undoredo (true, " Nothing to redo -> Fire Away!%N")
					end
				elseif (model.game_over) then
					model.set_undoredo (true, " Nothing to redo -> Start a new game%N")
				else
					model.set_undoredo (true, " Nothing to redo -> Start a new game")
				end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
