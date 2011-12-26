module RubyConsoleLibrary
  class Utils 
    if WINDOWS == true
      @@windows_f = {}
      @@windows_f[:getch] = Win32API.new("msvcrt","_getch",[],"I")
    end

    def Utils.method_missing(name, *params)
      if WINDOWS then return false end
      @@current_tty ||= {}

      opts = name.to_s.split('_')
      command_str = opts.map {|opt| if (opt.start_with? 'no') then '-'+opt[2..-1] else opt end }.reduce("stty") {|acc,str| acc += ' ' + str}
      system(command_str)
      
      opts.each do |opt|
        if opt.start_with?('no')
          @@current_tty[opt[2..-1].to_sym] = false
        else
          @@current_tty[opt.to_sym] = true
        end
      end
      return @@current_tty
    end

    def Utils.getch(filter=true)
      is_special_key = false
      if WINDOWS == true
        # TODO: make ctrl-lowercase_char work
        n = @@windows_f[:getch].Call
        case n
          when 0xE0
            n = @@windows_f[:getch].Call
            is_special_key = true
            c = case n
                  when 0x4B then :left_arrow
                  when 0x4D then :right_arrow
                  when 0x50 then :down_arrow
                  when 0x48 then :up_arrow
                end
          when 0x08
            is_special_key = true
            c = :backspace
          when 0x1B
            is_special_key = true
            c = :escape
          when 0x0D
            is_special_key = true
            c = :enter
        end
      else
        @@current_tty ||= {}
        echo_was_on = (@@current_tty[:echo] != false) # assume on by default
        raw_was_on = @@current_tty[:raw] # assume off by default
        begin
          unless raw_was_on && !echo_was_on then system("stty #{unless raw_was_on then 'raw ' end}#{if echo_was_on then '-echo' end}") end
          n = STDIN.getbyte
          if n == 27 
            begin
              n2 = STDIN.read_nonblock(1).getbyte(0)
              if n2 == 91
                n = STDIN.getbyte # get the next two bytes
                is_special_key = true
                case n
                when 68
                  c = :left_arrow
                when 65
                  c = :up_arrow
                when 67
                  c = :right_arrow
                when 66
                  c = :down_arrow
                else
                  c = :unrecognized
                end
              end
            rescue IO::WaitReadable
              # is just the escape key
              is_special_key = true
              c = :escape
            end
          elsif n == 127
            is_special_key = true
            c = :backspace
          elsif n == 13
            is_special_key = true
            c = :enter
          elsif (0..26).include? n
            is_special_key = true
            c = ("ctrl_"+(96+n).chr).to_sym
          end
        ensure
          unless raw_was_on && !echo_was_on then system("stty #{unless raw_was_on then '-raw ' end}#{if echo_was_on then 'echo' end}") end
        end
      end

      unless is_special_key
        c = " "
        c.setbyte(0,n)
      end
      
      if filter == true && (n > 122 || n < 97)
        c = ""
      end 

      return c
    end

  end
end

