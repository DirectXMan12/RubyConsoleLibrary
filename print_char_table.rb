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

def raw_getch(two_calls=false)
	if WINDOWS == true
		windows_f = {}
		windows_f[:getch] = Win32API.new("msvcrt","_getch",[],"I")
		n1 = windows_f[:getch].Call
		if (two_calls)
			n2 = windows_f[:getch].Call
		end
	else
		begin
			system("stty raw -echo")
			n1 = STDIN.getc
		ensure
			system("stty -raw echo")
		end
	end

	unless (n2.nil?)
		return [n1,n2]
	else
		return n1
	end
end
