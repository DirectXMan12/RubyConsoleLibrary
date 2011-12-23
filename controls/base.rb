module RubyConsoleLibrary
  class ConsoleControl
    #@parent_window = nil        #internal
    #@interactable = true        #read
    #@gui_array = nil            #internal, last used gui
    #@template = nil             #internal
    #@enabled = true             #read/write
    #@dims = [0,0] #x,y          #internal
    #@opts = {}                  #read/write
    #@state = :default           #read
    attr_accessor :loc #x,y     #read, write only initialize

    def initialize(parent_obj, pos=[0,0])
      @parent_window = parent_obj
      @opts = {}
      @enabled = true
      @interactable = true
      @receives_text = false
      @loc = pos
    end

    def owner
      @parent_window
    end

    def enabled?
      return @enabled
    end
    def enabled
      return @enabled
    end
    def enabled=(val)
      @enabled = val
    end

    def opts
      return @opts
    end
    def opts=(val)
      @opts = val
    end

    def state
      return @state
    end

    def interactable?
      return @interactable
    end

    def interact
      return nil unless @interactable && @enabled 
      do_interact
    end

    def hover
      return nil unless @interactable && @enabled
      do_hover(:hover)
    end
    
    def blur
      return nil unless @interactable && @enabled
      do_hover(:blur)
    end

    def input_focus
      return nil unless @interactable && @enabled && @receives_text
      do_hover(:focus)
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

    def ConsoleControl.parse_template(template_array, subs_hash)
      t_t = template_array.deep_copy
      s_h = subs_hash.deep_copy
      #debugger
      s_h.each do |s|
        if s[1].is_a? String
          rev_str = s[1].reverse
          s_h[s[0].to_sym] = []
          rev_str.each_char {|c| s_h[s[0].to_sym].push(c) }
        end
      end
      t_t.each_with_index do |row,row_i|
        row.each_with_index do |col,col_i|
          col.each_with_index do |attr,attr_i|
            if  attr =~ /^!:(.+)/ #places in which require substitutions are in this form: "!:nameof substituion"
              t_t[row_i][col_i][attr_i] = if s_h[$1.to_sym].is_a?(Array)
                    s_h[$1.to_sym].pop || ' ' # TODO: allow formatting
                  else
                    #s_h[$1.to_sym]
                  end
            end
          end
        end
      end
      return t_t
    end
            
    
    private
    #utility methods
    def make_box(type_prefix=:line, style=:deco_bold)
      t = Utils.display_array(@dims[0],@dims[1])
      
      t.each_with_index do |row,i|
        unless (i == 0 or i == @dims[1]-1) # unless it's the top or bottom row
          row[0] = [style, UI[:line_side]]
          row[@dims[0]-1] = [style, UI[(type_prefix.to_s + '_side').to_sym]] 
        end 
      end
      
      t[0].each_with_index do |col,i|
        unless (i == 0 or i == @dims[0]-1)
          t[0][i] = [style, UI[(type_prefix.to_s + '_bottom').to_sym]]
        end
      end

      t[@dims[1]-1].each_with_index do |col,i|
        unless (i == 0 or i == @dims[0]-1)
          t[@dims[1]-1][i] = [style, UI[(type_prefix.to_s + '_bottom').to_sym]]
        end
      end

      # now assign the corners
      t[0][0] = [style, UI[(type_prefix.to_s + '_corner_top_left').to_sym]]
      t[0][@dims[0]-1] = [style, UI[(type_prefix.to_s + '_corner_top_right').to_sym]]
      t[@dims[1]-1][0] = [style, UI[(type_prefix.to_s + '_corner_bottom_left').to_sym]]
      t[@dims[1]-1][@dims[0]-1] = [style, UI[(type_prefix.to_s + '_corner_bottom_right').to_sym]]

      return t
    end

    #internal methods - these should be replaced by actual control methods
    def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
      @state = state[1]
      @gui_array = @template.deep_copy
      return @gui_array #return what is to be displayed (in the form of a display array, as seen in the ConsoleWin class definition
    end   

    def do_interact
      return true #success!
    end

    def do_hover(type=:hover)
      return true
    end
  end
end
