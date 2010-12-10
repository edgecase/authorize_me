ActiveRecord::Base.send(:include, AuthorizeMe::Model)
ActionController::Base.send(:include, AuthorizeMe::Controller)
