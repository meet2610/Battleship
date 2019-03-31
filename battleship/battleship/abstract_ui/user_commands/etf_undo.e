note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command

	undo
		-- undos a move previously made
		-- Sends error messages to ETF_MODEL
		-- Sends the un-done move's message to ETF_MODEL
    	local
		s: STRING_8
    	do
			-- perform some update on the model state

			if model.history.on_item and not model.history.before and (model.history.count >= 1) then
				model.history.item.undo
				model.history.back


				s := " (= state " + model.history.item.get_state.out + ")" + model.history.item.get_undo_msg + ""



				model.undoredo_change (true, s)

			else

				if(not (model.game_over or (model.game_count < 1))) then
					if (model.played_move) then
						model.set_undoredo (true, " Nothing to undo -> Keep Firing!%N")
					else
						model.set_undoredo (true, " Nothing to undo -> Fire Away!%N")
					end
				elseif (model.game_over) then

					model.set_undoredo (true, " Nothing to undo -> Start a new game%N")
				else
					model.set_undoredo (true, " Nothing to undo -> Start a new game")
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
