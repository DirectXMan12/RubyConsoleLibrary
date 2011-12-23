module RubyConsoleLibrary
  module ControlMixins
    module Pressable
      # assumes do_interact is defined elsewhere
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def on_press(&blk)
          @interact_blk = blk
        end

        private
        def do_interact
          res = pressable_do_interact
          @interact_blk.call
        end
      end
      
    end
  end
end
