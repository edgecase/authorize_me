module AuthorizeMe
  class RoleDefinition
    def initialize(model_class)
      @model_class = model_class
    end

    def method_missing(name, *args)
      if args.length == 1 && args.first.is_a?(Hash)
        @model_class.add_authorization_rule(name, args.first)
      else
        super
      end
    end
  end
end
