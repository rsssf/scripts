

=begin
def build_site_banner( site: )

  ## note - banner is its own pre block
  banner = String.new
  banner += "<pre>\n"

  banner += %Q{<a href="#{site.basepath}/index.html" title="Pages & Subdir Index">/</a>}
  banner += " - "
  banner += %q{<a href="./codes.html">Codes Index A-Z</a>}
  banner += " - "
  banner += %q{<a href="./updates.html">Latest Updates</a>}

  banner += "\n"
  banner += "</pre>\n"

  banner

end
=end


## rename to build_dir_banner - why? why not?
def build_banner( site: )


## rsssf_url  = "https://rsssf.org/#{page.dirname}/#{page.basename}.html"

## edit_url = "https://github.com/rsssf/tables/blob/master/#{page.dirname}/#{page.basename}.txt"

## txt_url  = "https://github.com/rsssf/tables/raw/refs/heads/master/#{page.dirname}/#{page.basename}.txt"


## note - banner is its own pre block
banner = String.new
banner += "<pre>\n"
banner += %Q{<a href="#{site.basepath}/index.html" title="Pages & Subdir Index">/</a>}

=begin
banner += " - "
banner += %Q{<a href="#{rsssf_url}">original @ rsssf.org</a>}
banner += " - "
banner += %Q{<a href="#{edit_url}" title="yes, you can! changes tracked @ github">view/edit this page</a>}
banner += " ("
banner += %Q{<a href="#{txt_url}" title="100% plain text, yes, ALWAYS in unicode (utf-8)">.txt</a>}
banner += ")"
banner += " - "
=begin
banner += %q{<a href="" title="SOON!">football.txt version</a>}
banner += " ("
banner += %q{<a href="" title="SOON!">.json</a>}
banner += ", "
banner += %q{<a href="" title="SOON!">.log</a>}
banner += ")"

banner += %q{<span title="UPCOMING SOON!">football.txt version</span>}
banner += " ("
banner += %q{<span title="UPCOMING SOON!">.json</span>}
banner += ", "
banner += %q{<span title="UPCOMING SOON!">.log</span>}
banner += ")"
=end


banner += "\n"
banner += "</pre>\n"

banner

end