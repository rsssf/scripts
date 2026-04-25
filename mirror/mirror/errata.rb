

##
##  use errata_html - why? why not?

def errata( html, url: )

     base_url = URI( url )

       if base_url.path == '/results-afr.html'
            ## add missing closing quote
           html = html.sub( %q{<A HREF="tablesm/mauri2023.html#aga>},
                            %q{<A HREF="tablesm/mauri2023.html#aga">}  )

           html = html.sub( %q{<A HREF=" tablesr rodri2025.html#super">},
                            %q{<A HREF="tablesr/rodri2025.html#super">} )
       end

       if base_url.path == '/profiles.html'
           html = html.sub( %q{<A HREF=http://www.daleucampeon.4t.com">},
                            %q{<A HREF="http://www.daleucampeon.4t.com">} )
       end


       html
end