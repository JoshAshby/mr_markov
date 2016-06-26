class ChronotriggerPresenter < SimpleDelegator
  def day_mask
    __getobj__.day_mask.chars.map(&:to_i).map.with_index{ |i, idx| next if i == 0; [ 'S', 'M', 'T', 'W', 'R', 'F', 'S' ][idx] }.join ' '
  end
end
