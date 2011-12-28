module RubyConsoleLibrary
  class PopupWin < ConsoleWin
    def initialize(size)
      super(size)
      @active = false
    end
  end
end
