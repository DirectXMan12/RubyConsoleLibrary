module RubyConsoleLibrary
  module ControlMixins
    module Pressable
      # assumes do_interact is defined elsewhere
      def self.included(base)
        base.instance_eval do
          #alias_method :pressable_do_interact, :do_interact
          #alias_method :do_interact, :_do_interact
        end
      end
      
      def on_press(&blk)
        @interact_blk = blk
      end

      private
      def _do_interact
        res = do_interact
        @interact_blk.call unless @interact_blk.nil?
      end
    end
  end
end
