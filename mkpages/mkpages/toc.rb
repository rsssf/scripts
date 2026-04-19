


def build_toc( txt, min: 2 )

     hx =  txt.scan( HX_RE )
    
     buf = String.new

     ## require a min of 2 headings
     if hx.size >= 2

       buf += "  Table of contents:\n\n"

       hx.each do |marker,text,ref|
          ## indent text by marker size (multiply by 2 - e.g. use 2x??)
          ## buf << "    %-6s %s" % [marker, ' '*marker.size]
          buf << "   %s" % [' '*marker.size]
          buf <<  "  "
          buf << text
          buf << "  (see <a href=\"\##{ref}\">§#{ref}</a>)"    if ref
          buf << "\n"
       end
     end

    buf
end




