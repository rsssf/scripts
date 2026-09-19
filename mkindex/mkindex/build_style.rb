
def build_style( outdir: )

  css =<<CSS

a, a:visited {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

CSS

   write_text( "#{outdir}/style.css", css )
end
