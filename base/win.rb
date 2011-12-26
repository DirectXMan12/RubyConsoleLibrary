module RubyConsoleLibrary
  class ConsoleWin
    @dims = [0,0] #x,y
    @buffer = []  #in row,column,tuple form 
    @cursor = [0,0]
    @key_state = [nil,nil]
    @control_stack = []

    def cls
      print ConsoleApp.control_code "2J"
    end

    def initialize (size)
      @dims = size
      @buffer = Array.new(@dims[1]-1)
      @buffer.each_index do |a| 
        @buffer[a] = Array.new(@dims[0]-1) 
        @buffer[a].each_index { |b| @buffer[a][b] = Array.new(2) } #tuple in format [{text_options}, 'character'] 
      end
      @cursor = [0,0]
      
      @key_state = [nil,nil] #tuple in format of [char, :state]
      @control_stack = []
    end 

    def structure(&blk)
      WindowBuilder.new(self).instance_eval(&blk)
    end
    
    def dims
      @dims
    end
    def dims= (new_dims)
      @dims = new_dims
    end

    def key_state
      return @key_state
    end

    def pressed_key=(k)
      if (!k.nil?) 
        s = :pressed
      else 
        s = nil
      end

      @key_state = [k,s]
    end

    def get_controls(only_interactables)
      res = []

      if (only_interactables)
        @control_stack.each do |c|
          if (c.interactable?) then res.insert(-1, c) end
        end
      else
        res = @control_stack
      end

      return res
    end

    def new_control(c)
      @control_stack << c
      return c
    end

    def remove_control(c)
      @control_stack.delete c
    end

    def refresh_buffer
      @control_stack.each do |c|
        @cursor = c.loc
        display_obj c.draw
      end
    end

    def refresh
      #cls
      #instead of clearing the screen, just go back to 1,1 with cursor
      refresh_buffer
      print ControlCode.get_full([[:cursor_pos,1,1]])
      @buffer.each do |l|
        l.each do |c|
          if !c.nil? && !c[1].nil? 
            print ControlCode.get_full(c[0]) unless c[0] == :none
            print c[1]
            print ControlCode.escape "0m" unless c[0] == :none
          else
            print ' '
          end
        end
        print "\n"
      end
      #debugger
    end

    def display_obj(display_array)
      display_array.each_with_index do |a, a_i|
        a.each_with_index do |b, b_i|
          @buffer[@cursor[1]+a_i][@cursor[0]+b_i] = b
        end
      end
    end

    def write(str,opts=:none)
      r = false
      r = opts.delete(:norefresh) unless (!opts.is_a?(Hash) || !opts[:norefresh]) 
      str = str.to_s
      if (r == true)
        print ControlCode.escape ControlCode.get_code([:cursor_pos,@cursor[1],@cursor[0]])
        str.each_char do |c|
          print c 
        end
      else
        str.each_char do |c|
          @buffer[@cursor[1]][@cursor[0]][1] = c
          @buffer[@cursor[1]][@cursor[0]][0] = opts 
          @cursor[0] += 1 #need edge overflow checking
        end
      end
    end

    def box(s_x,s_y, text_opts=:none)
      #debugger
      #check for edge overflow - need to write code to check for edge underflow
      if s_x + @cursor[0] > @dims[0]
        s_x = @dims[0] - @cursor[0]
      end
      if s_y + @cursor[1] > @dims[1]
        s_y = @dims[1] - @cursor[1]
      end

      for l in @cursor[1]..(s_y - 1)
        if l == @cursor[1]
          @buffer[l][@cursor[0]] = [text_opts,UI[:window_corner_top_left]]
        elsif l == s_y -1
          @buffer[l][@cursor[0]] = [text_opts,UI[:window_corner_bottom_left]]
        else
          @buffer[l][@cursor[0]] = [text_opts,UI[:window_side]]
        end
        
        #debugger
        if l == 0 || l == s_y-1
          #debugger
          (s_x-2).times { |c| @buffer[l][@cursor[0]+c+1] = [text_opts,UI[:window_bottom]]}
        end
        
        if l == @cursor[1]
          @buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UI[:window_corner_top_right]]
        elsif l == s_y - 1
          @buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UI[:window_corner_bottom_right]]
        else
          @buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UI[:window_side]]
        end
      end
    end
  end
end
