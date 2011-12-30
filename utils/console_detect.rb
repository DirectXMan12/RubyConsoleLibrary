module RubyConsoleLibrary
  class Utils
    if WINDOWS
      @@windows_f[:get_std_handle] = Win32API.new( 'kernel32', 'GetStdHandle', ['L'], 'L' )
      @@windows_f[:get_screen_buf_info] = Win32API.new('kernel32', 'GetConsoleScreenBufferInfo', ['L', 'P'], 'L')
    end

    # Determines if a shell command exists by searching for it in ENV['PATH'].
    # courtesy of https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb
    def self.command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? {|d| File.exists? File.join(d, command) }
    end

    # Returns [width, height] of terminal when detected, nil if not detected.
    # Think of this as a simpler version of Highline's Highline::SystemExtensions.terminal_size()
    # courtesy of https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
    def self.terminal_dims
      if WINDOWS
        fmt = 'SSSSSssssSS'
        buf = ([0] * fmt.size).pack(fmt)
        stdout_handle = @@windows_f[:get_std_handle].call(0xFFFFFFF5)
        @@windows_f[:get_screen_buf_info].call(stdout_handle, buf)

        bufx, bufy, curx, cury, wattr, left, top, right, bottom, maxx, maxy = buf.unpack(fmt)
        return [right - left + 1, bottom - top + 1]
      else
        if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
          return [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
        elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exists?('tput')
          return [`tput cols`.to_i, `tput lines`.to_i]
        elsif STDIN.tty? && command_exists?('stty')
          return `stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
        else
          return nil
        end
      end
    rescue
      nil
    end 
  end
end
