###
#  to run use:
#
#   $ ruby mirrorx/report_enc.rb


require_relative 'helper'


MirrorDb.open( './mirror.db' )


buf = String.new
buf << "#{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"
buf << "\n"
buf << "  #{MirrorDb::Model::Link.count} links(s)"
buf << "\n\n"


puts buf




###
## get directory html stats
##
def build

=begin
 t.string  :encoding           ## "upstream" text encoding
                                 ##   all pages ALWAYS converted to utf-8
   t.string  :encoding_source   ## e.g. bom|http|html|user|fallback

   t.boolean :encoding_valid  ## uses  String#encoding_valid?
   t.boolean :ascii7bit       ## uses  String#ascii_only?  check if all chars are ascii 7bit (utf8-compatible) ??
   t.integer :chars_8bit       ## count of 8bit (126-255) chars - nil|0|1|2|etc.
   t.integer :utf8_replace     ## count invalid/replace chars in utf8 - nil|0|1|2
   t.integer :tabs
=end

  counters = {
     encoding:         Hash.new(0),
     encoding_source:  {},
     encoding_valid:   Hash.new(0),

     ascii7bit:        Hash.new(0),
     chars_8bit:       Hash.new(0),
     utf8_replace:     Hash.new(0),
     tabs:             Hash.new(0),
  }


  ## note - use COLLATE NOCASE ASC - for case-insensitive ordering
  MirrorDb::Model::Page.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each_with_index do |page,i|

=begin
 t.string  :encoding           ## "upstream" text encoding
                                 ##   all pages ALWAYS converted to utf-8
   t.string  :encoding_source   ## e.g. bom|http|html|user|fallback

   t.boolean :encoding_valid  ## uses  String#encoding_valid?
   t.boolean :ascii7bit       ## uses  String#ascii_only?  check if all chars are ascii 7bit (utf8-compatible) ??
   t.integer :chars_8bit       ## count of 8bit (126-255) chars - nil|0|1|2|etc.
   t.integer :utf8_replace     ## count invalid/replace chars in utf8 - nil|0|1|2
   t.integer :tabs
=end

     next   if page.http_status == 404


     if page.extname == '.html' || page.extname == '.htm'

        counters[:encoding][ page.encoding ] += 1
        counters[:encoding_valid][ page.encoding_valid ] += 1

        ## note - record source by encoding
        encoding_source = counters[:encoding_source][page.encoding_source] ||= Hash.new(0)
        encoding_source[ page.encoding ] += 1

        counters[:ascii7bit][ page.ascii7bit ] += 1

        ## integer numbers (char count or nil)
        ##   put in bins (100,200, etc.?) - why? why not?
        counters[:chars_8bit][ page.chars_8bit ?
                                  (page.chars_8bit/1000+1).to_s+"000s" : nil
                                  ] += 1
        counters[:tabs][ page.tabs ?
                             (page.tabs/1000+1).to_s+"000s" : nil
                                  ] += 1
        counters[:utf8_replace][ page.utf8_replace ] += 1
     end


      print '.'  if i % 100 == 0
  end
  print "\n"

  counters
end



counters = build()
pp counters


puts "bye"


__END__

{:encoding=>
  {"windows-1252"=>39499,
   "utf-16le"=>1272,
   "iso-8859-2"=>618,
   "windows-1250"=>254,
   "utf-8"=>161,
   "windows-1251"=>23,
   "iso-8859-1"=>61,
   "windows-1254"=>5,
   "iso-8859-5"=>3,
   "iso-8859-9"=>1},
 :encoding_source=>
  {"user"=>{"windows-1252"=>37686},
   "html"=>
    {"windows-1252"=>1808,
     "iso-8859-2"=>618,
     "windows-1250"=>254,
     "windows-1251"=>23,
     "utf-8"=>8,
     "iso-8859-1"=>61,
     "windows-1254"=>5,
     "iso-8859-5"=>3,
     "utf-16le"=>1,
     "iso-8859-9"=>1},
   "bom"=>{"utf-16le"=>1271, "utf-8"=>153},
   "force"=>{"windows-1252"=>4},
   nil=>{"windows-1252"=>1}},
 :encoding_valid=>{true=>41896, nil=>1},
 :utf8_replace=>{nil=>41872, 1=>10, 8=>2, 2=>5, 6=>2, 4=>3, 55=>1, 33=>1, 5=>1},
 :ascii7bit=>{false=>26824, true=>15072, nil=>1},

 ## use <100, <1000, <10_000s, <100_000 - why? why not?
 :chars_8bit=>
  {"1000s"=>24975,
   nil=>16499,
   "2000s"=>275,
   "16000s"=>1,
   "8000s"=>7,
   "3000s"=>49,
   "9000s"=>8,
   "5000s"=>12,
   "17000s"=>3,
   "19000s"=>1,
   "4000s"=>17,
   "7000s"=>8,
   "10000s"=>2,
   "11000s"=>3,
   "12000s"=>2,
   "21000s"=>1,
   "26000s"=>1,
   "15000s"=>2,
   "14000s"=>2,
   "25000s"=>2,
   "92000s"=>1,
   "99000s"=>1,
   "38000s"=>1,
   "101000s"=>1,
   "63000s"=>1,
   "33000s"=>1,
   "74000s"=>1,
   "106000s"=>1,
   "46000s"=>1,
   "42000s"=>1,
   "65000s"=>1,
   "49000s"=>1,
   "70000s"=>1,
   "40000s"=>1,
   "97000s"=>1,
   "166000s"=>1,
   "60000s"=>1,
   "28000s"=>1,
   "112000s"=>1,
   "75000s"=>1,
   "52000s"=>1,
   "6000s"=>6},
 :tabs=>
  {nil=>29902,
   "1000s"=>11129,
   "2000s"=>564,
   "3000s"=>164,
   "12000s"=>3,
   "4000s"=>58,
   "15000s"=>3,
   "11000s"=>7,
   "6000s"=>13,
   "5000s"=>22,
   "26000s"=>1,
   "24000s"=>1,
   "18000s"=>1,
   "17000s"=>2,
   "20000s"=>1,
   "7000s"=>7,
   "19000s"=>2,
   "34000s"=>1,
   "10000s"=>4,
   "21000s"=>1,
   "9000s"=>1,
   "25000s"=>1,
   "8000s"=>4,
   "14000s"=>2,
   "28000s"=>1,
   "16000s"=>1,
   "13000s"=>1}}