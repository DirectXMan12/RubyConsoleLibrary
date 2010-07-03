module RubyConsoleLibrary
	class UI
		@@chars = {
			:window => {
				:side => "\xBA",
				:corner_top_right => "\xBB",
				:corner_bottom_right => "\xBC",
				:corner_top_left => "\xC9",
				:corner_bottom_left => "\xC8",
			  :bottom => "\xCD"	
			},
			:line => {
				:side => "\xB3",
				:corner_top_right => "\xBF",
				:corner_bottom_right => "\xD9",
				:corner_top_left => "\xDA",
				:corner_bottom_left => "\xC0",
			  :bottom => "\xC4"	
			},
			:nav => {
				:scroll_left => "\x11",
				:scroll_right => "\x10",
				:scroll_up => "\x1E",
				:scroll_down => "\x1F",
				:more_left => "\xAE",
				:more_right => "\xAF"
			},
			:pictures => {
				:smile_neg => "\x01",
				:smile_pos => "\x02",
				:music_note => "\x0E",
				:gear => "\x0F"
			},
			:special => {
				:bell => "\x07"
			}

		}
	end
end
