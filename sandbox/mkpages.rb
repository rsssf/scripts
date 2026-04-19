############
#  to run use:
#   $ ruby sandbox/mkpages.rb 

##
###  generate web site
##      - web pages in .html from .txt


require_relative 'helper'




## use workdir or rootdir or such - why? why not?
def collect_datafiles( *globs, 
                        dir:, 
                        exclude_edits: true )
   ###
   ## note - auto-add  /**/*.txt to globs!!!

   files = []
   globs.each do |glob|
      Dir.chdir( dir) do 
        more_files =  Dir.glob( "#{glob}/**/*.txt" )

##
## auto-exclude/ignore
##      .edits.txt !!!
##   e.g. br2026.edits.txt and such
    if exclude_edits
        more_files = more_files.select do |file|
             if File.basename( file ).downcase.end_with?( '.edits.txt')
                 false
             else
                 true
             end
        end
   end
   
        puts "==> #{glob}/**/*.txt  (exclude_edits: #{exclude_edits})"
        puts "  #{more_files.size} file(s)"
        files += more_files
     end
   end
   files
end


## (i)  replace anchored names
##           ‹§pbengo
ANAME_RE = %r{‹§ (?<ref> [^›]+?) ›}ix

## (ii)   replace ref
##          see §pbengo›
SEE_ANAME_RE = %r{\bsee [ ] § (?<ref> [^›]+?) ›}ix

## (iii)  replace page links
##          see page 2006f›
##   see page ../tablesw/worldcup›
SEE_APAGE_RE = %r{\bsee [ ] page [ ] (?<page> [^›]+?) ›}ix



## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹§ (?<ref> [^›]+?) ›
            )?
         }


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
                     #{OPT_REF}
                     [ ]*
            $}x


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


HTML_COMMENT_RE = %r{<!-- 
                          [ \n]* 
                        (?<text> .+?) 
                         [ \n]* 
                   -->}imx

## note - allow no (empty) title? why? why not?                        
TITLE_PROP_RE = %r{ ^ [ ]* 
                        (?<key> title) 
                          [ ]*  :  [ ]* 
                        (?<value> .*?) 
                      [ ]*
                   $}ix


def find_title_in_comment( txt )
     comments = txt.scan( HTML_COMMENT_RE )
    
     ## assume first comment is "header" comments
     ##   note - match is an array of captures (even if only one capture) 
     comment = comments[0][0]
     if m = TITLE_PROP_RE.match( comment )
        m[:value]
     else
       nil
     end
end



def build_page( txt, file: )

    title = find_title_in_comment( txt ) || 'n/a'


   toc = build_toc( txt, min: 2 )

   ## remove html-style comments
   txt = txt.gsub( /<!-- .*? -->/ixm, '' )
   
   ## remove all leading spaces & newlines
   txt = txt.lstrip  

    ## remove newlines if more than double
    txt = txt.gsub( /\n{2,}/, "\n\n" )


   ## replace headings (h1/h2/h3/h4/h5/h6)
   txt = txt.gsub( HX_RE ) do |_|
                m = Regexp.last_match

                level = m[:marker].size

                if m[:ref]
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}  <a name=\"#{m[:ref]}\">§#{m[:ref]}</a></h#{level}>"
                else
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}</h#{level}>"
                end
             end

   txt = txt.gsub( ANAME_RE ) do |_|
                m = Regexp.last_match
                "<a name=\"#{m[:ref]}\">§#{m[:ref]}</a>"
             end

   txt = txt.gsub( SEE_ANAME_RE ) do |_|
                m = Regexp.last_match
                "see <a href=\"\##{m[:ref]}\">§#{m[:ref]}</a>"        
            end

   txt = txt.gsub( SEE_APAGE_RE ) do |_|
                m = Regexp.last_match
                "see page <a href=\"#{m[:page]}.html\">#{m[:page]}</a>"        
            end


  ## build table of contents (toc)


=begin
‹XLVIII Girabola, see §girabola›
‹Taça, see §taca›
‹Segundona, see §segundona›
‹Provincial Leagues, see §province›
=end

##
##  fix/fix//fix - must escape &

   buf = txt




   dirname   = File.dirname( file )
   basename  = File.basename( file, File.extname( file ))

rsssf_url  = "https://rsssf.org/#{dirname}/#{basename}.html"
github_url = "https://github.com/rsssf/tables/blob/master/#{dirname}/#{basename}.txt"


banner = String.new
banner += "<a href=\"#{rsssf_url}\">original @ rsssf.org</a>"
banner += " - "
banner += "<a href=\"#{github_url}\" title=\"yes, you can!\">view/edit this .txt page @ github</a>"

=begin
banner += " - "
banner += "<a href=\"\">football.txt version</a>"
banner += " ("
banner += "<a href=\"\">.json</a>"
banner += ", "
banner += "<a href=\"\">.log</a>"
banner += ")"
=end

banner += "\n"


=begin
-- use  for toc???
  position: fixed;
  top: 10px;
  right: 10px;
=end

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



body = String.new

if toc.empty?  
   ## do nothing
else
=begin   
   body   += "<div id=\"toc\">\n"
   body   += toc
   body   += "</div>\n"
=end

   body   += toc
   body   += "\n"

end

body   += buf

=begin
<style>
#{style}
</style>
=end

   page = String.new
   page += <<HTML
<!DOCTYPE html>   
<html>
<head>
   <title>#{title}</title>
</head>
<body>
<pre>
#{banner}
#{body}
</pre>
</body></html>
HTML

   page
end


def build_pages( files, dir: )
    files.each_with_index do |file,i|
      dirname   = File.dirname( file )
      basename  = File.basename( file, File.extname( file ))

      puts "==> [#{i+1}/#{files.size}] building page #{file}..."

      path = "#{dir}/#{file}"
      txt = read_text( path )
      html = build_page( txt, file: file )

      write_text( "./tmp-site/#{dirname}/#{basename}.html", html )
    end
end



### note - exclude 
###     braz2024.edits.txt.

root_dir = '../tables'
globs = ['tables', 'tables[a-z]']

files = collect_datafiles( *globs, dir: root_dir )
puts "  #{files.size} file(s)"
#=> 632 file(s)


test_files = [files[0], files[100], files[200], files[300]]
build_pages( test_files, dir: root_dir )



puts "bye"





