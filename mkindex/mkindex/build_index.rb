

def build_index( site, outdir: )


   site.each_dir do |dirname, pages|


    subdirs = site.collect_subdirs( dirname )
     buf = String.new
     buf  = "#{pages.size} page(s)"
     buf  += " & #{subdirs.size} subdir(s)"   if subdirs.size > 0
     buf  += " in #{dirname}\n\n"

     if subdirs.size > 0
        subdirs.each do |subdir|
            parentdir =   dirname == '/' ? dirname : dirname + '/'
            reldir = subdir.sub( parentdir, '' )
          buf += "   #{reldir}      -- #{site.dirs[subdir].size} page(s)\n"
        end
        buf += "\n"

     end


     pages.each_with_index do |page,i|
        buf <<  page.basename  + "   "
        buf <<  "\n"   if (i+1) % 12 == 0
     end
     buf << "\n"


     ##  note - check for "/" and avoid
     ##   ./tmp-index//index.html   (instead of ./tmp-index/index.html)
     outpath =  "#{outdir}"
     outpath += "#{dirname}"   unless dirname == '/'
     outpath += "/index.html"


     puts buf

     puts "writing to <#{outpath}>..."

     write_text( outpath, buf )
   end


end
