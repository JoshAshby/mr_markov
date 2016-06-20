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
    },
    {
      processor: 'change',
      options: {
        from: "{{ image }}",
        on_change: {
          alt: "{{ alt }}",
          image: "{{ image }}"
        }
      }
    },
    {
      processor: 'telegram',
      options: {
        token: ENV['TELEGRAM_TOKEN'],
        chat_id: '204348342',
        message: "Heya! there is a new http://xkcd.com available! {{ image }} with alt-text:\n\t{{ alt }}"
      }
    }
  ]
}.each do |name, frames|
  stack = Stack.create user: users['ashby'], name: name

  frames.each do |frame_options|
    Frame.create stack: stack, **frame_options
  end

  trigger = Chronotrigger.create name: "#{ name } (#{ stack.id }) chronotrigger",
    frequency_quantity: 1,
    frequency_period: :minutes,
    run_time: '8:00am',
    job_klass: :StackRunnerBlock,
    job_arguments: Marshal.dump([ [], { stack: stack, event: {} } ])
end
