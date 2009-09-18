module RubyConsoleLibrary
	class ConsoleControl
		@parent_window = nil #internal
		@interactable = true #read
		@gui_array = nil		 #internal, last used gui
		@template	= nil			 #internal
		attr_reader :enabled #read/write
		@dims = [0,0] #x,y   #internal
		attr_reader :opts		 #read/write
		@state = :default		 #read

		def initialize(parent_obj)
			@parent_window = parent_obj
		end

		def state
			return @state
		end

		def interactable?
			return @interactable
		end

		def interact
			return nil unless @interactable || !@enabled
			do_interact
		end
		
		def draw (d_opts={})
			all_opts = @opts.merge d_opts
			new_state = if  d_opts[:new_state]
										d_opts[:new_state]
									else
										:default
									end
			return do_gui(@dims[0],@dims[1], [@state,new_state], all_opts)
		end

		#internal methods - these should be replaced by actual control methods
		private

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			@state = state[1]
			@gui_array = @template
			return @gui_array #return what is to be displayed (in the form of a display array, as seen in the ConsoleWin class definition
		end		

		def do_interact
			return true #success!
		end
	end
end
