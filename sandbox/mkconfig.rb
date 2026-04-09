require_relative 'helper'



path = './tmp2/austria'
## path = '/sports/rsssf/austria' 

code    = 'at'
seasons = Season('1974/75')..Season('2025/26')   ## start 1974/75 
title   = 'Austria (Österreich)'

pp seasons.to_a

rows = []
seasons.each do |season|
    page, encoding = Rsssf.table_page_n_encoding( code, season: season )
    rows << [page, encoding]
end
pp rows
write_csv( "./tmp2/at.csv", rows, headers: ['page', 'encoding'] )

