#!/usr/bin/env ruby
require 'snoo'
require 'highline/import'
require 'tempfile'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: mod_mailer.rb [options]"

  opts.on("-n", "Don't actually send the messages or Log in to reddit.") do
    options[:norun] = true
  end

  opts.on("-a", "Auto-mode. Disables yN prompt. Does not disable needed info prompts, so use the other flags.") do 
    options[:quiet] = true
  end

  opts.separator ""
  opts.separator "Authentication"
  opts.on("-u", "--username USERNAME", "The username you want to log into reddit with.") do |user|
    options[:username] = user
  end
  opts.on("-p", "--password PASSWORD", "Your reddit password. This may show up in your terminal history.") do |pass|
    options[:password] = pass
  end

  opts.separator ""
  opts.separator "Message options"
  opts.on("-r", "--subreddit SUBREDDIT", "The subreddit of the moderators you want to fetch from") do |subreddit|
    if subreddit =~ /\A[A-Za-z0-9][A-Za-z0-9_]{2,20}\z/
      options[:subreddit] = subreddit
    else
      raise "Invalid subreddit name"
    end
  end
  opts.on("-s", "--subject SUBJECT", "The subject of the modmail message") do |subject|
    options[:subject] = subject
  end
  opts.on("-m", "--message MESSAGE", "The message you want to send.") do |msg|
    options[:message] = message
  end
end.parse!

# Some code i shamelessly copied from Pry.
def blocking_flag_for_editor(block, editor_name)
  case editor_name
  when /^emacsclient/
    '--no-wait' unless block
  when /^[gm]vim/
    '--nofork' if block
  when /^jedit/
    '-wait' if block
  when /^mate/, /^subl/
    '-w' if block
  end
end

def start_line_syntax_for_editor(editor_name, file_name, line_number)

  # special case for 1st line
  return file_name if line_number <= 1

  case editor_name
  when /^[gm]?vi/, /^emacs/, /^nano/, /^pico/, /^gedit/, /^kate/
    "+#{line_number} #{file_name}"
  when /^mate/, /^geany/
    "-l #{line_number} #{file_name}"
  when /^subl/
    "#{file_name}:#{line_number}"
  when /^uedit32/
    "#{file_name}/#{line_number}"
  when /^jedit/
    "#{file_name} +line:#{line_number}"
  else
    "+#{line_number} #{file_name}"
  end
end

reddit = Snoo::Client.new

if options[:username]
  username = options[:username]
else
  username = ask("Username: ") { |c| c.readline = true }
end

if options[:password]
  password = options[:password]
else
  password = ask("Password: ") { |c| c.echo = '*' ; c.readline = true}
end

if options[:norun]
  puts HighLine.color("Not actually logging in due to -n", :cyan)
else
  puts HighLine.color("Logging in", :yellow) 
  reddit.log_in(username, password)
  puts HighLine.color("Success", :green)
end

if options[:subreddit]
  subreddit = options[:subreddit]
else
  puts "Subreddit you want mods for"
  subreddit = ask("/r/ ") do |r|
    # Checks to see if its a valid subreddit, using the regex reddit itself uses
    r.validate = /\A[A-Za-z0-9][A-Za-z0-9_]{2,20}\z/
    r.responses[:not_valid] = "Thats not a valid subreddit. Lets try again:"
    r.readline = true
  end
end
mods = []
puts HighLine.color("Getting mods from #{HighLine.color(subreddit, :blue)}", :yellow)
reddit.get_moderators(subreddit)['data']['children'].each do |moderator|
  mods << moderator["name"]
end
puts HighLine.color("Got #{mods.size} mods!", :green)

# Store the message in a hash
message = {}

if options[:subject]
  message['subject'] = options[:subject]
else
  message['subject'] = ask("Subject: ") do |subj|
    subj.validate = /\A.*\z/
    subj.responses[:not_valid] = "Subjects can't contain newlines, doofus"
    subj.readline = true
  end
end

if options[:message]
  message['message'] = options[:message]
else
  modmessage_path = Tempfile.new("modmsg.md").path

  File.open(modmessage_path, 'w') do |f|
    f.puts "// Edit your moderator message below"
    f.puts "// Lines that begin with // are comments. They will not be sent."
    f.puts "// If the file is empty, the program will terminate"
    f.puts "\n"
    f.puts "// Moderators this will message:"
    mods.each do |mod|
      f.puts "//   * #{mod}"
    end
  end
  editor_name = ENV['EDITOR']
  system "#{editor_name} #{blocking_flag_for_editor(true, editor_name)} #{start_line_syntax_for_editor(editor_name, modmessage_path, 4)}"

  message['message'] = File.read(modmessage_path)
end
raise "Empty message" unless message['message'].size > 0

# Strip the comments
message['message'].gsub!(/^\/{2}.*$\n/, '').chomp!

raise "Empty message" unless message['message'].size > 0

puts HighLine.color("This is a preview of your message:", :yellow)
puts "Subject: #{message['subject']}"
puts "-" * 4
puts message['message']
puts "-" * 4

unless options[:quiet]
  exit unless agree(HighLine.color("Do you want to send a message to #{mods.size} moderators? ", :yellow)) do |agreement|
    agreement.default = 'N'
  end
end

if options[:norun]
  puts HighLine.color("Not sending messages due to -n", :cyan)
else
  puts HighLine.color("Sending messages", :green)
  count = 0
  mods.each do |mod|
    count += 1
    puts HighLine.color("Sending message to #{HighLine.color(mod, :blue)}", :yellow)
    reddit.send_pm(mod, message['subject'], message['message'])
    puts HighLine.color("Success!, #{count}/#{mods.size} mods done", :green)
    puts "Sleeping for 3s"
    sleep(3)
  end
end
