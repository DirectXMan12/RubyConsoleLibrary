WINDOWS = if (PLATFORM =~ /win32/)
		  true
	  else
		  false
	  end
begin
  require 'Win32/Console/ANSI' if WINDOWS == true
rescue LoadError
  raise 'You must gem install win32console to use ansi control codes and color on windows'
end
#require 'ruby-debug'
require 'console-controlcodes-hashes.rb'
require 'console-UIChars-hashes.rb'
require 'console-UICharacters-main.rb'
require 'console-controlcodes-main.rb'
require 'console-consoleapp-main.rb'
require 'console-consolewin-main.rb'

module RubyConsoleLibrary

end
