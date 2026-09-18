###
#  to run use:
#
#   $ ruby mirrorx/querypage.rb


require_relative 'helper'


dbpath = ARGV[0] || './mirror.db'
MirrorDb.open( dbpath )


path = ARGV[1] || '/tablesf/franchamp.html'


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"




puts "==> #{path}:"
MirrorDb::Model::Page.where( 'path = ?', path ).each do |page|
   dump_page( page, links: true, backlinks: true )
end



puts "bye"
