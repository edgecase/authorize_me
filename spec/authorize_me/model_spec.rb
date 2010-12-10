require 'authorize_me'

describe AuthorizeMe::Model do

  class TestUser
    include AuthorizeMe::Model

    authorize_me

    attr_accessor :role, :owner

    def initialize(role=nil)
      @role = role
    end
  end

  class Rebel
    # no rules defined
  end

  class Article
    include AuthorizeMe::Model

    authorize do |role|
      role.author  :can => :create, :if => :my_blog?
      role.author  :can => :manage, :if => :owned_by?
      role.spammer :can => :create, :unless => :protected_by_captcha?
      role.reader  :can => :read
      role.creator :can => [:create, :update]
    end

    attr_accessor :owner, :blog

    def owned_by?(user)
      user == owner
    end

    def my_blog?(user)
      blog.owner == user
    end

    def protected_by_captcha?
      true
    end
  end

  class Blog
    attr_accessor :owner, :articles
  end

  describe TestUser do
    context '#can_xxx?' do
      it { should respond_to(:can_read?) }
      it { should respond_to(:can_update?) }
      it { should respond_to(:can_destroy?) }
      it { should respond_to(:can_create?) }

      it 'raises exception if the object has not defined authorization rules' do
        lambda { TestUser.new.can_read?(Rebel.new) }.should raise_error(AuthorizeMe::AuthorizationRuleMissing)
      end
    end

    context '#can_xxx?(:symbol)' do
      context 'author (specifying an "if" condition)' do
        let(:author)  { TestUser.new(:author) }
        let(:article) { Article.new }
        
        it 'can update when owner' do
          article.owner = author
          Article.stub! :new => article
          author.can_update?(:articles).should be_true
        end

        it 'cannot update when not owner' do
          author.can_update?(:articles).should be_false
        end

        context 'specifying an association' do
          let(:blog) { Blog.new }

          before do
            blog.stub_chain :articles, :new => article
            article.blog = blog
          end

          it 'can create articles for my own blog' do
            blog.owner = author
            author.can_create?(:articles, :for => blog).should be_true
          end

          it "cannot create articles for someone else's blog" do
            author.can_create?(:articles, :for => blog).should be_false
          end
        end
      end
    end

    context 'reader' do
      let(:reader) { TestUser.new(:reader) }

      it 'can read articles' do
        reader.can_read?(Article.new).should be_true
      end

      it 'cannot update articles' do
        reader.can_update?(Article.new).should be_false
      end
    end

    context 'author (specifying an "if" condition)' do
      let(:author)  { TestUser.new(:author) }
      let(:article) { Article.new }
      
      it 'can update when owner' do
        article.owner = author
        author.can_update?(article).should be_true
      end

      it 'cannot update when not owner' do
        author.can_update?(article).should be_false
      end
    end

    context 'spammer (specifying an "unless" condition)' do
      let(:spammer) { TestUser.new(:spammer) }
      let(:article) { Article.new }
      
      it 'can create when article is not protected by captcha' do
        article.stub! :protected_by_captcha? => false
        spammer.can_create?(article).should be_true
      end

      it 'cannot create when article is protected by captcha' do
        article.stub! :protected_by_captcha? => true
        spammer.can_create?(article).should be_false
      end
    end

    context 'creator (passing an array of abilities)' do
      let(:creator) { TestUser.new(:creator) }

      it 'can create and update articles' do
        creator.can_create?(Article.new).should be_true
        creator.can_update?(Article.new).should be_true
      end

      it 'cannot destroy articles' do
        creator.can_destroy?(Article.new).should be_false
      end
    end
  end
end
