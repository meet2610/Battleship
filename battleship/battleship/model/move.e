note
	description: "Summary description for {MOVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVE

feature{NONE}

	model: ETF_MODEL
			-- access board via singleton
		local
			ma: ETF_MODEL_ACCESS
		once
			Result := ma.m

		end

feature
	get_undo_msg: STRING_8
		deferred
		end
	get_state: INTEGER
		deferred
		end
	get_undo_score: INTEGER
		deferred
		end
	set_undo_msg (msg: STRING_8)
		deferred
		end
	set_state (s : INTEGER)
		deferred
		end
	set_undo_score(i : INTEGER)
		deferred
		end

	execute
		deferred
		end
	undo
		deferred
		end

	redo
		deferred
		end

end
