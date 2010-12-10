module AuthorizeMe
  class AbilityChecker
    def initialize(ability, target, association, user)
      @ability, @target, @association, @user = ability, target, association, user
      @target = @target.to_s if @target.is_a?(Symbol)
    end

    def check
      return false if access_rule.nil?

      if_condition_met     = access_rule[:if].nil?     || call_method(access_rule[:if])
      unless_condition_met = access_rule[:unless].nil? || !call_method(access_rule[:unless])

      if_condition_met && unless_condition_met
    end

    protected

      def object
        @object ||= if @target.is_a?(String)
            build_model_object
          elsif ! @target.class.respond_to?(:authorization_rules)
            raise AuthorizeMe::AuthorizationRuleMissing.new(@target)
          else
            @target
          end
      end

      def build_model_object
        if @association
          @association.send(@target.pluralize).new
        else
          @target.singularize.camelize.constantize.new
        end
      end

      def rules
        object.class.authorization_rules[@user.role.to_sym] || {}
      end

      def access_rule
        rules[@ability.to_sym] || rules[:manage]
      end

      def call_method(method)
        arity = object.send(:method, method).arity
        case arity.abs
        when 0 then object.send(method)
        when 1 then object.send(method, @user)
        end
      end
  end
end
