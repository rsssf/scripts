
## use recursive_download_page or such - why? why not?
##   or add recursive flag





def mirror_page( start_path, force:  false )
    queue    = {}   ## queue with pages to process
    visited  = Hash.new(0)   ## only track ref/usage counts

    ## add to queue (indexed by page path (e.g. /curtour.html etc.))

    depth = 1

    queue[ start_path ] = depth



    loop do
       break if queue.empty?


       ## prefer pages
       ##  starting with /tables,/tables[a-z]/

       path =  queue.keys.find do |key|
                              %{\A/tables[a-z]?/}.match?(key)
                        end

       path =  queue.keys[0]    if path.nil?

       depth  =  queue.delete( path )


       if visited.size % 100 == 0
          puts "\n  visited: #{visited.size},  queue: #{queue.size}"
       end


       ## mark as visited at the end or here in the beginning - why? why not?
       visited[ path ] += 1


       ### check if in db
       page_rec = MirrorDb::Model::Page.find_or_create_by!( path: path ) do |rec|
                                      puts "  add page #{rec.path} (cached: false) to mirror.db"

                                      rec.encoding = PAGES_ENCODING[ rec.path ]
                                      rec.cached   = false
                                 end


      ## note - "fast track" processing if page record with links in db
       if page_rec.cached?

          internals = page_rec.outgoing_paths

           internals.each do |path|
              if visited.key?( path ) ## already visited (& downloaded)
                  visited[path] += 1  ##    up count
              else
                 if queue.key?( path )  ## check if already in queue
                     ## do nothing
                 else
                    next if PAGES_404.include?( path )

                    queue[path] = depth+1
                 end
              end
            end

         print "."
         next
      end



       ## "slow" mode with cache hit or download
       ##          and db entry creations

       html, cached  = _download_page( page_rec.url,
                                   encoding: page_rec.encoding,
                                   force: force )

       ## turn on verbose mode only if page downloaded (not on cache hit)
       verbose = cached ? false : true
       ## verbose = true

           ## add to db
           internals, _ = _find_links( html,
                                                   url: page_rec.url,
                                                   verbose: verbose
                                                   )


            ## add links to db
            internals.each do |path|
               internal_rec = MirrorDb::Model::Page.find_or_create_by( path: path ) do |rec|
                                    puts "  add outgoing page #{rec.path} (cached: false) to mirror.db"
                                    rec.encoding = PAGES_ENCODING[ rec.path ]
                                    rec.cached   = false
                                 end

               ## puts "  add link from #{page_rec.path} to #{internal_rec.path} to mirror.db"
               MirrorDb::Model::Link.create( from_page: page_rec,
                                             to_page:   internal_rec )
            end

            puts "  update page #{page_rec.path} (cached: true) to mirror.db"
            ###  assert outgoing links are zero  - why? why not?
              page_rec.update!( cached: true )


       more_pages = 0
       internals.each do |path|

              if visited.key?( path )   ## already visited (downloaded)
                  visited[path] += 1   ##   add up count
             else
                 if queue.key?( path )  ## already in queue
                     ## add up count ??
                 else
                    next if PAGES_404.include?( path )

                    queue[path] = depth+1
                    more_pages +=1
                    puts "  adding new page #{path}"  if verbose
                 end
              end
       end

       if verbose && more_pages > 0
         puts "  added #{more_pages} new page(s) in #{page_rec.path} to queue - #{queue.size} page(s) waiting"
       end
    end

    puts "  #{visited.size}  page(s) processed:"
    pp visited

end
