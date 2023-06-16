require 'rest-client'

USERS_MIN_COUNT = 100
IP_MIN_COUNT = 50
POSTS_MIN_COUNT = 200_000
HOST = 'http://localhost:3000'

def generate_values(count, method_name)
  values = (1..(count * 2)).map { Faker::Internet.send method_name }.uniq
  while values.count < count
    values = (1..(count * 2)).map { Faker::Internet.send method_name }.uniq
  end
  values.sample(count)
end

def post_params(login, ip)
  {
    login:,
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph(sentence_count: rand(1..10)),
    ip:
  }.to_json
end

logins = generate_values(USERS_MIN_COUNT, :username)
ips = generate_values(IP_MIN_COUNT, :ip_v4_address)

POSTS_MIN_COUNT.times do |n|
  puts "#{n + 1}/#{POSTS_MIN_COUNT}"

  begin
    RestClient.post("#{HOST}/api/posts",
                    post_params(logins.sample, ips.sample),
                    { content_type: :json, accept: :json })
  rescue RestClient::Exception => err
    puts err.response
  end
end

Post.all.sample(Post.count * 0.75).each do |post|

  rand(1..3).times do
    value = Faker::Number.within(range: 1..5)
    params = {
      value:,
      user_id: User.all.sample.id
    }.to_json

    begin
      RestClient.post("#{HOST}/api/posts/#{post.id}/rate",
                      params,
                      { content_type: :json, accept: :json })
      puts '*' * value
    rescue RestClient::Exception => err
      puts err.response
    end
  end
end