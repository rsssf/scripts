
###
#  to run use:
#
#   $ ruby mirror/query.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



puts "==> missing - 404 not found:"
MirrorDb::Model::Page.order( 'path' ).where( http_status: 404 ).each do |page|
   dump_page( page, backlinks: true )
end


##
##  todo - filter  by  .pdf, .xlsx (excel), .jpg (images),  and rest


puts "==> not .html:"
MirrorDb::Model::Page.order( 'path' ).where( 'extname != ?', '.html' ).each do |page|
   dump_page( page, backlinks: true )
end


##
## check if tables left to download ?
tables_count = MirrorDb::Model::Page.where( cached: false ).
                                         where( 'path LIKE ?', '/table%' ).count

puts "  #{tables_count} /tables page(s) to download"




puts "bye"
