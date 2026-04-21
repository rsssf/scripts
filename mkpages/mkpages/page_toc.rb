
=begin
-- use  for toc???
  position: fixed;
  top: 10px;
  right: 10px;

style = String.new
style += <<CSS
#toc {
  float: right;
  width: 300px;  
  z-index: 9999;
  padding: 7px;
  border: 1px solid #AAA;
  background-color: #F9F9F9;
}
CSS

=end




def build_toc( txt, min: 2 )

     hx =  txt.scan( HX_RE )
    
##
##  note - toc (table-of-contents)
##           is its own pre block

     ## require a min of 2 headings
     if hx.size >= 2

       buf = String.new
       buf += "<pre>\n"
       buf += "  Table of contents:\n\n"

       hx.each do |marker,text,ref|
          ## indent text by marker size (multiply by 2 - e.g. use 2x??)
          ## buf << "    %-6s %s" % [marker, ' '*marker.size]
 
          one = String.new
          one << " %s" % [' '*(marker.size*2)]
          one <<  "  "
          one << text
          buf << "%-42s" % one

          ## align see references (kind-of like page numbers)
          buf << "  (see <a href=\"\##{ref}\">§#{ref}</a>)"    if ref
          buf << "\n"
       end
      
       buf += "</pre>\n"
       buf
     else
       nil   # no table-of-contents; no min required headings hit/found
     end
end




