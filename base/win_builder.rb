module RubyConsoleLibrary
  class WindowBuilder
    def initialize(win)
      @window = win
    end

    private
    def textbox(width, loc)
      c = TextBoxControl.new(@window, width, loc)
      c.enabled = true
      @window.new_control c
    end

    def button(loc, opts={})
      c = ButtonControl.new(@window, loc, opts)
      c.enabled = true
      @window.new_control c
    end

    def label(loc, opts={})
      c = LabelControl.new(@window, loc, opts)
      c.enabled = false
      @window.new_control c
    end

    # TODO: method_missing, look in controls class
  end
end
