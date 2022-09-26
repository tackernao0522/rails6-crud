class StudentsController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Students Data'
    @data = Student.all
    # @data = Student.includes(:people)
    # @people = Person.all
    # binding.pry
  end

  def show
    @msg = "Indexed data."
    @data = Student.find(params[:id])
  end
end
