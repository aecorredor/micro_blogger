require 'jumpstart_auth'

# twitter spambot
class MicroBlogger
  attr_reader :client

  def initialize
    puts 'Initializing...'
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    if message.length > 140
      puts 'message exceeds 140 characters, aborting tweet...'
    else
      @client.update(message)
    end
  end

  def dm(target, message)
    screen_names = @client.followers.collect do |follower|
      @client.user(follower).screen_name
    end
    puts "Trying to send #{target} this direct message: #{message}"
    direct_message = "d @#{target} #{message}"
    if screen_names.include?(target)
      tweet(direct_message)
    else
      puts 'Target does not follow you, aborting direct message...'
    end
  end

  def friends_last_tweet
    friends = @client.friends.map { |friend| @client.user(friend).screen_name }
    friends.sort_by!(&:downcase)
    friends.each do |friend|
      status = @client.user(friend).status
      date = status.created_at.strftime('%A, %b %d %Y')
      puts "#{friend} said this on #{date}..."
      puts status.text
      puts
    end
  end

  def run
    puts "Welcome to Alejandro's Twitter Client!"
    command = ''
    while command != 'q'
      printf 'enter command: '
      input = gets.chomp
      parts = input.split(' ')
      command = parts[0]
      display_menu(command)
    end
  end

  def display_menu(command)
    case command
    when 'q' then puts 'Exiting program...'
    when 't' then tweet(parts[1..-1].join(' '))
    when 'dm' then dm(parts[1], parts[2..-1].join(' '))
    when 'elt' then friends_last_tweet
    else
      puts "Command #{command} does not exist."
    end
  end
end

blogger = MicroBlogger.new
blogger.run
