
class Page

   attr_reader  :path, :encoding

   def initialize( path:, encoding: nil )
       @path     =  path
       @encoding =  encoding

## todo / double check fix read_csv upstream
##    if   empty column has comment it is "" empty string otherwise
##                it is nil!!!  ??
       @encoding = 'windows-1252'  if @encoding.nil? || @encoding.empty?
   end

   def url()  "#{BASE_URL}#{@path}"; end

end  # class Page



##
##      assert page_recs has no outgoing links yet records
               outgoing_links_count = page_rec.outgoing_links.count
            if outgoing_links_count > 0
                puts "!! WARN - page #{page_rec.path} has already #{outgoing_links_count} linked page(s); zero expected"
                pp page_rec.linked_pages
                exit 1
            end



## start off with pages not cached
page_recs =  MirrorDb::Model::Page.where( cached: false ).limit( 100 )

page_recs.each do |page_rec|
    next if PAGES_404.include?( page_rec.path )

    page = Page.new( path:     page_rec.path,
                      encoding: page_rec.encoding)


    mirror_page( page )
end
