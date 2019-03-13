note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_GIVE_UP
inherit
	ETF_GIVE_UP_INTERFACE
		redefine give_up end
create
	make
feature -- command
	give_up
    	do
			-- perform some update on the model state
			if ((model.game_started and (model.game_count >= 1)) and (not model.game_over)) then
				model.giveup (true, "OK -> You gave up!")
			else
				model.set_go_msg(true)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
