require 'snoo'
require 'io/console'
require 'csv'
@r = Snoo::Client.new

puts <<-EOF
This script will delete ALL flair from your subreddit. It will not save any
If you ran this by accident, ^c out of the terminal at any time to cancel.
EOF

puts "Please log in with an account that has moderator permissions"
print 'User: '
user = gets.chomp
print 'Password: '
password = $stdin.noecho(&:gets).chomp

puts "-" * $stdin.winsize[1]
puts "Please enter the subreddit name you wish to remove flair from"
print "Subreddit: "
subreddit = gets.chomp

puts "-" * $stdin.winsize[1]

@r.log_in user, password
sleep 2

puts "Disabling flair and user flair selection"
@r.flair_config subreddit, flair_enabled: false, flair_self_assign_enabled: false
sleep 2

puts "Beginning download of flair"
x = @r.get_flair_list subreddit

flair = x['users']
after = x['next']
puts "Got #{flair.count} users"
sleep 2
while !after.nil?
  x = @r.get_flair_list subreddit, after: after
  flair.concat x['users']
  after = x['next']
  puts "Got #{flair.count} users"
  sleep 2
end

puts "-" * $stdin.winsize[1]
puts "Beginning deletion of flair"

counter = 0
flair.each_slice(100) do |f|
  csv_string = CSV.generate do |csv|
    f.each do |r|
      csv << [r['user'], '', '']
    end
  end
  @r.flair_csv(csv_string, subreddit)
  counter += 100
  counter = flair.count unless counter < flair.count
  puts "Removed #{counter} flairs!"
  sleep 2
end
