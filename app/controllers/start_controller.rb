class StartController < ApplicationController

  def index()
    if request.post?
      @title = "Hello Rails!:"
      @msg = params[:input]
    else
      @title = "Hello Rails!:"
      @msg = "Not POST"
    end
  end
end
