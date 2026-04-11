
##
## process Halfway/Final table: ... to first blank line (\n\n)

=begin

Final Table:

 1.FC Barcelona                  38 30  6  2  95-21  96  Champions
 2.Real Madrid CF                38 29  5  4 102-33  92
 3.Valencia CF                   38 21  8  9  64-44  71
 4.Villarreal CF                 38 18  8 12  54-44  62

-or-

Halfway Table:

 1.Atlético de Madrid            19  13  5  1  34-12  44
 2.Real Madrid CF                19  13  4  2  43-19  43  [C]
 3.FC Barcelona                  19  12  2  5  51-22  38
 4.Athletic de Bilbao            19  10  6  3  29-17  36

-or-

Fall Table

 1. 1. FC Köln                   15  8  4  3  41- 27  20
 2. Werder Bremen                15  8  4  3  28- 17  20
 3. TSV 1860 München             15  6  5  4  27- 19  17
 4. 1. FC Nürnberg               15  7  3  5  27- 22  17

=end


TABLE_RE = %r{^     [ ]* (?:Final|Fall|Halfway) [ ] table  
                           :?           ## note - optional colon
                         [ ]*
                          \n{1,2}       ## note - optional leading blank line!!

                        .*?             ## non-greedy - match everything until
                      (?:   \n (?= \n)    ## blank line (\n\n) or end-of-string/file
                          | \z
                      )
                    }ixm

                    
def handle_tables( txt, tables: [] )
   txt = txt.gsub( TABLE_RE ) do |match|
                 puts "  proc table block:"
                 puts match


                    ## remove everyting
                    ##  or put in comment block later with command line option/switch!! 
                    ##    ''
                        
                     ## replace with "collapsed" marker
                    tables << match
                    table_id = tables.size 
                    "<!-- $table#{table_id}$ -->\n\n"   
                  end
   txt
end


