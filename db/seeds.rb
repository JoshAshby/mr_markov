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
  'xkcd alt/src extractor' => {
    start_time: Time.current-1.day,
    repeat_delta: 1.day,
    frames: [
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
  }
}.each do |name, data|
  stack = Stack.create user: users['ashby'], name: name

  data[:frames].each do |frame_options|
    Frame.create stack: stack, **frame_options
  end

  BlockRunnerWorker.schedule_async start_time: data[:start_time],
    repeat_delta: data[:repeat_delta],
    block_klass: StackRunnerBlock,
    stack: stack,
    event: {}
end
