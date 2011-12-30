module RubyConsoleLibrary
  class ConsoleWin
    #@dims = [0,0] #x,y
    #@buffer = []  #in row,column,tuple form 
    #@cursor = [0,0]
    #@key_state = [nil,nil]
    #@control_stack = []

    attr_accessor :loc

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
      @bg = {}
      @active = true
      @loc = [0,0]
    end 

    def parent_app=(p)
      @parent_app = p
    end

    def parent_app
      @parent_app
    end
    
    def erase!
      @parent_app.erase_region @loc, @dims
    end

    def _control_stack
      @control_stack
    end

    def redraw_controls_at_locations(locs)
      @control_stack.each do |ctrl|
        # [col, row], [width, height]
        min_col = ctrl.loc[1]
        max_col = ctrl.loc[1]+ctrl.dims[1]
        min_row = ctrl.loc[0]
        max_row = ctrl.loc[0]+ctrl.dims[0]
        
        rng_col = min_col..max_col
        rng_row = min_row..max_row

        locs.each do |l|
          if rng_col.include?(l[0]) && rng_row.include?(l[1])
            ctrl._redraw!
            break
          end
        end
      end
    end

    def activate
      na = unless active? then true else false end
      @active = true
      if na
        @bg.each do |l,c|
          next unless @delta[l].nil?
          @delta[l] = c 
        end
        @control_stack.each do |w|
          w._redraw!
        end
      end
    end

    def deactivate
      e = if active? then true else false end
      @active = false
      if e then self.erase! end
    end

    def active?
      @active == true
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

    def redraw_bg (region_data)
      region_data.each do |(i,j)|
        next if @bg[[i,j]].nil?
        c = @bg[[i,j]] 
        print ControlCode.get_full [[:cursor_pos, i+1, j]]
        print ControlCode.get_full(c[0]) unless c[0] == :none
        print c[1]
        print ControlCode.escape "0m" unless c[0] == :none
      end
    end

    def draw_delta
      @delta.each do |p,c|
        print ControlCode.get_full [[:cursor_pos, @loc[1]+p[0]+1, @loc[0]+p[1]+1]]
        print ControlCode.get_full(c[0]) unless c[0] == :none
        print c[1]
        print ControlCode.escape "0m" unless c[0] == :none
      end

      @delta = {} # reset delta
    end
    
    def refresh
      draw_delta
      @control_stack.each do |w|
        next unless w.redraw?
        w.redrawn
        print ControlCode.get_full([[:cursor_pos, w.loc[1]+@loc[1], w.loc[0]+@loc[0]]])
        buf = w.draw
        buf.each_with_index do |l, ind|
          print ControlCode.get_full([[:cursor_pos, @loc[1]+w.loc[1]+ind, @loc[0]+w.loc[0]]])
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

    def write_bg(loc, c)
      @bg[loc] = c
      @delta[loc] = c
    end

    def write_buf_bg(start_loc, buf)
      buf.each_with_index do |line, row|
        line.each_with_index do |char, col|
          write_bg [start_loc[0]+row, start_loc[1]+col], char
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
            self.write_bg([line_ind, char_ind],  c)
          end
        end
      end
    end
  end
end
