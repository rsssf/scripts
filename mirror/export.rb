

#
## fix
##  /USAdave/alpf.html,1/1,American League of Professional Football
## /USAdave/am-soc-overview-wom.html,1/1,USA - An Overview of American Women's Soccer History
## /USAdave/am-soc-overview.html,2/1,USA - An Overview of American Soccer History
## /USAdave/apsl.html,1/3,USA - A-League (American Professional Soccer League)
## /USAdave/asli.html,2/2,American Soccer League I
## /USAdave/aslii.html,2/4,USA - American Soccer League II

##
##  cache hit on /USAdave !!!
##    check for casesensitive check on windows!!!!!!
##

=begin
add  (2).hml to errata
/tablesv/vasco-trip49.hml,-/1,
/tablesv/vascodagama-mextour49.hml,-/1,


## yes, allow/add .htm  for page !!

/ec/Armenia.htm,-/1,
/ec/Azerbaijan.htm,-/1,
/ec/Belarus.htm,-/1,
/ec/Belgium.htm,-/1,
/ec/Bosnia.htm,-/1,
=end



###
#  to run use:
#
#   $ ruby mirror/export.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



def build_html
  rows = []
  MirrorDb::Model::Page.order( 'path' ).each_with_index do |page,i|

     ## skip 404 pages
     next if page.http_status == 404

     ## skip if not .html
     next if page.extname != '.html'


     rows << [page.path,
              "#{page.linked_pages.count}/#{page.backlink_pages.count}",
              page.title ? page.title : '-'
             ]

      print "." if i % 100 == 0
  end
  print "\n"

  rows
end

def build_html_404
  rows = []
  MirrorDb::Model::Page.where( extname: '.html',
                               http_status: 404 ).order( 'path' ).each do |page|

     rows << [page.path,
              "-/#{page.backlink_pages.count}",
              ''
             ]
  end
  rows
end

def build_pdf
  rows = []
  MirrorDb::Model::Page.where( extname: '.pdf' ).order( 'path' ).each do |page|

     rows << [page.path,
              "-/#{page.backlink_pages.count}",
              ''
             ]
  end
  rows
end


def build_other
  rows = []
  MirrorDb::Model::Page.order( 'extname', 'path' ).each_with_index do |page,i|

     next if page.http_status == 404  ||
             page.extname == '.html' ||
             page.extname == '.pdf'

     rows << [page.path,
              "-/#{page.backlink_pages.count}",
              ''
             ]

      print "." if i % 100 == 0
  end
  print "\n"

  rows
end




headers = ['path', 'links', 'title' ]


## write_csv( "./tmp-mirror/pages_html.csv", build_html(), headers: headers )
## write_csv( "./tmp-mirror/pages_html_404.csv", build_html_404(), headers: headers )
## write_csv( "./tmp-mirror/pages_pdf.csv", build_pdf(), headers: headers )
write_csv( "./tmp-mirror/pages_other.csv", build_other(), headers: headers )



puts "bye"
