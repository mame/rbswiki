module RBSWiki
  class Wiki
    def initialize
      @content = {}
    end

    def has_page?(name)
      @content.key?(name)
    end

    def find_page(name)
      if content = @content[name]
        Page.load(name: name, content: content)
      end
    end

    def update_page(name)
      page = find_page(name) || Page.empty(name: name)
      @content[name] = yield(page).content
    end

    def each_page(&block)
      if block
        @content.each do |name, content|
          block.call Page.load(name: name, content: content)
        end
      else
        enum_for :each_page
      end
    end
  end
end

if $0 == __FILE__
  require 'rack'
  require_relative "../rbswiki"

  #use Rack::ShowExceptions

  wiki = RBSWiki::Wiki.new

  wiki.update_page("TopPage") do |page|
    page.update(content: <<CONTENT)
Welcome to RBSWiki!

This is a simple wiki page to demostrate RBS programming.

About [RBSwiki]
CONTENT
  end

  #run RBSWiki::Server.new(wiki: wiki)
  RBSWiki::Server.new(wiki: wiki)
end