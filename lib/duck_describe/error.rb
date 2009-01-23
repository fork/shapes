module DuckDescribe
  class Error

    attr_reader :path, :message

    def initialize(options = {})
      @path = options[:path].underscore if options[:path]
      @message = options[:message] || ''
    end

    def show_message
      path ? %Q{Error on object "#{path}": #{message}"} :
        message
    end
  end
end