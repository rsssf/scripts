
###
 ##  remove trailing about document meta backmatter
 ##  == About this document  ‹§about›
 ## 


ABOUT_RE = %r{  ^
                  [ ]*
                  == [ ] About [ ] this [ ] document
                   .*
              }ixm


 def handle_about( txt )
  
    txt = txt.sub( ABOUT_RE ) do |match|                     
                ## remove hr - why? why not?
                    "<!-- $about$ -->\n\n"
                 end
  
    txt
 end