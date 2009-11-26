module Shapes
  class Error

    attr_reader :path, :message

    def initialize(message, path = '')
      @path = path.underscore
      @message = message
    end

    def show_message
      path ? %Q{Error on object "#{path}": #{message}} :
        message
    end
  end
end
