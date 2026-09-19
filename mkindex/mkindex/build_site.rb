
##
# build a site (page) index
#


class SiteIndex


def self.build( files, dir:,
                       basepath: '/mirror' )
   idx = self.new( dir:      dir,
                   basepath: basepath )
   idx.add( files )
   idx
end


## use basedir (or rootdir) - why? why not?
attr_reader :dir

## used for generation (path part of baseurl e.g. /mirror for
##                                       rsssf.github.io/mirror)
attr_reader :basepath



attr_reader :dirs



def initialize( dir:, basepath: )
    @dir = dir
    @dirs  = {}  ## indexed by dirname (as key)

    @basepath = basepath
end




class Page
    ## maybe later -  read meta (title) on demand only
    attr_reader :site, :path, :dirname, :basename

    attr_reader :title, :links, :backlinks


##  page.linked_pages.count       => links
##   page.backlink_pages.count   => backlinks

    def initialize( site:,
                    path:,
                    title: nil,
                    links: nil,
                    backlinks: nil
                  )
        @site = site    # link to (parent) site

        @path = path

        ## use dirname as key
        dirname = File.dirname( path )
        extname = File.extname( path )
        basename = File.basename( path, extname )

        @dirname  = dirname
        @basename = basename


        @title   = title

        @links = links
        @backlinks = backlinks
    end

 end # (nested) class Page





def add( files )

   files.each_with_index do |file,i|

      ## note - filepath carries NO information/ignore
      ##           all path info inside datafiles
      recs = read_csv( file )
      puts "\n==> #{recs.size} page(s) in #{file}..."

      recs.each_with_index do |rec,i|
        path = rec['path']

        ## use dirname as key
        dirname = File.dirname( path )
        extname = File.extname( path )
        basename = File.basename( path, extname )


        ##
        ##  note -  dash (-) is used for n/a
        ##          question mark (?) is used for unknown
        title = rec['title']

        ## e.g. 12/3   -  links / backlinks
        links, backlinks  =  rec['links'].split( '/' , 2 ).map { |str| str.to_i }

        pages = @dirs[ dirname ] ||= []
        page = Page.new( site: self,
                         path:   path,
                         title:   title,
                         links:   links,
                         backlinks: backlinks )
        pages << page

        print "."   if i % 10 == 0
      end
    end
   print "\n"
end




def collect_subdirs( parentdir )
   ## get all subdirs for a dirname

   reldir =  parentdir == '/'  ?  parentdir
                               :  parentdir + '/'


   subdirs = []
   @dirs.each do |dirname, pages|
       next if dirname == parentdir

       subdirs << dirname    if dirname.start_with?( reldir )
   end
   subdirs
end


def each_dir( &block )
    ##  note - sort by basename/slug (as key) - why? why not?
    ##  check if sort

    @dirs.each do |dirname, pages|
        block.call( dirname, pages )
    end
end


=begin
def each_page_with_index( &block )

    ##  note - sort by basename/slug (as key) - why? why not?
    @pages.keys.sort.each_with_index do |key,i|
        block.call( @pages[key], i )
    end
end
def pages()  @pages.values; end
def size()   @pages.size; end

def has_page?( basename )   @pages.has_key?( basename ); end

=end



end  # class SiteIndex