class StackPresenter < SimpleDelegator
  def chronotriggers
    __getobj__.chronotriggers.map{ |t| ChronotriggerPresenter.new t }
  end

  def event
    __getobj__.event.to_json
  end
end

