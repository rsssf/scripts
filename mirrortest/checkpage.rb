
## pull in mirror machinery
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget-mirror/lib' )
require 'webget/mirror'


## check links
## -- /intclub-friend.html


Webcache.root = './cache'


## url = 'https://rsssf.org/intclub-friend.html'
url = 'https://rsssf.org/tablesc/chevserena2017.html'
html = Webcache.read( url )

pp html[0..400]


site = Webget::Mirror::Website.new
site.base_url = 'https://rsssf.org'


mirror =  Webget::Mirror.new
doc = Nokogiri::HTML( html )

pp mirror._find_links( site: site,
                       doc: doc,
                       url: url,
                       verbose: true )


puts "bye"
