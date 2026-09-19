


##
##  find a better name e.g. build_page_layout or such - why? why not?

##
##  note use site.baseurl  to get
##                  subpath or github repo e.g.
##  baseurl: /mirror      !!!!!
##    for now follows "jekyll-style" - why? why not?
##     find a better name
##     use basepath for now  - why? why not?

def build_layout( site:,
                  title:,
                  body:,
                  banner: nil )


footer = <<HTML
<hr>
<pre>
 &lt;/&gt; <a href="https://github.com/rsssf/mirror">About this site</a>
     Patches, suggestions, and comments are welcome.
</pre>
HTML

content = String.new
content += banner   if banner
content += body
content += footer   if footer




page = String.new

   page += <<HTML
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>#{title}</title>
   <link rel="stylesheet" href="#{site.basepath}/style.css">
</head>
<body>
#{content}
</body></html>
HTML


page

end