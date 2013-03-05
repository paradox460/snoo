require 'snoo'
require 'csv'
require 'set'
require 'highline/import'

reddit = Snoo::Client.new

# CONFIG BLOCK

username = ask("Username: ")
password = ask("Password: ") { |c| c.echo = '*' ; c.readline = true}

subreddit = ask("Subreddit: ")

start_date = ask("Start Date: ")
end_date = ask("End Date: ")

csv_prefix = ask("CSV Prefix: ")


reddit.log_in username, password

modlog = reddit.get_modlog(subreddit)
data, last = modlog[:data], modlog[:last]
while (data[-1][:time] > Time.parse(start_date) ) do
  begin
    modlog = reddit.get_modlog(subreddit, after: last)
    last = modlog[:last]
    data.concat modlog[:data]
    puts "Got #{data[-1][:time]}"
    sleep 2
  rescue
    binding.pry
  end
end

data.delete_if do |i|
  (i[:time] > Time.parse(end_date)) or (i[:time] < Time.parse(start_date)) or (i[:author] == 'RoboMod')
end

modlist = {}
data.each do |i|
  modlist[i[:author]] ||= Hash.new(0)
  modlist[i[:author]][i[:action]] += 1
end

CSV.open("#{csv_prefix}.csv", "wb") do |csv|
    csv << ["Mod", "Remove", "Approve", "Remove Comment", "Approve Comment", "NSFW", "Edit Flair", "Edit Settings", "Distingusih", "Ban", "Unban", "Add Mod", "Remove Mod", "Add Contrib.", "Remove Contrib."]
  modlist.each do |k, v|
    csv << [
      k,
      v["removelink"],
      v["approvelink"],
      v["removecomment"],
      v["approvecomment"],
      v["marknsfw"],
      v["editflair"],
      v["editsettings"],
      v["distinguish"],
      v["banuser"],
      v["unbanuser"],
      v["addmoderator"],
      v["removemoderator"],
      v["addcontributor"],
      v["removecontributor"]
    ]
  end
end
puts "Saved #{csv_prefix}.csv with modlog table"

modtime = {}
data.each do |m|
  modtime[Date.parse(m[:time].utc.strftime('%Y-%m-%d'))] ||= Hash.new(0)
  modtime[Date.parse(m[:time].utc.strftime('%Y-%m-%d'))][m[:action]] += 1
end

CSV.open("#{csv_prefix}_time.csv", "wb") do |csv|
    csv << ["Date", "Remove", "Approve", "Remove Comment", "Approve Comment", "NSFW", "Edit Flair", "Edit Settings", "Distingusih", "Ban", "Unban", "Add Mod", "Remove Mod", "Add Contrib.", "Remove Contrib."]
  modtime.each do |k, v|
    csv << [
      k.strftime('%Y-%m-%d'),
      v["removelink"],
      v["approvelink"],
      v["removecomment"],
      v["approvecomment"],
      v["marknsfw"],
      v["editflair"],
      v["editsettings"],
      v["distinguish"],
      v["banuser"],
      v["unbanuser"],
      v["addmoderator"],
      v["removemoderator"],
      v["addcontributor"],
      v["removecontributor"]
    ]
  end
end
puts "Saved #{csv_prefix}_time.csv with time-series data"


# Moderator activity per day
authors = Set.new
data.each do |i|
  authors << i[:author]
end

authorhash = {}
authors.to_a.each do |i|
  authorhash[i] = 0
end

modactivity = {}
data.each do |m|
  modactivity[Date.parse(m[:time].utc.strftime('%Y-%m-%d'))] ||= authorhash.dup
  modactivity[Date.parse(m[:time].utc.strftime('%Y-%m-%d'))][m[:author]] += 1
end

header = ["Date"]
header += authors.to_a

CSV.open("#{csv_prefix}_actions_over_time.csv", "wb") do |csv|
  csv << header
  modactivity.each do |k, v|
    line = []
    line << k.strftime('%Y-%m-%d')
    v.each do |name, amount|
      line << amount
    end
    csv << line
  end
end

puts "Saved #{csv_prefix}_actions_over_time.csv with actions-over-time data"
