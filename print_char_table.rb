if (!defined? PLATFORM) then PLATFORM = RUBY_PLATFORM end
if (!defined? VERSION) then VERSION = RUBY_VERSION end

WINDOWS = if (PLATFORM =~ /(win(32|64))|(mingw(32|64))/)
      true
    else
      false
    end
begin
  puts "" + (if (WINDOWS) then "windows detected: " else "POSIX detected: " end) + "#{PLATFORM}"
  require 'Win32/Console/ANSI' if WINDOWS == true
  require 'Win32API' if WINDOWS == true
rescue LoadError
  raise 'You must gem install win32console (auto-installs win32api) to use ansi control codes, color on windows, and better character capture'
end

def print_char_table
  (0..9).each do |n1|
    (0..9).each do |n2|
      eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
    end
    ('A'..'F').each do |n2|
      eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
    end
  end

  ('A'..'F').each do |n1|
    (0..9).each do |n2|
      eval 'puts \'\x'+n1+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
    end
    ('A'..'F').each do |n2|
      eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
    end
  end
end

def esc(s)
  eval '"\e'+s+'"'
end

def putse(s)
  puts esc(s)
end

class HexRange < Range
  def initialize
    super 0, 15
  end

  def each
    (0..9).each {|n| yield n.to_s }
    ('A'..'F').each {|l| yield l }
  end
end

def print_unicode_char_table
  HexRange.new.each do |l0|
    HexRange.new.each do |l1|
      HexRange.new.each do |l2|
        gets
        HexRange.new.each do |l3|
          puts '\u'+l0+l1+l2+l3+'          '+eval('"\u'+l0+l1+l2+l3+'"')
        end
      end
    end
  end
end
