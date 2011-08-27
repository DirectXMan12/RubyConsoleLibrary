#initialize the constants to work with multiple ruby versions
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
if WINDOWS # detect unicode support
  IS_UNICODE = false
else
  IS_UNICODE = if ENV['LANG'] =~ /UTF-?(8|16|32)/i then true else false end
end
require_relative 'console-controlcodes-hashes.rb'
require_relative 'console-UIChars-hashes.rb'
require_relative 'console-characters-utils.rb'
#require_relative 'console-UICharacters-main.rb'
#require_relative 'console-controlcodes-main.rb'
require_relative 'console-consoleapp-main.rb'
require_relative 'console-consolewin-main.rb'
require_relative 'console-utils-main.rb'
require_relative 'console-controls-base.rb'
require_relative 'console-controls-templater.rb'
require_relative 'console-controls-maincontrols.rb'
require_relative 'console-input-router.rb'
if VERSION =~ /1\.8\.6/ then require 'jcode' end #for str.each_char - should be present in 1.8.7 and up by default

module RubyConsoleLibrary
	
end
