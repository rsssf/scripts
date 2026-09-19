
## pull in mirror machinery
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget-mirror/lib' )
require 'webget/mirror'

require_relative 'dump_page'



###
##  note allow "standard" built-in options e.g.
#         - dbpath   e.g.  ./mirror.db   etc.
#         - outpth   e.g.  ./tmp         etc.


OPTS = {
   outdir:     './tmp',
   dbpath:     './mirror.db',
}



  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options]"

     parser.on( "--outdir DIR",
                 "output dir(ectory) for generated html pages (default: #{OPTS[:outdir]})" ) do |outdir|
       OPTS[:outdir] = outdir
     end
     parser.on( "--dbpath PATH",
                 "sqlite file path (default: #{OPTS[:dbpath]})" ) do |dbpath|
       OPTS[:dbpath] = dbpath
     end
  end

  parser.parse!( ARGV )



puts "OPTS:"
pp OPTS

puts "ARGV (#{ARGV.size}):"
pp ARGV
