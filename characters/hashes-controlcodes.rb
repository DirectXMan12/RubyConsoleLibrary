module RubyConsoleLibrary
  class ControlCode
    @@text = {
      :colors => {
        :foreground =>{
          :black => "30m",
          :red => "31m",
          :green => "32m",
          :yellow => "33m",
          :blue => "34m",
          :magenta => "35m",
          :cyan => "36m",
          :white => "37m",
          :reset => "39m",
          :brightblack => "90m",
          :brightred => "91m",
          :brightgreen => "92m",
          :brightyellow => "93m",
          :brightblue => "94m",
          :brightmagenta => "95m",
          :brightcyan => "96m",
          :brightwhite => "97m"
        }, 
        :background => {
          :black => "40m",
          :red => "41m",
          :green => "42m",
          :yellow => "43m",
          :blue => "44m",
          :magenta => "45m",
          :cyan => "46m",
          :white => "47m",
          :reset => "49m",
          :brightblack => "100m",
          :brightred => "101m",
          :brightgreen => "102m",
          :brightyellow => "103m",
          :brightblue => "104m",
          :brightmagenta => "105m",
          :brightcyan => "106m",
          :brightwhite => "107m"        
        }
      }, 
      :decorations => {
        :reset => "0m",
        :bold => "1m",
        :faint => "2m",
        :standout => "3m",
        :underline => "4m",
        :blinkslow => "5m",
        :blinkrapid => "6m",
        :negative => "7m",
        :hide => "8m",
        :doubleunderline => "21m",
        :noboldfaint => "22m",
        :nounderline => "24m",
        :noblink => "25m",
        :positive => "27m",
        :show => "28m"
      }
    }
    @@cursor = {
      :movement =>{
        :up => "valA",
        :down => "valB",
        :forward => "valC",
        :back => "valD",
        :nextline => "valE",
        :prevline => "valF",
        :column => "valG",
        :pos => "val;valH",
        :scrollup => "valS",
        :scrolldown => "valT",
        :save => "s",
        :restor => "u"
      }, 
      :clearing => {
        :all => "2J",
        :up => "1J",
        :down => "0J",
        :fullline => "2K",
        :lineforward => "0K",
        :linebackward => "1K"
      }
    }
  end
end
    
