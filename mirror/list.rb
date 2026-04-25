
###
#  to run use:
#
#   $ ruby mirror/list.rb


require_relative 'mirror'


MirrorDb.open



MirrorDb::Model::Page.order( 'path' ).each do |page|
   print "%-38s" % page.path

   if page.cached?
      print " CACHED"
      print "  %3d" % page.linked_pages.count
   else
      print "       "
      print "     "
   end
   print " / %3d" % page.backlink_pages.count

   if page.encoding != 'windows-1252'
     print "  %-10s" % "(#{page.encoding})"
   else
     print "            "
   end

   print "  >#{page.title}<"   if page.title
   print "\n"
end



puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"

puts "bye"
