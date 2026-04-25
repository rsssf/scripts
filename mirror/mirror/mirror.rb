
## use recursive_download_page or such - why? why not?
##   or add recursive flag



##
##  use limit for batch - why? why not?
##     start of / try a batch of a hundred
def mirror_pages( force: false,
                  batch: 100 )

    visited = 0

    loop do
      ## todo - add
       ##       prefer pages
       ##  starting with /tables,/tables[a-z]/
       ##    - add to select

      page_recs =  MirrorDb::Model::Page.where( cached: false ).limit( batch )

      break   if visited == batch || page_recs.size == 0



       page_recs.each_with_index do |page_rec,i|

         ##  note - ignore known pages (404 not found)!!
         if PAGES_404.include?( page_rec.path )
            ## set cached to true to avoid infinite loop!!
            ##   keep in 404s in db - why? why not?
            page_rec.update!( cached: true )   if page_rec.not_cached?
            next
         end

         ## note - on download (not if cached)
         ##        encoding
         ##           might be get changed
         ##        ALWAYS use updated encoding!!

         html, response_meta  = _download_page( page_rec.url,
                                             encoding: page_rec.encoding,
                                            force: force )

         ##  if response meta data present than fresh download (not cached)
         cached  = response_meta ? false : true
         ## turn on verbose mode only if page downloaded (not on cache hit)
         verbose = cached ? false : true
         ## verbose = true

          html = errata( html, url: page_rec.url  )

         ## Standard HTML4-style parsing (default)
         ## doc = Nokogiri::HTML(malformed_html)
         ##  -or-
         ## More robust HTML5 parsing
         ##doc = Nokogiri::HTML5(malformed_html)

           doc = Nokogiri::HTML( html )

           ### try to find page title
           ##    not - title might be missing (nil)!!
             title_el =  doc.at_css('title')
             title =  title_el ? title_el.text.strip :  nil


           internals, _ = _find_links( doc,
                                       url: page_rec.url,
                                       verbose: verbose
                                     )


            ## add links to db
            internals.each do |path|
               internal_rec = MirrorDb::Model::Page.find_or_create_by!(
                                                            path: path ) do |rec|
                                    puts "     add linked page #{rec.path}"
                                    rec.encoding = PAGES_ENCODING[ rec.path ]
                                    rec.cached   = false
                                 end

               ## puts "  add link from #{page_rec.path} to #{internal_rec.path} to mirror.db"
               ###  note allow - find (may happen after "crash" or interrupt)
               link_rec = MirrorDb::Model::Link.find_or_create_by!(
                                                         from_page_id: page_rec.id,
                                                         to_page_id:   internal_rec.id )
            end

            puts "  [#{i+1}/#{page_recs.size}] update page #{page_rec.path} w/ #{internals.size} page(s) linked - >#{title || n/a}<"


            attribs = {
                cached: true
            }
            ## add (optional) title - might be missing in some pages
            attribs[ :title]     = title               if title

            ## check for encoding when fresh download (via response meta data)
            if response_meta
               encoding = response_meta[:encoding]

               attribs[ :encoding ] = encoding.downcase   if encoding
            end


            page_rec.update!( **attribs )



            visited += 1

           if visited % 100 == 0
              puts "\n visited: #{visited} - " +
                 " #{MirrorDb::Model::Page.count} page(s) indexed " +
                 "(#{MirrorDb::Model::Page.cached.count} cached, " +
                 "#{MirrorDb::Model::Page.not_cached.count} missing)"
           end
       end
    end

            puts "\n visited: #{visited} - " +
                 " #{MirrorDb::Model::Page.count} page(s) indexed " +
                 "(#{MirrorDb::Model::Page.cached.count} cached, " +
                 "#{MirrorDb::Model::Page.not_cached.count} missing)"
end
