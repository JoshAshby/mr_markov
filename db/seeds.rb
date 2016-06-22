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
    triggers: [
      {
        type: :chronotrigger,
        start_time: '8:00am',
        repeat_delta: 1.day
      }
    ],
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
  },
  'forecast.io next hour' => {
    triggers: [
      {
        type: :chronotrigger,
        start_time: '4:00am',
        repeat_delta: 4.hours
      }
    ],
    frames: [
      {
        processor: 'website',
        options: {
          url: 'https://api.forecast.io/forecast/74f65677b181ada2161b5f8162b40426/40.0226,-105.2570'
        }
      },
      {
        processor: 'extract',
        options: {
          type: 'json',
          extract: {
            temperature: '$.hourly.data[0].apparentTemperature',
            precipitation_chance: '$.hourly.data[0].precipProbability',
            summary: '$.hourly.data[0].summary'
          },
          from: "{{ body }}"
        }
      },
      {
        processor: 'telegram',
        options: {
          token: ENV['TELEGRAM_TOKEN'],
          chat_id: '204348342',
          message: "Temp: {% if temperature[0] > 80.0 %}HOT{% elsif temperature[0] >= 65.0 && temperature[0] <= 80.0 %}NICE{% elsif temperature[0] < 65.0 && temperature[0] >= 40.0 %}CHILLY{% elsif temperature[0] < 40.0 %}COLD{% else %}¯\_(๏̯͡๏)_/¯ {% endif %} ({{temperature[0]}}F)
Precip: {% if precipitation_chance[0] >= 0.15 && precipitation_chance[0] < 0.40 %}QUESTIONABLY WET{% elsif precipitation_chance[0] >= 0.40 && precipitation_chance[0] < 0.60 %}WET{% elsif precipitation_chance[0] >= 0.60 %}SUPAWET{% else %}NOAP{% endif %} ({{ precipitation_chance[0] * 100.0 | ceil }}%)
Summary: {{ summary[0] }}"
        }
      }
    ]
  },
  'forecast.io currently' => {
    triggers: [
      {
        type: :telegram,
        command: :weather
      }
    ],
    frames: [
      {
        processor: 'website',
        options: {
          url: 'https://api.forecast.io/forecast/74f65677b181ada2161b5f8162b40426/40.0226,-105.2570'
        }
      },
      {
        processor: 'extract',
        options: {
          type: 'json',
          extract: {
            temperature: '$.currently.apparentTemperature',
            precipitation_chance: '$.currently.precipProbability',
            summary: '$.currently.summary'
          },
          from: "{{ body }}"
        }
      },
      {
        processor: 'telegram',
        options: {
          token: ENV['TELEGRAM_TOKEN'],
          chat_id: '204348342',
          message: "Temp: {% if temperature[0] > 80.0 %}HOT{% elsif temperature[0] >= 65.0 && temperature[0] <= 80.0 %}NICE{% elsif temperature[0] < 65.0 && temperature[0] >= 40.0 %}CHILLY{% elsif temperature[0] < 40.0 %}COLD{% else %}¯\_(๏̯͡๏)_/¯ {% endif %} ({{temperature[0]}}F)
Precip: {% if precipitation_chance[0] >= 0.15 && precipitation_chance[0] < 0.40 %}QUESTIONABLY WET{% elsif precipitation_chance[0] >= 0.40 && precipitation_chance[0] < 0.60 %}WET{% elsif precipitation_chance[0] >= 0.60 %}SUPAWET{% else %}NOAP{% endif %} ({{ precipitation_chance[0] * 100.0 | ceil }}%)
Summary: {{ summary[0] }}"
        }
      }
    ]
  }
}.each do |name, data|
  stack = Stack.create user: users['ashby'], name: name

  data[:frames].each do |frame_options|
    Frame.create stack: stack, **frame_options
  end

  data[:triggers].each do |trigger|
    case trigger[:type]
    when :chronotrigger
      BlockRunnerWorker.schedule_async start_time: trigger[:start_time],
        repeat_delta: trigger[:repeat_delta],
        block_klass: StackRunnerBlock,
        stack: stack,
        event: {}
    end
  end
end
