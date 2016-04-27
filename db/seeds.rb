groups = {
  'admin' => {
    name: 'admin'
  }
}.inject({}) do |memo, (key, data)|
  memo[key] = Group.create(**data)
  memo
end

users = {
  'ashby' => {
    username: 'ashby',
    password: 'test',
    preferences: {
      email: 'joshashby@joshashby.com'
    },
    groups: [
      'admin'
    ]
  }
}.inject({}) do |memo, (key, data)|
  user = User.create(**data.slice(:username, :password))

  # if data.has_key? :preferences
  #   data[:preferences].each do |k, v|
  #     next unless User.preferences.has_key? k.to_sym
  #     user.set_preference k, v unless user.get_preference k
  #   end
  # end

  if data.has_key? :groups
    data[:groups].each do |g|
      next unless groups.has_key? g
      groups[g].add_user user
    end
  end

  memo[key] = user
  memo
end

groups.values.each(&:save)
