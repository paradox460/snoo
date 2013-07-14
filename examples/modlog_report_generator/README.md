# Requirements
+ You must be running a 1.9x or newer version of ruby. I do not support 1.8 or older.
+ You must use bundler. `bundle install` for the various dependencies
+ You must be comfortable editing code, but if you can follow comments, you can use this script

# Running the script
1. Edit modreport.rb to fill in the required information
  + **Username:** Self-explanatory
  + **Password:** Self-explanatory
  + **Subreddit:** the subreddit, without the `/r/`. IAMA would be `IAMA`. Case does not matter
  + **Start Date:** The beginning (oldest) of when you want to parse. Uses ruby `Date.parse`, so any supported syntax works, but I recommend `December 1, 2012 0:00 UTC` style syntax
  + **End Date:** The end (newest) of when you want to parse. Uses ruby `Date.parse`, so any supported syntax works, but I recommend `December 1, 2012 0:00 UTC` style syntax
  + **CSV Prefix:** The prefix for the CSV files you want to generate. I usually name mine something like `subreddit-month`
2. Run `ruby modreport.rb`
3. Watch the response for errors
  + [Open an issue on the tracker if you find one](https://github.com/paradox460/snoo/issues)
4. Open the CSV files in excel or your spreadsheet of choice and do what you will with them

# License
This is licensed under the same terms as the Snoo script, the MIT License:

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
