# initialize the constants to work with multiple ruby versions
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

# TODO: require_relative shim

# misc utils
require_relative 'utils/getch.rb' #'console-utils-main.rb'
require_relative 'utils/deep_copy.rb'
require_relative 'utils/display_array.rb'
require_relative 'utils/input_router.rb' #'console-input-router.rb'
require_relative 'utils/to_display_array.rb'

# text-related stuff
require_relative 'characters/hashes-controlcodes.rb' #'console-controlcodes-hashes.rb'
require_relative 'characters/hashes-ui.rb' #'console-UIChars-hashes.rb'
require_relative 'characters/utils.rb' #'console-characters-utils.rb'

# controls
require_relative 'controls/base.rb' #'console-controls-base.rb'
require_relative 'controls/templater.rb' #'console-controls-templater.rb'
require_relative 'controls/textbox.rb' #'console-controls-maincontrols.rb'
require_relative 'controls/button.rb'

# base application stuff
require_relative 'base/app_main.rb' #'console-consoleapp-main.rb'
require_relative 'base/win.rb' #'console-consolewin-main.rb'
if VERSION =~ /1\.8\.6/ then require 'jcode' end #for str.each_char - should be present in 1.8.7 and up by default

module RubyConsoleLibrary
	
end
