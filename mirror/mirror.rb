####
#  to run use:
#
#    $ ruby mirror/mirror.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webclient/lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )


require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.
require 'nokogiri'

require 'active_record'   ## todo: add sqlite3? etc.


Webcache.root = './cache'
Webget.config.delay_in_s = 1

## Webcache.root = '/sports/cache'   ## use "global" (shared) cache

BASE_URL = 'https://rsssf.org'




require_relative 'mirror/find_links'  ## find_links helper 'n' more
require_relative 'mirror/mirror'
require_relative 'mirror/download'

require_relative 'mirror/database'


## auto log errors  (append to logs.txt)
def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   File.open( './mirror/logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end



## or use PAGES_NOT_FOUND ??
PAGES_404 = [
  '/tablesn/nedantcup09.html',
  '/tablesz/zimb2022.html',
]






if __FILE__ == $0

configs = parse_csv( <<TXT )

## starter pages for (recursive) mirror
##   if no encoding specified - assumes windows-1252 !!

page, encoding

## /curdom.html
## /curtour.html

/tableso/oost2026.html

## /tablesi/ital2015.html

TXT

pp configs



MirrorDb.open


=begin
configs.each do |config|

     page = Page.new( path:     config['page'],
                      encoding: config['encoding'] )

     mirror_page( page )
end
=end




## start off with pages not cached
page_recs =  MirrorDb::Model::Page.where( cached: false ).limit( 100 )

page_recs.each do |page_rec|
    next if PAGES_404.include?( page_rec.path )

    page = Page.new( path:     page_rec.path,
                      encoding: page_rec.encoding)


    mirror_page( page )
end


puts "bye"

end     ## if __FILE__ == $0




__END__

url = "https://user:pass@example.com:8080/path/page.html?foo=1&bar=2#section-3"
uri = URI.parse(url)

puts uri.scheme    # "https"
puts uri.user      # "user"
puts uri.password  # "pass"
puts uri.host      # "example.com"
puts uri.port      # 8080
puts uri.path      # "/path/page.html"
puts uri.query     # "foo=1&bar=2"
puts uri.fragment  # "section-3"
