

###
#  to run use:
#
#   $ ruby mirror/report.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



###
## get directory html stats



def build_html

  ## directory (file) counters
  dirs = Hash.new(0)
  dirs['/'] = 0     ## note - make top-level (root) go first!!



  MirrorDb::Model::Page.order( 'path' ).each_with_index do |page,i|

     ## skip 404 pages
     next if page.http_status == 404

     ## skip if not .html
     next if page.extname != '.html'


     basename = File.basename( page.path, File.extname( page.path))
     extname  = File.extname( page.path )
     dirname  = File.dirname( page.path )

      dirs[dirname] += 1


      print "." if i % 100 == 0
  end
  print "\n"

  dirs
end



dirs = build_html
pp dirs

puts "bye"
