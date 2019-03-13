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
	set_undo_msg (msg: STRING_8)
		do
			undo_msg := msg
		end
	set_state (s : INTEGER)
		do
			state := s
		end
	set_undo_score(i : INTEGER)
		do
			undo_score := i
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
