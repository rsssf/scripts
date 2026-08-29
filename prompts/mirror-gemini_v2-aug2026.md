via google ai mode -- asking same question again some months later (aug 2026)

## q:  how many web pages has the rsssf.org archive site?


Because the Rec.Sport.Soccer Statistics Foundation (RSSSF) archive is a crowd-sourced, volunteer-run repository built continuously since 1994, the exact number of web pages fluctuates and is not officially tracked or published as a static figure. [1, 2]

However, the size of the database can be understood through its scale:

* Estimated Page Count: Search engine crawls generally index tens of thousands of individual URLs across the main rsssf.org domain and its regional sub-projects (such as RSSSF Brazil, Albania, or Norway). [3]

* Structure: The archive is highly decentralized. Rather than using a modern relational database framework, it functions as a massive directory of static, raw HTML and plain-text files (.html and .txt) organized country-by-country and tournament-by-tournament. [3, 4, 5]

* Content Scale: It documents comprehensive league tables, cup results, and international match lineups spanning over a century of football history for nearly every country on Earth. [2, 6, 7]

---



## q:  thanks. can you help on how to make  a copy / mirror of all pages?

Creating a full local copy or "mirror" of the RSSSF archive is highly achievable because the website consists almost entirely of static HTML and plain text files.
The standard and most efficient tool for this task is wget, a free, open-source command-line utility available for Windows, macOS, and Linux.

### ⚠️ Important Etiquette Before You Start
Because RSSSF is run by volunteers on limited hosting resources, aggressive scraping can accidentally crash or stress their server. Always follow these rules:

   1. Download sequentially: Do not use multi-threading or parallel downloads.
   2. Add a delay: Put a 1–2 second pause between every page request.
   3. Download only once: Once you have the archive, update it incrementally rather than downloading everything from scratch again.


### The Recommended wget Command
Open your terminal (or Command Prompt) and run the following command. Make sure you navigate (cd) to the folder where you want to save the archive first:

wget --mirror --page-requisites --adjust-extension --convert-links --no-parent --wait=2 --limit-rate=200k https://rsssf.org

### What This Command Does (Broken Down)

* --mirror: Turns on options suitable for mirroring (recursion, time-stamping, infinite depth).
* --page-requisites: Downloads all the elements needed to display the HTML page correctly (like basic CSS files or images).
* --adjust-extension: Ensures that files end in .html if they are HTML, so your computer opens them correctly offline.
* --convert-links: Rewrites the links inside the downloaded pages so they point to your local files instead of the live website. This makes the archive 100% browseable offline.
* --no-parent: Guarantees that wget won't wander off into external websites that RSSSF might link to.
* --wait=2: Crucial. Pauses for 2 seconds between every single file request to respect the server.
* --limit-rate=200k: Limits the download speed to 200 KB/s so you do not hog the website's bandwidth.


### Alternative: Using HTTrack (Graphical User Interface)
If you prefer a visual application instead of the command line, you can use [HTTrack Website Copier](https://www.httrack.com/).

   1. Download and install HTTrack.
   2. Start a new project and enter https://rsssf.org as the Web Address (URL).
   3. Click Set options -> Limits tab, and set a Delay of 2000 ms (2 seconds).
   4. Click Next and let it run.

Note: Because the RSSSF archive contains tens of thousands of deeply nested pages, the download process will take several hours or even days to complete safely with the required delays. Make sure you have a few gigabytes of free disk space.



## q: can you help with using the mirror rsssf scripts on github @ https://github.com/rsssf/scripts

The Open Source rsssf/scripts repository provides a specialized Ruby-based framework tailored specifically for this archive.

Unlike generic crawlers, this tool downloads the pages and dynamically builds a local SQLite database (mirror.db) to map out the link structures, page titles, and incoming/outgoing directory connections. It also reveals that the archive currently sits at roughly 40,000+ HTML pages (approx. 800 MB).

Here is a step-by-step guide to setting up and running their mirror script.

## 📋 Prerequisites
Before running the script, you need Ruby and SQLite3 installed on your system.

* macOS: Ruby comes pre-installed, or you can use Homebrew: brew install ruby sqlite3
* Linux (Ubuntu/Debian): Run sudo apt update && sudo apt install ruby ruby-dev sqlite3 libsqlite3-dev build-essential
* Windows: Download and run the [RubyInstaller for Windows](https://rubyinstaller.org/), making sure to check the box for "MSYS2 development toolchain."

## 🚀 Step-by-Step Installation and Execution
## 1. Clone the Repository
Open your terminal or command line and clone the repository to your local machine:

git clone https://github.com
cd scripts

## 2. Install Ruby Dependencies
The script relies on external Ruby libraries (gems) for web scraping and database management. Install them using Bundler:

gem install bundler
bundle install

(If a Gemfile isn't fully configured in your clone, you can manually install the required components by running gem install sqlite3 activerecord nokogiri htmldiff).
## 3. Run the Mirror Script
To start the mirroring pipeline, execute the primary Ruby file:

ruby mirror/mirror.rb


* What happens now: The script will automatically create a directory called ./cache where it downloads and saves every HTML page converted to clean UTF-8 encoding. Simultaneously, it logs the architectural mapping into mirror/mirror.db.

* Duration: Because the script natively builds in a polite 1-second delay between web requests to respect the volunteer-run servers, crawling all 40,000+ pages will take approximately 22 hours to complete safely.


## 📊 Bonus: Generating Reports and Exports
Once your download is finished (or even while it's partially running), you can use the extra utilities built into the repository:
## Generate a Directory Markdown Summary
To see a clean structural breakdown of what you've scraped, run the reporting script:

ruby mirror/report.rb

This generates a markdown file at mirror/SUMMARY.md showing your structural site statistics.
## Export the Structure to CSV
If you plan to parse the pages using Python, R, or Excel, you can export the database architecture into flat spreadsheets:

ruby mirror/export.rb

Look inside the tmp-mirror/ folder to find generated logs split cleanly by format: pages_html.csv, pages_pdf.csv, and pages_html_404.csv.
