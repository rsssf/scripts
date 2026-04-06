
############
#  to run use:
#   $ ruby sandbox/worldcup_dl.rb


##
# step 1 - download all world cup "full" pages


require_relative 'helper'


##
## tip: to check charset encoding
##    use chrome browser and console
##    and  $ document.characterSet
##    resulting in => 'ISO-8859-2', for example



pages = parse_csv(<<TXT)
page, encoding
tables/30full.html,   iso-8859-2  ## windows-1250                  ## ISO-8859-2
tables/34full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/38full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/50full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/54full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/58full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/62full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2 
tables/66full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/70full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/74full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/78full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/82full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/86full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/90full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/94full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/98full.html,   iso-8859-2  ## windows-1250                   ## ISO-8859-2
tables/2002full.html, windows-1252       ## note - utf-8  reports invalid utf-8 byte sequence; use windows-1252
tables/2006full.html, windows-1252                  ## windows-1252 !!
tables/2010full.html, utf-8
tables/2014full.html, utf-8
TXT




pp pages


pages.each do |config|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://www.rsssf.org/#{page}"

  html = Rsssf.download_page( url, encoding: encoding )
end



puts "bye"