class StartController < ApplicationController

  def index()
    @title = "Hello Rails!:"
    @header = "studyRails"
    @footer = "link"
    if request.post?
      @msg = params[:input]
    else
      @msg = "Not POST"
    end
  end
end
