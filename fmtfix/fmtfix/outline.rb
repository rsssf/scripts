

     ##
     ## note - ascii hr replacement is
     ##            =-=-= (do NOT match) !!!!!!


HX_RE = %r{^
                   [ ]* 
                     ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g. 
                     ##       Fall season
                     ##       ===========

                    (?!     =-= 
                         |  ={1,} [ ]* $
                     )  

                  (?<marker> ={1,6})   
                     [ ]*
                  (?<text> .+?)
                     [ ]*
            $}x


def build_outline( txt )

     hx =  txt.scan( HX_RE )
   

     counts = [nil,0,0,0,0,0,0]  ## note - index 0 is nil
                                 ##  index 1 (h1) is 0 etc.

     hx.each { |marker,_| counts[ marker.size ] +=1 }


     buf = String.new
     buf += "  outline:"
     buf += " " +
          "#{counts[1]==0 ? '-' : 'h1'}/" +
          "#{counts[2]==0 ? '-' : 'h2'}/" +
          "#{counts[3]==0 ? '-' : 'h3'}/" +
          "#{counts[4]==0 ? '-' : 'h4'}/" +
          "#{counts[5]==0 ? '-' : 'h5'}/" +
          "#{counts[6]==0 ? '-' : 'h6'}" +
          "\n"

         buf += "           " +
              "#{counts[1]==0 ? '-' : counts[1]}/" +
               "#{counts[2]==0 ? '-' : counts[2]}/" +
               "#{counts[3]==0 ? '-' : counts[3]}/" +
               "#{counts[4]==0 ? '-' : counts[4]}/" +
               "#{counts[5]==0 ? '-' : counts[5]}/" +
               "#{counts[6]==0 ? '-' : counts[6]}" +
               "\n"
      
     hx.each do |marker,text|
        buf << "    (%d) %-6s" % [marker.size, marker]
        buf <<  "  "
        buf << text
        buf << "\n"
     end


     ## count anchors (aka a name)
     ##  e.g 
       aname = txt.scan( /‹§  [^›]+  ›/x )
     
        if aname.size > 0
          buf << "\n"
          buf << "  aname #{aname.size}: "
          buf <<  aname.join( ',' )
          buf << "\n"
        end

        buf
end


