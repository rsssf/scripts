
####
#  to run use:
#    $ ruby sandbox/fmtfix.rb        
#
#  e.g.
#   ruby sandbox\fixfmt.rb oost2026.txt oost00.txt oost2020.txt oost2021.txt oost2022.txt
#   ruby sandbox\fixfmt.rb span2011.txt span2025.txt

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




PATH = [
   '../clubs/austria/tables',
   '../clubs/spain/tables',
]





ROUND_PAT = %q{
               Round [ ] \d{1,2}     ## e.g. round 1, round 2, etc.
             | (?: First | Second | Third | 1st | 2nd | 3rd) [ ] round 

             | (?: First | Second | 1st | 2nd) [ ] phase 
                         
             | 1/8 [ ] Finals  
             | Eightfinals 

             | Quarter [ -]? finals 
             | Semi [ -]? finals? 
             
             | Third [ ] place [ ] match 
             | Match [ ] for [ ] third [ ] place 

             | Final 
             | Final [ ] group | Final [ ] pool 
             | Deciding [ ] match

             ## add stages
             | Regular [ ] stage
             | Playoff [ ] stage 
             | Championship [ ] playoff
             | Relegation [ ] playoff
             | Europa [ ] league [ ] playoff 
             | Conference [ ] league [ ] playoff
             | Promotion/relegation [ ] playoff
             
             ## standalone legs
             | First [ ] leg 
             | Second [ ] leg
}        



DATE_PAT = %q{
                           (  Jan
                            | Feb
                            | March | Mar
                            | April | Apr 
                            | May
                            | June | Jun
                            | July | Jul
                            | Aug
                            | Sept | Sep
                            | Oct
                            | Nov
                            | Dec )
                             [ /]      
                            \d{1,2}                           
}


## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹ (?<ref> §[^›]+?) ›
            )?
         }



HEADER_ROUND_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
            #{OPT_REF}
         [ ]*
\z}ix

HEADER_DATE_RE = %r{\A
      [ ]*
      \[ (?<date> #{DATE_PAT}) \]
      [ ]*
\z}ix


## Round 24 [Mar 21]
HEADER_ROUND_N_DATE_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[ (?<date> #{DATE_PAT}) \]
        [ ]*
\z}ix


## Final [May 1, Klagenfurt]
HEADER_ROUND_N_DATE_N_CITY_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[ (?<date> #{DATE_PAT})
             , [ ]*
           (?<city> .+?)    
        \]
        [ ]*
\z}ix




##
## todo/fix
##  warn about date ranges  - not supported for now (maybe later)
##
##  e.g. ▪ Round 16 ▪  Feb 26, 27
##  Round 20 [Mar 24-26]
##    [Mar 4, 5]
##    [Mar 11, 12]
##  [around Mar 29]
##  [around Apr 19]
##  [Apr 1, 2]

##  date with cancelled status
## [Mar 31 - cancelled]
## [Apr 1 - cancelled]
## Semifinals [Apr 22 - cancelled]
## Final [May 21 - cancelled]
##  [tba - cancelled]




def autofix( txt )

  ###
  ## remove pre comments
  txt = txt.gsub( "<!-- start pre -->\n", '' )
  txt = txt.gsub( "<!-- end pre -->\n", '' )

 ###
 ##  remove trailing about document meta backmatter
 ##  == About this document  ‹§about›
 ## 
    txt = txt.sub( /^[ ]*== About this document.*/im, '' )




 
  #####
   ## line-by-line processing / matching

   newtxt = "" 
   txt.each_line do |line|  
        ## check if line incl. newline? - yes

      newtxt <<  if m = HEADER_ROUND_RE.match(line.rstrip)
                   ## use indent of six spaces
                   "▪ #{m[:round]} ▪\n" 
                 elsif m = HEADER_DATE_RE.match(line.rstrip)
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_ROUND_N_DATE_RE.match(line.strip)
                   "▪ #{m[:round]} ▪  #{m[:date]}\n"                   
                 elsif m = HEADER_ROUND_N_DATE_N_CITY_RE.match(line.strip)
                   "▪ #{m[:round]} ▪  #{m[:date]}, #{m[:city]}\n"                   
                 else
                   line 
                 end
   end
   
   txt = newtxt



  ###  [aet]  => (aet)
  txt = txt.gsub( '[aet]', '(aet)' )
  
   ## [aet, 2-3 pen] => (aet, 2-3 pen)
   ##  [aet, 9-10 pen]
   txt = txt.gsub( /\[(aet, \d{1,2}-\d{1,2} pen)\]/i, '(\1)') 


   ##   [15' Barisic, 80' Gilewicz; 10' (og) Barisic]
   ##  try (simple) goal line
   ##   note keep leading spaces / indent
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )

  ##  try (simple double) goal line
   ##   note keep leading spaces / indent
  ## [21' Dospel, 42' and 64' Mayrleb, 51' Datoru, 72' Sobczak; 25' and
  ## 90' B.Akwuegbu]
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                          \n
                          .*?
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )

###
###    [Fernando Llorente 47]
##   [Sebastián Fernández 44; Aritz Aduriz 9, Joaquín Sanchez 71, 75]
   ##  try (simple) goal line with number only!!!
   ##   note keep leading spaces / indent
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )


###  [Jose Manuel Jurado 12, Diego Forlán 40, 63,
##   "Simao" Pedro Fonseca 90]
##  [Rubén Suárez 10; Abdoulay Konko 12, 63, Alvaro Negredo 27,
##   "Renato" Dirnei Florencio 87]

   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )


##  ["Edmilson" Gomes de Moraes 40, Marco Perez 68,
##   Ander Herrera 82; Fernando Fernandez 1, 27,
##   Juan Miguel Jimenez "Juanmi" 6, 28, Quincy Owusu-abeyie 35]

txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )




  ###
  ## todo
  ##   fix subs in lineup  in oost00.txt
  # Salzburg: Safar - Szewczyk (97./Lipcsei) - Winklhofer, C.Jank - Laessig,
  #        Hütter (71./Meyssen) - Nikolic, Aufhauser, Kitzbichler - Struber,
  #        Polster (56./Sabitzer)



  txt
end



def fmtfix( args, 
             path: PATH, 
             outdir: './tmp' )
 
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


if __FILE__ == $0

  args = ARGV
  outdir = './tmp-fixfmt'

  fmtfix( args, outdir: outdir )
  puts "bye" 
end