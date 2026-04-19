

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

