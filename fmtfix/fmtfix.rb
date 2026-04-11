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


require_relative 'fmtfix/base'
require_relative 'fmtfix/topscorers'
require_relative 'fmtfix/tables'
require_relative 'fmtfix/about'




def fmtfix( args,
             path: ['.'], 
             outdir: './tmp' 
              )
 
   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )

      dirname  = File.dirname( filename )
      basename = File.basename( filename, File.extname( filename ) )
      extname  = File.extname( filename )

      ## change outfile  - add .autofix
      outfile = File.join(  outdir, "#{basename}#{extname}" )
      

      newtxt = autofix( txt )

      write_text( outfile, newtxt )
   end
end




PATH = [
   '../clubs/austria/tables',
   '../clubs/spain/tables',
   '../clubs/germany/tables',
   '../clubs/england/tables',
]

args = ARGV
outdir = './tmp-fmtfix'

fmtfix( args, 
        path: PATH,
        outdir: outdir )

puts "bye" 


