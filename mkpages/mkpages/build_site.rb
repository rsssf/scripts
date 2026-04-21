

##
# build a site (page) index 
#    



class SiteIndex


def self.build( files, dir: )
   idx = self.new( dir: dir )
   idx.add( files )
   idx
end



## use basedir - why? why not?
attr_reader :dir

def initialize( dir: )
    @dir = dir
    @pages = {}  ## indexed by basename/slug (as key)
end



class Page
    ## maybe later -  read meta (title) on demand only
    attr_reader :dirname, :basename, :title

    def initialize( site:, dirname:, basename: )
        @site = site    # link to (parent) site
        
        @dirname  = dirname
        @basename = basename
        @title    = nil

        _read_meta()
    end

    ## relative path 
    ##   note - will NOT include dirname!!!!
    ##    make add an option later - why? why not?
    ## - keep - why? why not?
    def txt_path()   "#{basename}.txt"; end
    def html_path()  "#{basename}.html"; end    


    def _read_text
        txt = read_text( "#{@site.dir}/#{dirname}/#{basename}.txt" )
        ## check windows files on unix  -- remove \r - carriage return (cr)
        ##  clean-up windows-style newlines - why? why not?
        txt = txt.gsub( "\r\n", "\n" )
        txt
    end
    
    def txt()  _read_text(); end
    alias_method :text, :txt


    def first  ## or use letter - used for building an a-z index
      first = @basename[0].downcase
      ## use underscore (_) for numerics / numbers
      first = '_'   if  %w[0 1 2 3 4 5 6 7 8 9].include?(first)
      first
    end



    def _read_meta

      ##
      ## todo/fix:
      ##   get more meta data from page comment header
      ##    use a  \A [ \n]* rule
      ## 
      ##    from source file comment
      ##  <!--  title:  -->
      ##  for now get from page cache in html!!!
      ##     

       txt = _read_text()

       ## note - title nil if not present (n/a)
       @title  = find_title_in_comment( txt ) || 'n/a' 
    end
end # (nested) class Page 



def add( files )

   files.each_with_index do |file,i|

      ## use basename as key
      dirname = File.dirname( file )
      extname = File.extname( file )
      basename = File.basename( file, extname )

      page = @pages[ basename ]
      if page
         raise ArgumentError, "page slug #{basename} (#{file}) already in use - #{page.pretty_inspect}; cannot add duplicate; sorry"
      end

      print "."
      page = @pages[ basename ] = Page.new( site: self,
                                            dirname:   dirname,
                                            basename:  basename ) 
   end
   print "\n"
end


def size() @pages.size; end

def each_page( &block )

    ##  note - sort by basename/slug (as key)
    @pages.keys.sort.each do |key|
        block.call( @pages[key] )
    end
end    
   

end  # class SiteIndex