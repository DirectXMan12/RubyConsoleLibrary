module RubyConsoleLibrary
	class UI
    unless IS_UNICODE
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
    else
      # use BOX DRAWINGS HEAVY (no heavy-light) for line, use BOX DRAWINGS DOUBLE (no double-single) for WINDOW
      @@chars = {
        :window => {
          :side => "\u2551", 
          :corner_top_right => "\u2557",
          :corner_bottom_right => "\u255D",
          :corner_top_left => "\u2554",
          :corner_bottom_left => "\u255A",
          :bottom => "\u2550",
          :top_t => "\u2566",
          :bottom_t => "\u2569",
          :left_t => "\u2560",
          :right_t => "\u2563",
          :cross => "\u256C"
        },
        :line => {
          :side => "\u2503",
          :corner_top_right => "\u2513",
          :corner_bottom_right => "\u251B",
          :corner_top_left => "\u250F",
          :corner_bottom_left => "\u2517",
          :bottom => "\u2501",
          :top_t => "\u2533",
          :bottom_t => "\u2537",
          :left_t => "\u2523",
          :right_t => "\u252B",
          :cross => "\u254B"
        },
        :nav => {
          :scroll_left => "\u25C4", # left black pointer
          :scroll_right => "\u25BA", # right black pointer
          :scroll_up => "\u25B2", # up black arrow
          :scroll_down => "\u25BC", # down black arrow
          :more_left => "\u00AB", # left double angle quote mark
          :more_right => "\u00BB" # right double angle quote mark
        },
        :pictures => {
          :smile_neg => "\u263B",
          :smile_pos => "\u263A",
          :music_note => "\u266A",
          :gear => "\u2699"
        },
        :special => {
          :bell => "\u0007"
        }

      }
    end
	end
end
