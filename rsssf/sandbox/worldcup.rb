############
#  to run use:
#   $ ruby sandbox/worldcup.rb


require_relative 'helper'

=begin


=end

encoding = 'utf-8'
url = 'https://www.rsssf.org/tables/2014full.html'

## html = Rsssf.download_page( url, encoding: encoding )
## html = read_txt( "./cache/www.rsssf.org/tables/2014full.html")

html = Webcache.read( url )

txt = Rsssf::PageConverter.convert( html, url: url )

puts txt

write_text( "./tmp/2014full.txt", txt )


__END__
## encoding = 'Windows-1252'


### 'ISO-8859-2'
encoding = 'Windows-1250'
url = 'https://www.rsssf.org/tables/30full.html'

## html = Rsssf.download_page( url, encoding: encoding )


## html = read_txt( "./cache/www.rsssf.org/tables/30full.html")

html = Webcache.read( url )

txt = Rsssf::PageConverter.convert( html, url: url )

puts txt

write_text( "./tmp/30full.txt", txt )

puts "bye"


__END__

17.07.30  (12.45) Montevideo, Parque Central

JUG - BOL 4:0 (0:0)

(~20000) Matteucci URU, Lombardi URU, Wernken CHI

<B>JUG</B>: Jak¹iæ - Ivkoviæ (c), Mihajloviæ - Arsenijeviæ, Stevanoviæ,
Djokiæ - Tirnaniæ, Marjanoviæ, Bek, Vujadinoviæ, Sekuliæ
