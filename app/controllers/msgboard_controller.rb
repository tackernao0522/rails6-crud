class MsgboardController < ApplicationController
  layout 'msgboard'

  def initialize
    super
    begin
      @msg_data = JSON.parse(File.read("data.txt"))
    rescue => exception
      @msg_data = Hash.new
    end
    File.write("data.txt", @msg_data.to_json)
  end

  def index
    @header = 'メッセージボード'
    @footer = 'studyRails'
    if request.post? then
      obj = MyData.new(params['name'], params['email'], params['msg'])
      @msg_data[@msg_data.length] = obj
      data = @msg_data.to_json
      File.write("data.txt", data)
      @msg_data = JSON.parse(data)
    end
  end
end

class MyData
  attr_accessor :name
  attr_accessor :mail
  attr_accessor :msg

  def initialize(name, mail, msg)
    @name = name
    @mail = mail
    @msg = msg
  end
end
