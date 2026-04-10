############
#  to run use:
#   $ ruby sandbox/lint.rb 


require_relative 'helper'


pages = []
pages += read_csv( "./config/eng.csv" )
pages += read_csv( "./config/es.csv" )
pages += read_csv( "./config/de.csv" )
pages += read_csv( "./config/at.csv" )
pages += read_csv( "./config/worldcup.csv" )
pages += read_csv( "./config/worldcup_quali.csv" )
pages += read_csv( "./config/br.csv" )
pages += read_csv( "./config/curdom.csv" )
pp pages


TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm



def find_title( html )
  if m=TITLE_RE.match( html )
     text = m[:text].strip
     ## note - convert html entities
     ##  e.g. Brazil 2000 - Copa Jo&atilde;o Havelange
     text = Rsssf::PageConverter.convert_html_entities( text )
     text
  else
     nil
  end
end



pages.each do |config|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  html = Webcache.read( url )
  ##  note - quick-fix known html errors
  ##   e.g  ##  <</TITLE> in tablesb/braz88.html 
  html = Rsssf::PageConverter.errata_html( html )


  title        = find_title( html )
   ## check for number of pre(formatted) blocks
   pres =  html.scan( /<PRE>/i )

   if title.nil? 
      puts "!! WARN - no title found for page >#{page}<"
   end

   if pres.size == 0
      puts "!! WARN - no pre blocks found inside page >#{page}<"
   end

   ## check
   ##    UTF-8 misread as Windows-1252 (MOST COMMON)
   ##  Happens when UTF-8 bytes are decoded as Windows-1252 / ISO-8859-1
    ##   mojibake (encoding bug)
    ##
    ##  
  
  mojibakes = html.scan( /  
                       Ã¤	 ## ä	a-umlaut
                     | Ã¶	 ## ö	o-umlaut
                     | Ã¼	 ## ü	u-umlaut
                     | ÃŸ	 ## ß	sharp s
                     | Ã©	 ## é	accented e
                     | Ã¨	 ## è	accented e
                     | Ã¡	 ## á	accented a
                     | Ã³	 ## ó	accented o
                ## Smart quotes explosion
                ## Very strong signal of encoding mismatch
                     | â€™  ##	’
                     | â€œ	 ##   “
                     | â€	 ##   ”
                     | â€“	 ##   –
                     | â€”  ##	—
                     | â€¦  ## 	…
                 ## Double-encoded UTF-8
                 ## Text encoded twice (yes, it happens…)
                      | ÃƒÂ¤	   ## ä
                      | ÃƒÂ¶	   ## ö
                      | ÃƒÂ¼	   ## ü
                 ## Central European issues (Windows-1250 vs ISO-8859-2)
                 ## Common with Polish Czech text
                 ##    UTF-8 misread as Windows-1250,1252
                      | Å‚	      ## ł
                      | Å›       ##	ś
                      | Å¼	      ## ż
                      | Ä‡       ##	ć
                 ## Lone replacement characters
                 ##   means decoding already failed - data is partially lost or misinterpreted
                       | �
                  
                      /x)
  if mojibakes.size > 0
     puts "!! WARN - found #{mojibakes.size} char encoding bugs (utf-8 misread as windows-1252?) in page >#{page}<:"
     pp mojibakes
  end
end




puts "bye"




