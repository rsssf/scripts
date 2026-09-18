###
#  to run use:
#
#   $ ruby mirrorx/queryfix.rb


require_relative 'helper'


dbpath = ARGV[0] || './mirror.db'
MirrorDb.open( dbpath )



puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"


###
###  /index.html
##   linked_pages.count == 1  && linked_pages[0].path == '/index.html'

=begin
Page.joins(:linked_pages)
    .group('pages.id')
    .having('COUNT(linked_pages.id) = 1')
=end

## MirrorDb::Model::Page.joins( 'linked_pages' ).where( 'linked_pages.count = 1').each do |page|


## MirrorDb::Model::Page.joins(:links)
##     .group('pages.id')
##     .having('COUNT(linked_pages.id) = 1').each do |page|

MirrorDb::Model::Page.joins(:outgoing_links)
                        .group('pages.id')
                        .having( 'COUNT(links.from_page_id)=1').each do |page|

      if page.outgoing_paths == ['/index.html']
           page.cached = false
           page.save!
           page.outgoing_links.delete_all
           print "."
      else
           ## ignore others e.g. ['/nersssf.html']
            dump_page( page, links: true  , backlinks: false )
      end
end

puts "bye"
