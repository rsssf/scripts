###
#  to run use:
#
#   $ ruby mirrorx/querydir.rb


require_relative 'helper'


dbpath = ARGV[0] || './mirror.db'
MirrorDb.open( dbpath )


dirname = ARGV[1] || '/tablesx'


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"




puts "==> #{dirname}:"
MirrorDb::Model::Page.order( 'path' ).where( 'dirname = ?', dirname ).each do |page|
   dump_page( page, backlinks: true )
end

puts "---"
MirrorDb::Model::Page.order( 'path' ).where( 'dirname = ?', dirname ).each do |page|
   dump_page( page, backlinks: false )
end

count = MirrorDb::Model::Page.where( 'dirname = ?', dirname ).count
puts "  #{count} page(s)"



puts "bye"


__END__

/tablesx
/tablesx/xadampreseason.html           CACHED    1 /   1              >Amsterdam Pre-Season Tournaments 1917-1970<
/tablesx/xporoobeke1911.html           CACHED   15 /  13              >U.I.A.F.A. and the Grand Tournoi Européen (Roubaix) 1911<
/tablesx/xrussenspiele.html            CACHED    2 /   1              >"Russenspiele" 1924-1927<
  3 page(s)

---

==> /tablesx:
/tablesx/xacobeo99.html                CACHED    1 /   2              >Trofeo Xacobeo 1999<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent01.html    >The RSSSF Archive - Additions 2001<
/tablesx/xadampreseason.html           CACHED    6 /   8              >Amsterdam Pre-Season Tournaments 1917-1970<
                                              <= /tablesz/zvb-sparta.html    >Zilveren Voetbal (Rotterdam) 1901-1956<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /miscellaneous/uefa.html    >UEFA Cup/Europa League Trivia<
                                              <= /tablesx/xdompreseason.html    >Utrecht Pre-Season Tournaments 1909-1967<
                                              <= /tablesx/xgroningerdagblad.html    >Groninger Dagbladbeker 1911-1950<
                                              <= /tablesx/xbavopreseason.html    >Haarlem/Heemstede Pre-Season Tournaments 1933-1954<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
                                              <= /recent2019.html    >The RSSSF Archive - Additions 2019<
/tablesx/xaiserstuhl2012.html          CACHED    2 /   2              >AXA Kaiserstuhl-Cup 2012 - Bahlingen<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /tablesf/freiburg-tourn.html    >Kaiserstuhl Cup - formerly Freiburger Turnier and Karl-Heinz Bente Gedächtnisturnier<
/tablesx/xamax60-62.html               CACHED    1 /   2              >50th Anniversary of Xamax 1962<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent01.html    >The RSSSF Archive - Additions 2001<
/tablesx/xamistad.html                 CACHED    1 /   2              >Trofeo Amistad Extremadura<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xbavopreseason.html           CACHED    5 /   3              >Haarlem/Heemstede Pre-Season Tournaments 1933-1954<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /tablesx/xgroningerdagblad.html    >Groninger Dagbladbeker 1911-1950<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xdompreseason.html            CACHED    2 /   2              >Utrecht Pre-Season Tournaments 1909-1967<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xehvpreseason.html            CACHED    3 /   3              >Eindhoven/Valkenswaard Pre-Season Tournaments 1918-1945<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /tablesx/xphkvw.html    >Philips' Kunstvoorwerp 1918-1919<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xeroxsup88.html               CACHED    2 /   2              >Xerox Super Soccer (Tokyo) 1979-1990<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2011.html    >The RSSSF Archive - Additions 2011<
/tablesx/xerxes33.html                 CACHED    1 /   2              >Toernooi Xerxes (Rotterdam) 1933<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent09.html    >The RSSSF Archive - Additions 2009<
/tablesx/xgelrepreseason.html          CACHED    1 /   2              >Gelderland Pre-Season Tournaments 1933-1954<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2025.html    >The RSSSF Archive - Additions 2025<
/tablesx/xgroningerdagblad.html        CACHED    3 /   3              >Groninger Dagbladbeker 1911-1950<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /tablesx/xbavopreseason.html    >Haarlem/Heemstede Pre-Season Tournaments 1933-1954<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xhibit-istanbul51.html        CACHED    1 /   2              >Istanbul Exhibition Cup 1951<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2022.html    >The RSSSF Archive - Additions 2022<
/tablesx/ximineiro82tour.html          CACHED    1 /   2              >1982 tour of Combinado Mineiro (Brazil)<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2021.html    >The RSSSF Archive - Additions 2021<
/tablesx/xmodernfootball.html          CACHED    1 /   2              >Trofeo Against Modern Football (Murcia)<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xove.html                     CACHED    1 /   2              >Trofeo Concello de Xove Lago (Jove, Lugo)<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2025.html    >The RSSSF Archive - Additions 2025<
/tablesx/xphkvw.html                   CACHED    2 /   3              >Philips' Kunstvoorwerp 1918-1919<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /tablesx/xehvpreseason.html    >Eindhoven/Valkenswaard Pre-Season Tournaments 1918-1945<
                                              <= /recent2020.html    >The RSSSF Archive - Additions 2020<
