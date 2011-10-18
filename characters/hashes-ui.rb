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
          :bottom => "\xCD",
          :top_t => "\xCB",
          :bottom_t => "\xCA",
          :left_t =>  "\xCC",
          :right_t => "\xB9",
          :cross => "\xCE"
        },
        :line => {
          :side => "\xB3",
          :corner_top_right => "\xBF",
          :corner_bottom_right => "\xD9",
          :corner_top_left => "\xDA",
          :corner_bottom_left => "\xC0",
          :bottom => "\xC4",
          :top_t => "\xC2",
          :bottom_t => "\xC1",
          :left_t => "\xC3",
          :right_t => "\xB4",
          :cross => "\xC5"
        },
        :lightline => { # filler -- just the same as normal line, for compat with unicode mode
          :curved_corner_top_right => "\xBF",
          :curved_corner_bottom_right => "\xD9",
          :curved_corner_top_left => "\xDA",
          :curved_corner_bottom_left => "\xC0",
          :side => "\xB3",
          :corner_top_right => "\xBF",
          :corner_bottom_right => "\xD9",
          :corner_top_left => "\xDA",
          :corner_bottom_left => "\xC0",
          :bottom => "\xC4",
          :top_t => "\xC2",
          :bottom_t => "\xC1",
          :left_t => "\xC3",
          :right_t => "\xB4",
          :cross => "\xC5"
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
        :block => {
          :transparent_step_1 => "\xB0",
          :transparent_step_2 => "\xB1",
          :transparent_step_3 => "\xB2",
          :opaque_full => "\xDB",
          :opaque_bottom_half => "\xDC",
          :opaque_top_half => "\xDF",
          :opaque_left_half => "\xDD",
          :opaque_right_half => "\xDE"
          # begin unicode compat filler

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
        :lightline => { # unicode-only
          :curved_corner_top_right => "\u256E",
          :curved_corner_bottom_right => "\u256F",
          :curved_corner_top_left => "\u256D",
          :curved_corner_bottom_left => "\u2570",
          :side => "\u2502",
          :corner_top_right => "\u2510",
          :corner_bottom_right => "\u2518",
          :corner_top_left => "\u250C",
          :corner_bottom_left => "\u2514",
          :bottom => "\u2500",
          :top_t => "\u252C",
          :bottom_t => "\u2534",
          :left_t => "\u251C",
          :right_t => "\u2524",
          :cross => "\u253C"
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
          :gear => "\u2699",
          :square => "\u25A1", # WARNING: no non-unicode version
          :square_with_subsquare => "\u25A3" # WARNING: no non-unicode version
        },
        :special => {
          :bell => "\u0007"
        },
        :block => {
          :transparent_step_1 => "\u2591",
          :transparent_step_2 => "\u2592",
          :transparent_step_3 => "\u2593",
          :full => "\u2588",
          :top_half => "\u2580",
          :botttom_half => "\u2584",
          :left_half => "\u258C",
          :right_half => "\u2590",
          # corner blocks are unicode-specific
          :corner_top_right => "\u259C",
          :corner_bottom_right => "\u259F",
          :corner_top_left => "\u259B",
          :corner_bottom_left => "\u2599"
        }
      }
    end
  end
end
