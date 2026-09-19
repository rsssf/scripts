# How-To (Re)Build Index Pages


to test locally run:

    $ ruby mkindex/mkindex.rb -h
    $ ruby mkindex/mkindex.rb --outdir=./tmp-index --rootdir=/sports/rsssf/mirror/pages

note - to update on rsssf.github.io/mirror use (the configured) github actions


## prepare setup

export pages.csv index datasets.
use:

    $ ruby mirrorx/export_v2.rb -h
    $ ruby mirrorx/export_v2.rb --outdir=./tmp-mirror
    $ ruby mirrorx/export_v2.rb --outdir=/sports/rsssf/mirror/pages