/tablesx/xpomontreal67.html            CACHED    1 /   2              >"Expo 67" International Tournament, Montréal 1967<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent2011.html    >The RSSSF Archive - Additions 2011<
/tablesx/xporoobeke1911.html           CACHED   15 /  19              >U.I.A.F.A. and the Grand Tournoi Européen (Roubaix) 1911<
                                              <= /tablesi/interallied19.html    >Interallied Games 1919<
                                              <= /tablesk/kenyachamp.html    >Kenya - List of Champions<
                                              <= /tablese/engsupcuphist.html    >England - List of FA Charity/Community Shield Matches<
                                              <= /tablesf/franchamp.html    >France - List of Champions<
                                              <= /tableso/oost-habs-challenge.html    >Austria/Habsburg Monarchy - Challenge Cup 1897-1911<
                                              <= /tablesc/coupe-vdab.html    >Coupe Vanden Abeele<
                                              <= /tablesc/challenge-int-nord.html    >Challenge International du Nord<
                                              <= /tablesf/franitares.html    >France-Italy matches<
                                              <= /tableso/ol1908f-det.html    >Football Tournament 1908 Olympiad<
                                              <= /tableso/ol1912f-det.html    >Football Tournament 1912 Olympiad<
                                              <= /tableso/ol1920f-det.html    >Football Tournament 1920 Olympiad<
                                              <= /tableso/ol1928f-det.html    >Football Tournament 1928 Olympiad<
                                              <= /tableso/oost-tagblatt.html    >Austria - Tagblatt-Pokal 1900-1903<
                                              <= /tablesl/lux1910.html    >Luxembourg 1909/10<
                                              <= /tablesb/brit-ier-tours-prewwii.html    >British and Irish Clubs - Overseas Tours 1890-1939<
                                              <= /intland-friend.html    >The RSSSF Archive - International Country Results - Friendly Tournaments<
                                              <= /miscellaneous/crossborder.html    >Where's My Country?<
                                              <= /miscellaneous/fifaforgotten.html    >Miscellaneous Information on Representative Teams of non-FIFA Members<
                                              <= /recent2021.html    >The RSSSF Archive - Additions 2021<
/tablesx/xrussenspiele.html            CACHED    2 /   2              >"Russenspiele" 1924-1927<
                                              <= /recent.html    >The RSSSF Archive - Recent Additions<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
/tablesx/xthanglong2010.html           CACHED    3 /   3              >Eximbank Cup/Thang Long Cup (Ho Chi Minh City) 2010<
                                              <= /intland-friend.html    >The RSSSF Archive - International Country Results - Friendly Tournaments<
                                              <= /tablesh/hcm-exim08.html    >SJC Eximbank Cup 2008 (TP Ho Chi Minh)<
                                              <= /tablest/thanglong2010.html    >Thang Long Cup (Hanoi) 2010<
/tablesx/xxannican5.html               CACHED    1 /   2              >Trofeo XX Anni Canale 5 (Milano) 2000<
                                              <= /intclub-friend.html    >The RSSSF Archive - International Club Results - Friendly Tournaments<
                                              <= /recent01.html    >The RSSSF Archive - Additions 2001<
---
/tablesx/xacobeo99.html                CACHED    1 /   2              >Trofeo Xacobeo 1999<
/tablesx/xadampreseason.html           CACHED    6 /   8              >Amsterdam Pre-Season Tournaments 1917-1970<
/tablesx/xaiserstuhl2012.html          CACHED    2 /   2              >AXA Kaiserstuhl-Cup 2012 - Bahlingen<
/tablesx/xamax60-62.html               CACHED    1 /   2              >50th Anniversary of Xamax 1962<
/tablesx/xamistad.html                 CACHED    1 /   2              >Trofeo Amistad Extremadura<
/tablesx/xbavopreseason.html           CACHED    5 /   3              >Haarlem/Heemstede Pre-Season Tournaments 1933-1954<
/tablesx/xdompreseason.html            CACHED    2 /   2              >Utrecht Pre-Season Tournaments 1909-1967<
/tablesx/xehvpreseason.html            CACHED    3 /   3              >Eindhoven/Valkenswaard Pre-Season Tournaments 1918-1945<
/tablesx/xeroxsup88.html               CACHED    2 /   2              >Xerox Super Soccer (Tokyo) 1979-1990<
/tablesx/xerxes33.html                 CACHED    1 /   2              >Toernooi Xerxes (Rotterdam) 1933<
/tablesx/xgelrepreseason.html          CACHED    1 /   2              >Gelderland Pre-Season Tournaments 1933-1954<
/tablesx/xgroningerdagblad.html        CACHED    3 /   3              >Groninger Dagbladbeker 1911-1950<
/tablesx/xhibit-istanbul51.html        CACHED    1 /   2              >Istanbul Exhibition Cup 1951<
/tablesx/ximineiro82tour.html          CACHED    1 /   2              >1982 tour of Combinado Mineiro (Brazil)<
/tablesx/xmodernfootball.html          CACHED    1 /   2              >Trofeo Against Modern Football (Murcia)<
/tablesx/xove.html                     CACHED    1 /   2              >Trofeo Concello de Xove Lago (Jove, Lugo)<
/tablesx/xphkvw.html                   CACHED    2 /   3              >Philips' Kunstvoorwerp 1918-1919<
/tablesx/xpomontreal67.html            CACHED    1 /   2              >"Expo 67" International Tournament, Montréal 1967<
/tablesx/xporoobeke1911.html           CACHED   15 /  19              >U.I.A.F.A. and the Grand Tournoi Européen (Roubaix) 1911<
/tablesx/xrussenspiele.html            CACHED    2 /   2              >"Russenspiele" 1924-1927<
/tablesx/xthanglong2010.html           CACHED    3 /   3              >Eximbank Cup/Thang Long Cup (Ho Chi Minh City) 2010<
/tablesx/xxannican5.html               CACHED    1 /   2              >Trofeo XX Anni Canale 5 (Milano) 2000<
  22 page(s)
