module RubyConsoleLibrary
  class ConsoleWin
    #@dims = [0,0] #x,y
    #@buffer = []  #in row,column,tuple form 
    #@cursor = [0,0]
    #@key_state = [nil,nil]
    #@control_stack = []

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
      @delta = {}
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

    def unoptimized_refresh
      #cls
      #instead of clearing the screen, just go back to first desired position with cursor
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

    def force_write_delta(loc, buf)
      buf.each_with_index do |l, line_ind|
        l.each_with_index do |c, char_ind|
          @delta[[loc[1]+line_ind, loc[0]+char_ind]] = c
        end
      end
    end

    def draw_delta
      @delta.each do |p,c|
        print ControlCode.get_full [[:cursor_pos, p[0]+1, p[1]+1]]
        print ControlCode.get_full(c[0]) unless c[0] == :none
        print c[1]
        print ControlCode.escape "0m" unless c[0] == :none
      end

      @delta = {} # reset delta
    end
    
    def refresh
      draw_delta
      @control_stack.each do |w|
        print ControlCode.get_full([[:cursor_pos, w.loc[1], w.loc[0]]])
        buf = w.draw
        buf.each_with_index do |l, ind|
          print ControlCode.get_full([[:cursor_pos, w.loc[1]+ind, w.loc[0]]])
          l.each do |c|
            if !c.nil? && !c[1].nil? 
              print ControlCode.get_full(c[0]) unless c[0] == :none
              print c[1]
              print ControlCode.escape "0m" unless c[0] == :none
            else
              print ' '
            end
          end
        end
      end
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

    def box(s_x,s_y, style=:none)
      w = ControlTemplate.define do
        line [style, UI[:window_corner_top_left]], exp([style, UI[:window_bottom]]), [style, UI[:window_corner_top_right]]
        line exp(:direction => :vert, :v => [[style, UI[:window_side]], exp(' '), [style, UI[:window_side]]])
        line [style, UI[:window_corner_bottom_left]], exp([style, UI[:window_bottom]]), [style, UI[:window_corner_bottom_right]]
      end
      buf = w.render(s_x,s_y)

      buf.each_with_index do |l, line_ind|
        l.each_with_index do |c, char_ind|
          unless c[0] == :none and (c[1] == ' ' || c[1] == '' || c[1].nil?)
            @delta[[line_ind, char_ind]] = c
          end
        end
      end
    end
  end
end
