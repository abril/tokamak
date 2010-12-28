class TestController < ApplicationController
  def show
    @some_articles = [
      {:id => 1, :title => "a great article", :updated => Time.now},
      {:id => 2, :title => "another great article", :updated => Time.now}
    ]
    response.content_type = request.negotiated_type
  end
end
