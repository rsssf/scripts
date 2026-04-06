############
#  to run use:
#   $ ruby sandbox/worldcup.rb


require_relative 'helper'



pages = parse_csv(<<TXT)
page, encoding
tables/30full.html,   windows-1250                  ## ISO-8859-2
tables/34full.html,   windows-1250                   ## ISO-8859-2
tables/38full.html,   windows-1250                   ## ISO-8859-2
tables/50full.html,   windows-1250                   ## ISO-8859-2
tables/54full.html,   windows-1250                   ## ISO-8859-2
tables/58full.html,   windows-1250                   ## ISO-8859-2
tables/62full.html,   windows-1250                   ## ISO-8859-2 
tables/66full.html,   windows-1250                   ## ISO-8859-2
tables/70full.html,   windows-1250                   ## ISO-8859-2
tables/74full.html,   windows-1250                   ## ISO-8859-2
tables/78full.html,   windows-1250                   ## ISO-8859-2
tables/82full.html,   windows-1250                   ## ISO-8859-2
tables/86full.html,   windows-1250                   ## ISO-8859-2
tables/90full.html,   windows-1250                   ## ISO-8859-2
tables/94full.html,   windows-1250                   ## ISO-8859-2
tables/98full.html,   windows-1250                   ## ISO-8859-2
tables/2002full.html, utf-8
tables/2006full.html, windows-1252                  ## windows-1252 !!
tables/2010full.html, utf-8
tables/2014full.html, utf-8
TXT



pages.each do |config|
    page = config['page']

    url  = "https://www.rsssf.org/#{page}"
    html = Webcache.read( url )

    basename = File.basename( page, File.extname( page ))

    puts
    puts "==> converting #{basename}..."

    txt = Rsssf::PageConverter.convert( html, url: url )

    write_text( "./tmp/#{basename}.txt", txt )
end


puts "bye"

