############
#  to run use:
#   $ ruby mkindex/mkindex.rb

##
###  generate index (mirror) web site
##      - requires pages.csv in /pages


require 'cocos'


require_relative 'mkindex/build_site'
require_relative 'mkindex/build_index'




 args = ARGV

 opts = {
   outdir:     './_site',
   rootdir:    '.',
  }



  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options]"

     parser.on( "--outdir DIR",
                 "output dir(ectory) for generated html pages (default: #{opts[:outdir]})" ) do |outdir|
       opts[:outdir] = outdir
     end
     parser.on( "--rootdir DIR",
                 "root (& working) dir(ectory) for collecting index pages (default: #{opts[:rootdir]})" ) do |rootdir|
       opts[:rootdir] = rootdir
     end
  end

  parser.parse!( args )


puts "OPTS:"
pp opts



## rootdir = '/sports/rsssf/mirror/pages'
## outdir = './tmp-index'
rootdir = opts[:rootdir]
outdir  = opts[:outdir]


files =  Dir.glob( "#{rootdir}/**/pages.csv" )
puts "  found #{files.size} datafile(s)"


site = SiteIndex.build( files, dir: rootdir)


build_index( site, outdir: outdir )


puts "bye"
