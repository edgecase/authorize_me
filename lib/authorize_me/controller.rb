module AuthorizeMe
  module Controller

    private 

      def unauthorized!
        raise AuthorizeMe::Unauthorized
      end
  
  end
end
