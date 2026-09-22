############
#  to run use:
#
#    $ ruby corpus/corpus.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget-mirror/lib' )
require 'webget/mirror'

$LOAD_PATH.unshift( './rsssf/lib')
require 'rsssf'



Webcache.root = './cache'

MirrorDb.open( './mirror.db' )



def quick_edits( txt )
     #####################
     ## more (quick) edits

     ##
     ## note - remove images for now (assume rsssf logo)
     txt = txt.gsub( /<IMG[^<>]+>/i ) do |match|
        puts " remove image >#{match}<"
        ''
     end


     txt = txt.gsub( %r{    <menu>|</menu>
                          | <ul>  |</ul>
                        }ix ) do |match|
        puts " remove tag >#{match}<"
        ''
     end

     ## change <li> to - in beginning of line
     txt = txt.gsub( /^[ ]*<li>[ ]*/i, '  - ')

     txt
end


def convert_page( path, outdir: )

    url      = "https://rsssf.org" + path
    basename = File.basename( path, File.extname( path ))
    dirname  = File.dirname( path )

    outpath  = "#{outdir}/#{dirname}/#{basename}.txt"

    ## note - do NOT overwrite for now
    return if File.file?( outpath )


    html     = Webcache.read( url )

    edits = []

    txt, more_edits = Rsssf::PageConverter.convert( html, url: url )
    edits += more_edits

    txt = quick_edits( txt )




     ## note - (auto-) add (comment) header to written out txt!!!
     write_text( outpath, txt )

=begin
     ## todo/check - delete edits file if no edits - why? why not?
     if edits.size > 0
        write_text( "#{outdir}/#{dirname}/#{basename}.edits.txt", edits.join("\n") )
     end
=end
end





outdir = '/sports/rsssf/corpus'

 ## note - use COLLATE NOCASE ASC - for case-insensitive ordering
MirrorDb::Model::Page.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each_with_index do |page,i|

     next   if page.http_status == 404

     if page.extname == '.html' || page.extname == '.htm'
          puts "==> #{i+1} >#{page.path}< ..."
          convert_page( page.path, outdir: outdir )
     end

     ## break if i >= 1000
end


puts "bye"