require 'ostruct'
require 'yaml'
require 'snoo'
require 'logger'

class String
  def colorize(color, options = {})
    background = options[:background] || options[:bg] || false
    style = options[:style]
    offsets = ["gray","red", "green", "yellow", "blue", "magenta", "cyan","white"]
    styles = ["normal","bold","dark","italic","underline","xx","xx","underline","xx","strikethrough"]
    start = background ? 40 : 30
    color_code = start + (offsets.index(color) || 8)
    style_code = styles.index(style) || 0
    "\e[#{style_code};#{color_code}m#{self}\e[0m"
  end
end

config = OpenStruct.new YAML.load(File.read("/home/paradox/ruby/config.yaml"))

log = config.logfile.nil? ? Logger.new(STDOUT) : Logger.new(config.logfile, config.logrotate)

log.level = config.logging ? Logger::DEBUG : Logger::FATAL

log.info("Starting log on #{Time.now}")
reddit = Snoo::Client.new
log.debug('Logging into reddit')
reddit.log_in config.username, config.password
log.debug('Success!')

queue = Queue.new
retried = nil
config.subreddits.each do |subreddit, flairs|
  begin
    log.debug("Getting #{config.limit} new links for #{subreddit}")
    listing = reddit.get_listing(subreddit: subreddit, page: 'new', sort: 'new', limit: config.limit)['data']['children']
    log.debug("Getting #{config.limit} hot links for #{subreddit}")
    listing.concat reddit.get_listing(subreddit: subreddit, limit: config.limit)['data']['children']
    listing.uniq!
  rescue
    log.error("Got error #{$!}".colorize "red")
    if !retried.nil?
      retried = true
      log.debug('Trying again')
      retry
    else
      next
        retried = nil
    end
  ensure
    retried = nil
  end
  flairs.each do |reg, options|
    r = Regexp.new reg, options['ignore_case']
    log.debug("Matching against #{r}")
    listing.each do |thing|
      # binding.pry
      if thing['data']['title'] =~ r
        q = {
          subreddit: subreddit,
          template: options['id'],
          thing: 't3_' + thing['data']['id']
        }
        log.debug("Queueing #{q}")
        queue << q
        log.debug("Hiding (#{thing['data']['id']}) #{thing['data']['title']}")
        begin
          reddit.hide 't3_' + thing['data']['id']
          sleep 2
        rescue
          log.error("Got error #{$!}".colorize "red")
          if retried.nil?
            retried = true
            sleep 5
            log.debug('Trying again')
            retry
          else
            next
          end
        ensure
          retried = nil
        end
      end
    end
  end
  sleep 2
end

queue.length.times do
  flair = queue.pop
  begin
    log.debug("Setting flair on #{flair}")
    reddit.select_flair_template( flair[:template], flair[:subreddit], link: flair[:thing])
    sleep 2 # For reddit api limits, we sleep 2
  rescue
    log.error("Got error #{$!}".colorize "red")
    if retried.nil?
      retried = true
      sleep 5
      log.debug('Trying again')
      retry
    else
      next
    end
  ensure
    retried = nil
  end
end
