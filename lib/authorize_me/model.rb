require 'active_support/core_ext'

module AuthorizeMe
  module Model

    def self.included(base)
      base.extend ClassMethods
      base.send   :include, InstanceMethods
    end
    
    module ClassMethods
      # define a bunch of methods on extended class
      # * User#can_create?(obj)
      # * User#can_read?(obj)
      # * User#can_update?(obj)
      # * User#can_destroy?(obj)
      def authorize_me
        %w{ create read update destroy }.each do |ability|
          define_method "can_#{ability}?" do |*args|
            obj = args[0]
            association_options = args[1] || {}
            check_ability_on_object ability, obj, association_options
          end
        end
      end

      # declare authorization rules on a model. For example
      #   authorize do |role|
      #     role.owner  :can => :manage
      #     role.admin  :can => :manage
      #     role.member :can => :read, :if => :has_application_read_permission?
      #     role.member :can => [:create, :update, :destroy], :if => :has_application_write_permission?
      #   end
      #
      def authorize
        yield AuthorizeMe::RoleDefinition.new(self)
      end

      def add_authorization_rule(role, options)
        role = role.to_sym
        abilities = options[:can]
        abilities = [abilities] unless abilities.is_a?(Array)

        @authorization_rules ||= {}
        @authorization_rules[role] ||= {}

        abilities.each do |ability|
          @authorization_rules[role][ability.to_sym]          = {}
          @authorization_rules[role][ability.to_sym][:if]     = options[:if]
          @authorization_rules[role][ability.to_sym][:unless] = options[:unless]
        end
      end

      def authorization_rules
        @authorization_rules || {}
      end
    end

    module InstanceMethods
      protected
        def check_ability_on_object(ability, target, association_options)
          association = association_options[:for]
          checker = AuthorizeMe::AbilityChecker.new(ability, target, association, self)
          checker.check
        end
    end

  end
end

