module RubyConsoleLibrary
    class ConsoleApp
    #@wins = []
    #@textoptions = {}
    
    def ConsoleApp.console_size
      @@console_size
    end
    def ConsoleApp.console_size= (new_size)
      @@console_size = new_size
    end

    def wins
      @wins
    end
    def wins= (new_wins)
      @wins = new_wins
    end
    
    def ConsoleApp.control_code (code)
      ControlCode.escape code
    end

    def hide_cursor
      print ConsoleApp.control_code "?25l"
    end

    def show_cursor
      print ConsoleApp.control_code "?25h"
    end

    def cls
      print ConsoleApp.control_code "2J"
    end

    def add_win (new_win)
      @wins << new_win
      new_win.parent_app = self
    end

    def remove_win (w)
      @wins.delete(w)
    end

    def refresh
      @wins.reject {|w| !w.active? }.each do |w|
        w.refresh
      end
    end

    def erase_region (loc, dims)
      print ControlCode.get_full([[:cursor_pos,loc[1]+1,loc[0]+1]])
      print ControlCode.escape "0m"
      (0..(dims[1]-1)).each do |i|
        (0..(dims[0]-1)).each do |j|
          print ' '
          @app_delta << [loc[1]+1+i,loc[0]+1+j]
        end
        print ControlCode.get_full([[:cursor_pos, loc[1]+1+i+1, loc[0]+1]])
      end
      redraw_delta_region
    end

    def redraw_delta_region
      @wins.reject {|w| !w.active? }.each do |w|
        w.redraw_bg @app_delta
      end
      @app_delta = []
    end

    def initialize
      @@console_size ||= Utils.terminal_dims || [80,25] 
      @wins = []
      @app_delta = []
      self.add_win ConsoleWin.new(@@console_size)
      print ControlCode.char_conv (false)
      hide_cursor unless WINDOWS == true
      cls
    end

    def cleanup
      show_cursor unless WINDOWS == TRUE
      print ControlCode.escape "0m"
      print ControlCode.get_full [[:cursor_pos, @@console_size[0], 0]]
      print "\n"
    end

  end
end
