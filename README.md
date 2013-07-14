# Snoo

Snoo is a *simple* wrapper for the reddit.com api. Its designed to provide an interface as close to the official api as possible, while freeing you from the problems of dealing with json, webserver requests, and session/cookie management.

Unlike other API wrappers, this one doesn't make use of complicated objects or classes, once you instantiate it once, you are good to go.

Since it's designed to be simple, it leaves things like rate limiting up to you. Please follow the [reddit api rules](https://github.com/reddit/reddit/wiki/API) and only send one request every 2 seconds (you can use `sleep 2` between requests).

Also, if you build programs with it, please change the user agent to your specific use case.

## Installation

Add this line to your application's Gemfile:

    gem 'snoo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snoo

## Usage

Here's a simple script that sends a private message:

```ruby
require 'snoo'

# Create a new instance of the client
reddit = Snoo::Client.new

# Log into reddit
reddit.log_in 'Username', 'Password'

# Send a private message to me (Paradox!)
reddit.send_pm 'Paradox', 'Snoo rubygem rocks!', "Hey Paradox, I'm trying your Snoo rubygem out and it rocks. Thanks for providing such an awesome thing!"

# Log back out of reddit
reddit.log_out
```

See the [docs](http://rubydoc.info/github/paradox460/snoo/) for more info.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Test your changes (via `rspec`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Feed me!
Any and all donations are graciously accepted:

+ [![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=Paradox460&url=https://github.com/paradox460/snoo&title=Snoo&language=&tags=github&category=software)
+ [Gittip](https://www.gittip.com/paradox460/)
+ Paypal: send to paradox460@gmail.com

I also would love it if you could endorse this on Coderwall: [![endorse](http://api.coderwall.com/paradox/endorsecount.png)](http://coderwall.com/paradox)

Thanks!

## License

```
Copyright (c) 2012 Jeff Sandberg

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
