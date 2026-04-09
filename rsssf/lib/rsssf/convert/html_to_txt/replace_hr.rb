module Rsssf
class PageConverter




HR_LINE_ASCII = "\n\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n\n"

def replace_hr( html )

  html = html.gsub( /\s*<HR>\s*/im ) do |match|
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace horizontal rule (hr) - >#{match}<"
    HR_LINE_ASCII    ## check what hr to use use  - . - . - or =-=-=-= or somehting distinct?
  end
 
  html
end

end # module PageConverter
end # module Rsssf




