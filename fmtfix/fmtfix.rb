####
#  to run use:
#    $ ruby fmtfix/fmtfix.rb        
#
#  e.g.
#   ruby fmtfix\fmtfix.rb oost2026.txt oost00.txt oost2020.txt oost2021.txt oost2022.txt
#   ruby fmtfix\fmtfix.rb span2011.txt span2025.txt

## - try to autofix (convert) the formatting
##     to match the football.txt format


require 'cocos'



##
## note - use File.file? instead of File.exist? 
##            (checks if file exists AND file is a file NOT a directory)


def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?(  filepath )
    end

    puts "!! ERROR - file <#{name}> not found; looking in path: #{path.inspect}"
    exit 1
end


require_relative 'fmtfix/rounds'
require_relative 'fmtfix/dates'
require_relative 'fmtfix/headers'


require_relative 'fmtfix/base'
require_relative 'fmtfix/score'
require_relative 'fmtfix/topscorers'
require_relative 'fmtfix/tables'
require_relative 'fmtfix/about'



def fmtfix( filename, outdir: )
        txt = read_text( filename )

        dirname  = File.dirname( filename )
        basename = File.basename( filename, File.extname( filename ) )
        extname  = File.extname( filename )

        ## change outfile  - add .autofix
        outfile = File.join(  outdir, "#{basename}#{extname}" )
      
        newtxt = autofix( txt )

        write_text( outfile, newtxt )
end





def main( args,
             path: ['.'], 
             outdir: './tmp' 
              )
 
   args.each_with_index do |name,i|

      if File.extname(name).downcase == '.txt'  
        puts "==> #{i+1}/#{args.size} #{name}..."

        filename = find_file( name, path: path )

        fmtfix( filename, outdir: outdir )
      else
        ## use config
        ##  todo/fix - add a switch -c/--config or such
        ##     or better -f/--filename - why? why not?
        ##    and pass in    at.csv !!

         datafile = "./config/#{name}.csv"
         rows = read_csv( datafile )
         rows.each_with_index do |config,i|

            puts "==> #{i+1}/#{rows.size} #{config.pretty_inspect}..."

            page = config['page']
            dirname  = File.dirname( page )
            basename = File.basename( page, File.extname( page ) )
            extname  = File.extname( page )

            inname = "#{dirname}/#{basename}.txt"
            filename = find_file( inname, path: path )

            fmtfix( filename, outdir: outdir )
         end
      end
   end
end




PATH = [
   '../tables',
   '../tables/tableso',
   '../tables/tabless',
   '../tables/tablesd',
   '../tables/tablese',
]

args = ARGV

## outdir = '../clubs/germany/pages'
## outdir = '../clubs/england/pages'
## outdir = '../clubs/spain/pages'
## outdir = '../clubs/austria/pages'
outdir = './tmp-fmtfix'

main( args, 
        path: PATH,
        outdir: outdir )

puts "bye" 


