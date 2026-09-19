

def build_index( site, outdir: )


   site.each_dir do |dirname, pages|


    subdirs = site.collect_subdirs( dirname )
     buf = String.new


     title   =  "#{dirname}"
     title  += " - #{pages.size} page(s)"
     title  += ", #{subdirs.size} subdir(s)"   if subdirs.size > 0


     ## header with title
     buf  += "<h1>#{title}</h1>\n"


     ## subdir section
     ## note - use unicode open folder e.g. 📂
     ##    or maybe closed folder?
     folder = "\u{1F4C2}"

     if subdirs.size > 0
        buf  += "<h2>"
        buf  += "#{subdirs.size} subdir(s) in #{dirname}"
        buf  += "</h2>\n"

        buf += "<div>"
        subdirs.each do |subdir|
            parentdir =   dirname == '/' ? dirname : dirname + '/'
            reldir = subdir.sub( parentdir, '' )

          buf += "  <a href=\"#{reldir}\">#{folder}#{reldir}</a>     -- #{site.dirs[subdir].size} page(s)"
          buf += "<br>"
          buf += "\n"
        end
        buf += "</div>\n"
     end


     ## pages section
     buf  += "<h2>"
     buf  += "#{pages.size} page(s) in #{dirname}"
     buf  += "</h2>\n"


=begin
     buf += "<div>"
     pages.each_with_index do |page,i|
        buf +=  %Q{<span title="#{page.links}/#{page.backlinks}">#{page.basename}</span>}
        buf += " "
        url = "https://rsssf.org" + page.path
        buf +=  %Q{<a href="#{url}">#{page.title}</a>}
        buf += "<br>\n"
     end
     buf << "\n</div>\n"
=end

    ### try a table style
     buf += "<div>\n"
     buf += %q{<table style="width:100%">}
     buf +="\n"

     pages.each_with_index do |page,i|
        buf += "<tr>"
        buf += "<td><code>#{page.basename}</code></td>"
        ## maybe use smaller font here - why? why not?
        buf += "<td>#{page.links}/#{page.backlinks}</td>"
        buf += "<td>"
             url = "https://rsssf.org" + page.path
        buf +=  %Q{<a href="#{url}">#{page.title}</a>}
        buf += "</td>"
        buf += "</tr>\n"
     end
     buf << "\n</table>\n"
     buf << "</div>\n"


     ##  note - check for "/" and avoid
     ##   ./tmp-index//index.html   (instead of ./tmp-index/index.html)
     outpath =  "#{outdir}"
     outpath += "#{dirname}"   unless dirname == '/'
     outpath += "/index.html"


     puts buf

     puts "writing to <#{outpath}>..."

      body = buf
      banner = build_banner( site: site )

     html = build_layout( site: site,
                          title: title,
                          body: body,
                          banner: banner )

     write_text( outpath, html )
   end


end
