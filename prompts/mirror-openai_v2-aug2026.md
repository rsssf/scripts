
## q: how many web pages has the rsssf.org archive site?


## a:

If by **“how many web pages”** you mean the total number of individual HTML pages/files in the **RSSSF (Rec.Sport.Soccer Statistics Foundation) archive**, there does not appear to be an official published page count.

The archive is **very large — almost certainly tens of thousands of pages**. RSSSF itself describes the archive as covering six major sections: current international tournaments, current domestic results, historical domestic results, international club results, international country results, and miscellaneous material. ([rsssf.org][1])

For scale:

* The historical domestic section alone contains **thousands of individual season/country files**, going back into the 19th century. ([rsssf.org][2])
* The countrywise historical section has extensive separate pages for league histories, all-time tables, champions, divisional movements, topscorers, etc. ([rsssf.org][3])
* There are separate pages for current competitions across essentially the whole world. ([rsssf.org][4])
* RSSSF is **still being updated in August 2026**, with new historical files being added almost every week. ([rsssf.org][5])

### I can get you a much more precise number

If you're interested, I can **systematically crawl/index `rsssf.org` and estimate or calculate the number of distinct HTML pages currently in the archive**, including or excluding things like:

1. **RSSSF archive only** (`/archive.html` and everything linked from it)
2. **Entire rsssf.org domain**
3. **Only actual statistics/data pages**, excluding navigation/index pages
4. **Every HTML file**, including historical/old/auxiliary pages

I can also break the total down by **country, section, and decade**, which would be quite interesting for RSSSF.

[1]: https://www.rsssf.org/archive.html?utm_source=chatgpt.com "The RSSSF Archive"
[2]: https://www.rsssf.org/resultsp.html?utm_source=chatgpt.com "The RSSSF Archive - Domestic Results 1886/87-1989/90"
[3]: https://www.rsssf.org/country.html?utm_source=chatgpt.com "The RSSSF Archive - Domestic League History - Countrywise"
[4]: https://www.rsssf.org/results-eur.html?utm_source=chatgpt.com "The RSSSF Archive - Domestic Results (Europe)"
[5]: https://rsssf.org/recent.html?utm_source=chatgpt.com "The RSSSF Archive - Recent Additions"




## q:  thanks. yes, can you help on how to make a copy / mirror of all pages?

Absolutely. And I found something particularly useful: **RSSSF itself publishes a mirroring tool**. Its GitHub repository says the tool is designed to mirror the *complete rsssf.org website*, currently described as **40,000+ HTML pages / about 800 MB**. It follows internal links, downloads and caches the pages, converts them to UTF-8, and builds a SQLite database containing the page/link structure. ([GitHub][1])

So rather than writing our own crawler from scratch, I would start with their own tool.

### Option 1 — Use RSSSF's own mirror tool

The project is here:

