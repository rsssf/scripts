
###
#  to run use:
#
#   $ ruby mirror/fetch.rb


#
#  find a better name
#    use download/downloader or cachefill or cacheup
#       mirrorup or ???
##   or warmup / warm / prefill or ??


require_relative 'mirror'




## process page serial where cached is false

def process_page( page_rec )

       ## "slow" mode with cache hit or download
       ##          and db entry creations

       force   = false
       verbose = false

       html, cached  = _download_page( page_rec.url,
                                   encoding: page_rec.encoding,
                                   force: force )


           internals, _ = _find_links( html,
                              url: page_rec.url,
                              verbose: verbose
                           )


           ## add internal (outgoing page) links to db
            internals.each do |path|
               internal_rec = MirrorDb::Model::Page.find_or_create_by!( path: path ) do |rec|
                          ## note - set cached to false (meaning outgoing links not known)
                          puts "     add outgoing page #{rec.path} (cached: false) to mirror.db"
                          rec.encoding = 'windows-1252'
                          rec.cached   = false
                         end


               ## puts "  add link from #{page_rec.path} to #{internal_rec.path} to mirror.db"
               MirrorDb::Model::Link.create!( from_page: page_rec,
                                              to_page:   internal_rec )
            end

            puts "  update page #{page_rec.path} (cached: true) to mirror.db"
            ###  assert outgoing links are zero  - why? why not?
            page_rec.update!( cached: true )
end



def fmt_time_diff( time_start, time_end=Time.now, count:, step: nil )
   time_diff  = time_end - time_start
   buf = String.new

   buf +=  "  [#{step}/#{count} - %5.2f%%]" % [step*100/count]

   buf +=  "  %d:%02d mins" % [time_diff/60, time_diff%60]
   if step
     buf +=  " - %5.2f secs/page" % [time_diff/step]
     time_estimate = (time_diff/step) * count
     buf +=  ", estimate: %d:%02d mins" % [time_estimate/60, time_estimate%60]
   else
     buf +=  " - %5.2f secs/page" % [time_diff/count]
   end
   buf
end





## start off with pages not cached
MirrorDb.open

page_recs =  MirrorDb::Model::Page.where( cached: false ).limit( 1000 )


time_start = Time.now




page_recs.each_with_index do |page_rec,i|
    next if PAGES_404.include?( page_rec.path )


    process_page( page_rec )
    puts "  " + fmt_time_diff( time_start, step: i+1, count: page_recs.size )
end


puts "  total: " + fmt_time_diff( time_start, count: pages_recs.size )

puts "bye"
