module RubyConsoleLibrary
    class ConsoleApp
    @wins = []
    @textoptions = {}
    
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

    def initialize
      @@console_size ||= Utils.terminal_dims || [80,25] 
      @wins = [ConsoleWin.new(@@console_size)]
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
