module RubyConsoleLibrary
  class InputRouter
    attr_accessor :bound_window   # ref to window to which to route interactions
    @control_stack = []           # stack of interactable controls - internal
    @stack_pos = 0                # currently focused item in @control_stack (for controls like a text box which hog all input) - internal
    @key_bindings = {}            # hash of key to control bindings - internal, but accessible via methods
    @backup_bindings = {}         # for use when 'capture_all_input' is called
    attr_accessor :pass_through_input   # determines whether or not to pass through all input, not just unrecognized input

    def initialize(bound_window)  
      @bound_window = bound_window
      @control_stack = @bound_window.get_controls(true) # implement this method
      @stack_pos = 0
      @key_bindings = {}
      @pass_through_input = false
    end

    # accepts a string (or symbol) of a key, as well as a hash, which can be either :custom => Proc, :control => ConsoleControl,
    # or :special => Proc (for shifting focus, etc)
    def bind_key(key, control=nil, &block)

      if (control && block) then raise "you can't specifiy both a control and a block" end

      @key_bindings[key.to_sym] = if (control)
                                    Proc.new { opts[:control].interact }
                                  else
                                    block
                                  end 
    end

    def remove_binding(key)
      @key_bindings.delete(key.to_sym)
    end

    def bindings (&block)
      self.instance_eval(&block)
    end

    def handle_input(key)
      k = key.to_sym  

      # call the Proc in the context where it can call methods like focus_next, etc
      unless (!@key_bindings[k])
        self.instance_eval(&@key_bindings[k])
        @bound_window.pressed_key = nil 

        unless (!@pass_through_input)
          @bound_window.pressed_key = if (key.to_s.length == 1) then key.to_s else key end
          if (!@handle_callback.nil?) then self.instance_eval(&@handle_callback) end
        end
      else
        # register the key as having been input
        @bound_window.pressed_key = if (key.to_s.length == 1) then key.to_s else key end
        if (!@handle_callback.nil?) then self.instance_eval(&@handle_callback) end
      end


    end
    
    def current_control
      @control_stack[@stack_pos]
    end

    private
    # stuff for the blocks (see handle_input)
    def focus_next
      current_control.blur
      unless (@stack_pos + 1 == @control_stack.length)
        @stack_pos += 1 
      else 
        @stack_pos = 0 
      end
      current_control.hover
    end

    def focus_prev
      current_control.blur
      unless (@stack_pos - 1 == -1)
        @stack_pos -= 1 
      else 
        @stack_pos = @control_stack.length - 1 
      end
      current_control.hover
    end

    # stops routing temporarily (use with controls like the text box)
    def capture_all_input(opts, &block)
      opts[:except] ||= []
      unless (opts[:except].is_a?(Array)) then opts[:except] = [opts[:except]] end 

      if (!opts[:until] && opts[:except] != :existing_bindings) then raise 'you must have a release key' end

      @backup_bindings = @key_bindings.clone
      unless opts[:except] == :existing_bindings
        @key_bindings.delete_if do |k, v|
          !opts[:except].include?(k.to_sym)
        end
      end
      @key_bindings[opts[:until].to_sym] = Proc.new { release_input }

      if (!block.nil?)
        @handle_callback = block
      end
    end
    
    # ends a capture_all_input command (see above)
    def release_input
      @key_bindings = @backup_bindings.clone
      @handle_callback = nil
    end
    
    # "feeds" input through to a specified control (or the current control by default)
    def feed_through(opts=nil)
      opts ||= {:to => current_control}
      opts[:to].interact
    end

  end
end
