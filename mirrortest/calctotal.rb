
##
# calculate total pages count


## first mirror run (april 2026?)


text = <<TXT
/                         66 pages(s)
      /bvv                     221 pages(s)
      /colours                 220 pages(s)
      /ec                      230 pages(s)
      /engpaul/FLA             111 pages(s)
      /intldetails             214 pages(s)
      /miscellaneous          6053 pages(s)
      /nedfer                   27 pages(s)
      /players                1943 pages(s)
      /rssbest                 218 pages(s)
      /sacups                  345 pages(s)
      /tables                  580 pages(s)
      /tablesa                3053 pages(s)
      /tablesb                1887 pages(s)
      /tablesc                2333 pages(s)
      /tablesd                1174 pages(s)
      /tablesd/dfbcup            8 pages(s)
      /tablese                1407 pages(s)
      /tablesf                1092 pages(s)
      /tablesg                1378 pages(s)
      /tablesh                 633 pages(s)
      /tablesi                1556 pages(s)
      /tablesj                 516 pages(s)
      /tablesk                 951 pages(s)
      /tablesl                 841 pages(s)
      /tablesm                2206 pages(s)
      /tablesn                1645 pages(s)
      /tableso                 889 pages(s)
      /tablesp                1412 pages(s)
      /tablesq                  92 pages(s)
      /tablesr                 894 pages(s)
      /tabless                2988 pages(s)
      /tablest                1399 pages(s)
      /tablesu                 767 pages(s)
      /tablesv                 420 pages(s)
      /tablesw                 747 pages(s)
      /tablesx                  22 pages(s)
      /tablesy                  71 pages(s)
      /tablesz                 849 pages(s)
      /usadave                  56 pages(s)
      /wk94                     14 pages(s)

  160 page(s) - .html/.htm (not found)
   14 page(s) - .pdf
   93 page(s) - other
TXT


text2 =<<TXT
      /                         67 pages(s)
      /colours                   2 pages(s)
      /ec                       88 pages(s)
      /engpaul/FLA               1 pages(s)
      /intldetails               1 pages(s)
      /miscellaneous           646 pages(s)
      /nedfer                    1 pages(s)
      /players                 293 pages(s)
      /rssbest                  15 pages(s)
      /sacups                   98 pages(s)
      /tables                  512 pages(s)
      /tablesa                2097 pages(s)
      /tablesb                1104 pages(s)
      /tablesc                1442 pages(s)
      /tablesd                 831 pages(s)
      /tablesd/dfbcup            8 pages(s)
      /tablese                1029 pages(s)
      /tablesf                 744 pages(s)
      /tablesg                 909 pages(s)
      /tablesh                 370 pages(s)
      /tablesi                1027 pages(s)
      /tablesj                 317 pages(s)
      /tablesk                 562 pages(s)
      /tablesl                 441 pages(s)
      /tablesm                1290 pages(s)
      /tablesn                1057 pages(s)
      /tableso                 673 pages(s)
      /tablesp                 768 pages(s)
      /tablesq                  49 pages(s)
      /tablesr                 385 pages(s)
      /tabless                2078 pages(s)
      /tablest                 820 pages(s)
      /tablesu                 448 pages(s)
      /tablesv                 212 pages(s)
      /tablesw                 426 pages(s)
      /tablesx                   3 pages(s)
      /tablesy                  42 pages(s)
      /tablesz                 579 pages(s)
      /usadave                  14 pages(s)
      /wk94                      1 pages(s)

   29 page(s) - .html/.htm 404 (not found)
    7 page(s) - .pdf
   10 page(s) - other
TXT

def sum_counts( txt )
  numbers = txt.scan( /\d+/ ).map{ |str| str.to_i }
  puts "  #{numbers.size} number(s)"
  sum = numbers.sum

  sum
end



puts  sum_counts( text )
#=>   41889   -- 45 counts

puts  sum_counts( text2 )
#=    21994   -- 45 counts


puts "bye"