[RSSSF scripts — GitHub](https://github.com/rsssf/scripts?utm_source=chatgpt.com)

The relevant directory is `mirror`. RSSSF gives this basic procedure:

```bash
git clone https://github.com/rsssf/scripts.git
cd scripts
ruby mirror/mirror.rb
```

The pages are normally stored in a local `cache` directory. The tool also creates `mirror.db`, which records pages and their incoming/outgoing links. RSSSF estimates that a full run can take roughly **22 hours**, because it deliberately uses a delay between downloads. ([GitHub][1])

There is also a reporting command:

```bash
ruby mirror/report.rb
```

which produces a `SUMMARY.md` containing page/directory statistics.

And:

```bash
ruby mirror/export.rb
```

exports the discovered pages into CSV files such as:

* `pages_html.csv`
* `pages_html_404.csv`
* `pages_pdf.csv`
* `pages_other.csv`

That's actually very useful for our original question about **how many pages RSSSF has**.

### Option 2 — Make a conventional offline website mirror

If your objective is:

> “I want a folder containing RSSSF that I can browse offline exactly like a website.”

I'd approach it slightly differently.

For example, using `wget`:

```bash
wget \
  --mirror \
  --convert-links \
  --adjust-extension \
  --page-requisites \
  --no-parent \
  --wait=2 \
  --random-wait \
  https://www.rsssf.org/
```

This creates a conventional local copy with links rewritten so that you can browse it without an Internet connection.

However, **I would not immediately recommend doing this**. RSSSF's own mirror program is more appropriate because the site is unusually large and old, and RSSSF specifically designed its crawler to deal with its archive. ([GitHub][1])

### There's an important distinction

The RSSSF archive is not simply one directory of 40,000 files. The archive is organized into six major sections, including current international tournaments, current domestic results, historical domestic results, international club results, international country results and miscellaneous material. ([RSSSF][2])

And it's still being updated — for example, the RSSSF "Recent Additions" page lists additions from **27 August 2026**. ([RSSSF][3])

So I'd recommend building the mirror in two stages:

**Stage 1:** Download the entire current RSSSF site and generate an inventory.

**Stage 2:** Turn that inventory into a **maintainable mirror**, where a subsequent run downloads only new/changed pages instead of starting from zero.

That would give you something like:

```text
rsssf-mirror/
│
├── www.rsssf.org/
│   ├── archive.html
│   ├── histdom.html
│   ├── results/
│   ├── tables/
│   ├── misc/
│   └── ...
│
├── database/
│   └── mirror.db
│
├── reports/
│   ├── pages.csv
│   ├── broken-links.csv
│   └── statistics.md
│
└── scripts/
    └── update-mirror.sh
```

You could then periodically run an update and have a **permanent local/archive copy of RSSSF**, while retaining the original URLs and link relationships.

**One caveat:** RSSSF's site says that its documents are copyrighted, although its links page says documents may be copied in whole or in part with proper acknowledgement. ([RSSSF][4]) If this is for personal/offline preservation, that's quite different from republishing the whole mirror publicly, so I'd check with RSSSF before making the mirror publicly accessible.

If you tell me **what computer you're using (Windows, Mac, or Linux)** and whether you want **(A) an offline copy, (B) a backup/archive, or (C) a searchable database of all RSSSF statistics**, I can give you the exact step-by-step setup.

[1]: https://github.com/rsssf/scripts?utm_source=chatgpt.com "GitHub - rsssf/scripts: football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) tools & scripts · GitHub"
[2]: https://www.rsssf.org/archive.html?utm_source=chatgpt.com "The RSSSF Archive"
[3]: https://rsssf.org/recent.html?utm_source=chatgpt.com "The RSSSF Archive - Recent Additions"
[4]: https://www.rsssf.org/links.html?utm_source=chatgpt.com "The RSSSF Archive - Links to Other International Servers"


## q: thanks. yes, can you help with the step-by-steps on windows?

Yes. On Windows, the cleanest route is to use **RSSSF’s own Ruby mirroring script**, because it was specifically written for the site and currently describes the archive as **40,000+ HTML pages, roughly 800 MB**. ([GitHub][1])

### 1. Install Git and Ruby

Install **Git for Windows** and a recent **Ruby + Devkit** build. During installation, accept the normal defaults and make sure both `git` and `ruby` are added to your PATH.

Afterward, open **Windows Terminal** or **Command Prompt** and verify:

```bat
git --version
ruby --version
```

Both commands should print version numbers.

### 2. Choose where the mirror will live

For example, create:

```text
C:\rsssf
```

Then in Command Prompt:

```bat
cd C:\
mkdir rsssf
cd rsssf
```

### 3. Download the official RSSSF scripts

Run:

```bat
git clone https://github.com/rsssf/scripts.git
cd scripts
```

You should now be in:

```text
C:\rsssf\scripts
```

The repository contains the `mirror` program used to crawl the complete RSSSF site. ([GitHub][1])

### 4. Try the mirror

Run:

```bat
ruby mirror\mirror.rb
```

The program should start discovering RSSSF pages and saving them locally.

By default, downloaded pages go into:

```text
C:\rsssf\scripts\cache
```

and the crawler builds:

```text
mirror.db
```

The SQLite database records pages, links, titles, incoming links and outgoing links. ([GitHub][1])

### 5. Do not interrupt it unnecessarily

RSSSF's documentation says a complete crawl can take roughly **22 hours** with its deliberate request delay. That's a good feature: it avoids hammering the RSSSF server. ([GitHub][1])

Keep the PC powered on and prevent Windows from sleeping while it runs.

On Windows 11, you can temporarily change:

**Settings → System → Power & battery → Screen and sleep**

and set sleep to **Never** while plugged in.

### 6. Check what was downloaded

After the crawl finishes, run:

```bat
ruby mirror\report.rb
```

RSSSF says this generates:

```text
mirror\SUMMARY.md
```

containing statistics about the downloaded pages and directories. ([GitHub][1])

Open it in Notepad:

```bat
notepad mirror\SUMMARY.md
```

This should also help answer your original question: **exactly how many RSSSF pages the crawler discovered.**

### 7. Export the complete page list

Run:

```bat
ruby mirror\export.rb
```

It should produce CSV files such as:

```text
tmp-mirror\pages_html.csv
tmp-mirror\pages_html_404.csv
tmp-mirror\pages_pdf.csv
tmp-mirror\pages_other.csv
```

That gives you a very useful inventory. ([GitHub][1])

You can open `pages_html.csv` directly in Excel.

### 8. Your folder should eventually resemble this

```text
C:\rsssf\
└── scripts\
    ├── cache\
    │   └── ... thousands of RSSSF pages ...
    ├── mirror\
    │   ├── mirror.rb
    │   ├── report.rb
    │   ├── export.rb
    │   └── SUMMARY.md
    ├── tmp-mirror\
    │   ├── pages_html.csv
    │   ├── pages_html_404.csv
    │   ├── pages_pdf.csv
    │   └── pages_other.csv
    └── mirror.db
```

One important detail: **RSSSF's `cache` is primarily an archive/cache for analysis, rather than necessarily a polished, double-clickable offline clone of `www.rsssf.org`.** Its own tool converts pages to UTF-8 and records their relationship in SQLite. ([GitHub][1])

If your goal is to type something like:

```text
http://localhost/tablese/eng2025.html
```

in Chrome and browse the entire archive locally with working links, we can add a second step after the crawl to turn the downloaded material into a **proper browsable Windows mirror**.

### I recommend this setup

Use RSSSF's crawler first rather than `wget`. It gives us three things at once:

**original archive → local pages → SQLite index**

and it respects the crawling strategy the RSSSF project itself designed.

There's also an RSSSF `tables` repository containing converted plain-text versions of many archive tables, but that's a different project and isn't a full HTML mirror. ([GitHub][2])

If you want, I can next give you a **very beginner-friendly Windows guide for making the resulting RSSSF mirror browsable in Chrome at `http://localhost:8000/`**, including a one-click `.bat` file to start it.

[1]: https://github.com/rsssf/scripts?utm_source=chatgpt.com "GitHub - rsssf/scripts: football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) tools & scripts · GitHub"
[2]: https://github.com/rsssf/tables?utm_source=chatgpt.com "GitHub - rsssf/tables: football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) tables (cache / playground / sandbox) mirror · GitHub"
