
###
#  to run use:
#
#   $ ruby mirror/list.rb


require_relative 'mirror'


MirrorDb.open


MirrorDb::Model::Page.order( 'path' ).each do |page|
   print "%-40s" % page.path
   print "   cached: #{page.cached?}"
   print "   %3d link(s)" % page.linked_pages.count
   print "   %3d backlink(s)" % page.backlink_pages.count
   print "\n"
end



puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.missing.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"

puts "bye"
