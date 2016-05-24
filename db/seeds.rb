users = {
  'ashby' => {
    username: 'ashby',
    password: ENV['ASHBY_USER_PASS'] || 'test',
    preferences: {
      email: 'joshashby@joshashby.com'
    },
    groups: [
      'admin'
    ]
  }
}.inject({}) do |memo, (key, data)|
  user = User.create(**data.slice(:username, :password))

  memo[key] = user
  memo
end

{
  'xkcd alt/src extractor' => [
    {
      processor: 'website',
      options: {
        url: 'http://xkcd.com'
      }
    },
    {
      processor: 'extract',
      options: {
        type: 'xpath',
        extract: {
          alt: '//*[@id="comic"]/img/@alt',
          image: '//*[@id="comic"]/img/@src'
        },
        from: "{{ body }}"
      }
    }
  ]
}.each do |name, frames|
  stack = Stack.create user: users['ashby'], name: name

  frames.each do |frame_options|
    Frame.create user: users['ashby'], stack: stack, **frame_options
  end
end
