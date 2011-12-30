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
        :boldline => { # filler -- just the same as normal line, for compat with unicode mode
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
        :line => { 
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
        :wintoline => {
          :corner_top_left_sright => "\xD6",
          :corner_top_left_sbottom => "\xD5",
          :corner_bottom_left_stop => "\xD4",
          :corner_bottom_left_sright => "\xD3",
          :corner_top_right_sbottom => "\xB8",
          :corner_top_right_sleft => "\xB7",
          :corner_bottom_right_stop => "\xBE",
          :corner_bottom_right_sleft => "\xBD",
          :top_t_sbottom => "\xD1",
          :top_t_slr => "\xD2",
          :bottom_t_stop => "\xCF",
          :bottom_t_slr => "\xD1",
          :right_t_sleft => "\xB6",
          :right_t_stb => "\xB5",
          :left_t_sright => "\xC7",
          :left_t_stb => "\xC6",
          :cross_slr => "\xD7",
          :cross_stb => "\xD8"
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
    end
  end
end
