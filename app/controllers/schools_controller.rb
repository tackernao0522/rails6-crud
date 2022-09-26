class SchoolsController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'School Data'
    @data = School.all
  end

  def show
    @msg = "Indexed data."
    @data = School.find(params[:id])
  end
end
