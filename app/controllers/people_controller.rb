class PeopleController < ApplicationController
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
  end
end
