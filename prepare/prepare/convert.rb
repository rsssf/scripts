

=begin

todo - remove all "trailing" nav links in section

‹1974/75, see page oost75›.

‹1976/77, see page oost77›.

‹list of final tables, see page oosthist›.

‹list of champions, see page oostchamp›.

‹list of cup finals, see page oostcuphist›.

‹list of super cup finals, see page oostsupcuphist›.

‹list of foundation dates, see page oostfound›.
=end





TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm

def find_title( html )
  if m=TITLE_RE.match( html )
     text = m[:text].strip
     ## note - convert html entities
     ##  e.g. Brazil 2000 - Copa Jo&atilde;o Havelange
     text = Rsssf::PageConverter.convert_html_entities( text )
     text
  else
     nil
  end
end




def do_edits( txt )

  ### record edits in its own txt file  
  edits = String.new

###
##  step 1
##   split by horizontal rules (hrs)
##       and remove navigations sections
##             starting with links e.g.   
## ‹Bundesliga, see §bund›

   sects = txt.split( /^=-=-=-=-=-=-=-=-=-=-=-=-=-=-=$/ )

   
   sects = sects.select do |sect|
      nav = %r{\A
               [ \n]*    ## trailing spaces or blank lines 
                ‹.+?›    ##  link
             }ix.match(sect)
        
        if nav

            edit = String.new 
            edit += "-- removing nav(igation) section:"
            edit += sect

            puts edit

            ## record edit
            edits += edit
            edits += "\n"
        end     
      nav ? false : true
    end

   ## sects.each_with_index do |sect,i|
   ##  puts "==> #{i+1}/#{sects.size}"
   ##  pp sect
   ## end
   ##  puts "  #{sects.size} sect(s)"
 
   
   ## note - replace hr with blank line
   txt = sects.join( "\n\n" )


   ###
   ## remove pre comments
   txt = txt.gsub( "<!-- start pre -->\n", '' )
   txt = txt.gsub( "<!-- end pre -->\n", '' )


   ## note - return (new) txt AND recorded edits (& erratas)
   [txt, edits.empty? ? nil : edits]
end



def convert_pages( pages, outdir: )
  pages.each_with_index do |config,i|
    puts
    puts "==> [#{i+1}/#{pages.size}] converting #{config.pretty_inspect}..."

    page     = config['page']
    url      = "https://rsssf.org/#{page}"

    html     = Webcache.read( url )
  



    txt = Rsssf::PageConverter.convert( html, url: url )


    txt, edits = do_edits( txt )


    basename = File.basename( page, File.extname( page ))
    dirname  = File.dirname( page )


    title  =  find_title( html ) || 'n/a'
    ## note - title quick typo fix (in brazil) remove >
    title = title.gsub( '>', '' )


   header = <<EOS
  <!--
     title:  #{title}
     source: #{url}
    -->
  
EOS

     ## note - (auto-) add (comment) header to written out txt!!!
     write_text( "#{outdir}/#{dirname}/#{basename}.txt", header+txt )

     ## todo/check - delete edits file if no edits - why? why not?
     if edits
        write_text( "#{outdir}/#{dirname}/#{basename}.edits.txt", edits )
     end

  end
end
