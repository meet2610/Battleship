note
	description: "Summary description for {MAKE_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAKE_GAME
inherit
	MOVE
		rename out as out1 end

create
	make

feature {NONE} -- constructor

	undo_msg : STRING_8
	state : INTEGER
	undo_score : INTEGER
	make (b: BOOLEAN)
		do
			undo_msg := ""
			state := 0
			undo_score := 0
		end

feature
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

	execute
		do

		end
	undo
		do

		end

	redo
		do

		end

end
