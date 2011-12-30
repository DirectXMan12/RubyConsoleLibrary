module RubyConsoleLibrary
  class UI
    if IS_UNICODE
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
        :boldline => {
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
        :wintoline => {
          :corner_top_left_sright => "\u2553",
          :corner_top_left_sbottom => "\u2552",
          :corner_bottom_left_stop => "\u2558",
          :corner_bottom_left_sright => "\u2559",
          :corner_top_right_sbottom => "\u2555",
          :corner_top_right_sleft => "\u2556",
          :corner_bottom_right_stop => "\u255B",
          :corner_bottom_right_sleft => "\u255C",
          :top_t_sbottom => "\u2564",
          :top_t_slr => "\u2565",
          :bottom_t_stop => "\u2567",
          :bottom_t_slr => "\u2568",
          :right_t_sleft => "\u2562",
          :right_t_stb => "\u2561",
          :left_t_sright => "\u255F",
          :left_t_stb => "\u255E",
          :cross_slr => "\u256B",
          :cross_stb => "\u256A"
        },
        :line => { # unicode-only
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
