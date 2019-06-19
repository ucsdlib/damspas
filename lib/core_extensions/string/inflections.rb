module CoreExtensions
  module String
    module Inflections
      # convert first character to uppercase, leave others along
      # back-ported from Rails 5: https://github.com/rails/rails/pull/23895
      def upcase_first
        self.sub(/\S/, &:upcase)
      end
    end
  end
end

String.include CoreExtensions::String::Inflections
