
## use recursive_download_page or such - why? why not?
##   or add recursive flag



=begin
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
=end



def mirror_page( start_page, force:  false )
    queue    = {}   ## queue with pages to process
    visited  = Hash.new(0)   ## only track ref/usage counts

    externals = Hash.new(0)   ## only track ref/usage counts

    ## add to queue (indexed by page path (e.g. /curtour.html etc.))
    queue[ start_page.path ] = start_page



    loop do
       break if queue.empty?


       ## prefer pages
       ##  starting with /tables,/tables[a-z]/

       path =  queue.keys.find do |key|
                              %{\A/tables[a-z]?/}.match?(key)
                        end

       path =  queue.keys[0]    if path.nil?

       page = queue.delete( path )


       if visited.size % 100 == 0
          puts "\n  visited: #{visited.size},  queue: #{queue.size}"
       end


       ## mark as visited at the end or here in the beginning - why? why not?
       visited[ page.path ] += 1


       ### check if in db
       page_rec = MirrorDb::Model::Page.find_by( path: page.path )



       if page_rec.cached?
          ## note - "fast track" processing if page record with links in db

          internals = page_rec.outgoing_paths

           internals.each do |path|
              if visited.key?( path ) ## already visited (& downloaded)
                  visited[path] += 1  ##    up count
              else
                 if queue.key?( path )  ## check if already in queue
                     ## do nothing
                 else
                    next if PAGES_404.include?( path )

                    queue[path] = Page.new( path: path )
                 end
              end
            end

         print "."
         next
      end



       ## "slow" mode with cache hit or download
       ##          and db entry creations

       html, cached  = _download_page( page.url,
                                   encoding: page.encoding,
                                   force: force )

       ## turn on verbose mode only if page downloaded (not on cache hit)
       verbose = cached ? false : true
       ## verbose = true

           ## add to db
           internals, more_externals = _find_links( html,
                                                   url: page.url,
                                                   verbose: verbose
                                                   )

           if page_rec.nil?
              puts "  add page #{page.path} (cached: true) to mirror.db"
              page_rec = MirrorDb::Model::Page.create( path:    page.path,
                                                      encoding: page.encoding,
                                                      cached: true )
           else
              puts "  update page #{page.path} (cached: true) to mirror.db"
              ###  assert outgoing links are zero  - why? why not?
              page_rec.update!( cached: true )
           end

            ## add links to db
            internals.each do |path|
               internal     = Page.new( path: path )
               internal_rec = MirrorDb::Model::Page.find_by( path: internal.path )

               if internal_rec.nil?
                  ## note - set cached to false (meaning outgoing links not known)
                  puts "  add outgoing page #{internal.path} (cached: false) to mirror.db"
                  internal_rec = MirrorDb::Model::Page.create( path: internal.path,
                                                      encoding: internal.encoding,
                                                      cached: false )
               end

               ## puts "  add link from #{page_rec.path} to #{internal_rec.path} to mirror.db"
               MirrorDb::Model::Link.create( from_page_id: page_rec.id,
                                             to_page_id: internal_rec.id )
            end


       more_pages = 0
       internals.each do |path|

              if visited.key?( path )   ## already visited (downloaded)
                  visited[path] += 1   ##   add up count
             else
                 if queue.key?( path )  ## already in queue
                     ## add up count ??
                 else
##
##  skip known 404 pages e.g.
##   !! HTTP ERROR - 404 Not Found:
##  GET https://rsssf.org/tablesn/nedantcup09.html...
##  GET https://rsssf.org/tablesz/zimb2022.html...
 https://rsssf.org/tablesn/nedantcup09.html.
                    next if PAGES_404.include?( path )

                    queue[path] = Page.new( path: path )
                    more_pages +=1
                    puts "  adding new page #{path}"  if verbose
                 end
              end
       end

       if verbose && more_pages > 0
         puts "  added #{more_pages} new page(s) in #{page.path} to queue - #{queue.size} page(s) waiting"
       end


       more_externals.each do |link|
                       externals[link] += 1
                    end


    end


      puts "  #{visited.size} internal page(s) processed:"
      pp visited

      puts "  #{externals.size} external link(s) found:"
      pp externals

end
