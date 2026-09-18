

def build_index( site, outdir: )


   site.each_dir do |dirname, pages|


    subdirs = site.collect_subdirs( dirname )
     buf = String.new

     ## header with title
     buf << "<title>"
     buf  += "#{pages.size} page(s)"
     buf  += " & #{subdirs.size} subdir(s)"   if subdirs.size > 0
     buf  += " in #{dirname}"
     buf << "</title>\n"


     ## subdir section
     ## note - use unicode open folder e.g. 📂
     ##    or maybe closed folder?
     folder = "\u{1F4C2}"

     if subdirs.size > 0
        buf << "<div>"
        buf  += "#{subdirs.size} subdir(s) in #{dirname}:"
        buf  += "<br>"
        buf  += "\n"

        subdirs.each do |subdir|
            parentdir =   dirname == '/' ? dirname : dirname + '/'
            reldir = subdir.sub( parentdir, '' )

          buf += "  <a href=\"#{reldir}\">#{folder}#{reldir}</a>     -- #{site.dirs[subdir].size} page(s)"
          buf += "<br>"
          buf += "\n"
        end
        buf << "</div>\n"
     end


     ## pages section
     buf << "<div>"
     buf  += "#{pages.size} page(s) in #{dirname}:"
     buf  += "<br>"
     buf  += "\n"

     pages.each_with_index do |page,i|
        buf <<  page.basename  + "   "
        buf <<  "\n"   if (i+1) % 12 == 0
     end
     buf << "\n</div>\n"



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
