module AuthorizeMe

  class AuthorizationRuleMissing < Exception
    def initialize(obj)
      @obj = obj
    end

    def message
      "AuthorizeMe tried to access #{@obj.inspect}, which does not declare authorization rules"
    end
  end

  class Unauthorized < Exception; end

end

