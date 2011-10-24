module Amiando

  ##
  # This object is intended to be used when an api will return value that is
  # not a resource object (a User, an Event, etc), but due to the delayed
  # nature of doing requests in parallel, can't be initialized from the beginning.
  #
  # After the object is populated, you can ask the result with the result
  # method.
  class Result
    attr_accessor :request, :response

    def initialize(&block)
      @populator = block
    end

    def populate(response_body)
      @result = @populator.call(response_body)
    end

    def result
      if defined?(@result)
        @result
      else
        raise Error::NotInitialized.new('Called result before the query was run')
      end
    end
  end
end

