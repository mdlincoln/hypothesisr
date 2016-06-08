hypothesisr
===========

[![Travis-CI Build Status](https://travis-ci.org/mdlincoln/hypothesisr.svg?branch=master)](https://travis-ci.org/mdlincoln/hypothesisr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdlincoln/hypothesisr?branch=master&svg=true)](https://ci.appveyor.com/project/mdlincoln/hypothesisr)

Interact with the API for [hypothes.is](https://hypothes.is/), the web annotation service.

Allows users to add, search for, and retrieve annotation data.


## Installation

```r
# install.packages("devtools")
devtools::install_github("mdlincoln/hypothesisr")
```

## Usage

Search and retrieve annotation data

``` r
library(hypothesisr)
ulysses_annotations <- hs_search(text = "ulysses")
dim(ulysses_annotations)
#> [1]  6 28
names(ulysses_annotations)
#>  [1] "updated"                     "group"                      
#>  [3] "target"                      "tags"                       
#>  [5] "text"                        "created"                    
#>  [7] "uri"                         "user"                       
#>  [9] "id"                          "references"                 
#> [11] "links.json"                  "links.html"                 
#> [13] "links.incontext"             "document.link"              
#> [15] "document.title"              "document.favicon"           
#> [17] "document.twitter.url"        "document.twitter.site"      
#> [19] "document.twitter.card"       "document.twitter.title"     
#> [21] "document.facebook.url"       "document.facebook.site_name"
#> [23] "document.facebook.type"      "document.facebook.title"    
#> [25] "permissions.read"            "permissions.admin"          
#> [27] "permissions.update"          "permissions.delete"
ulysses_annotations$text
#> [1] "Pope adds in a footnote: \"Minerva in like manner, during the Battle of Ulysses with the Suitors in Odyss. perches on a beam of the roof to behold it.\"\n\nSource: \n\nPope, Alexander, and Adolphus William Ward. The Poetical Works of Alexander Pope. London: Macmillan, 1907. Print."
#> [2] "Reminds me also of the \"Bloomsday\" tradition of reading (gulp) Joyce's *Ulysses* aloud on the calendar day associated with the fictional events of the novel."                                                                                                                          
#> [3] "I wonder if the paperback of *Ulysses* I spilled a Venti iced coffee on in 2009 will make it into one of these displays some day. Probably not, but a girl can dream, right?"                                                                                                             
#> [4] "Using s sneak attack on Gen, Ulysses S. Grant on the Tennessee river ending in 13,000 people killed and injured on the union, and 10,000 confederates. Knowing that the Union can not take many more loses like this, and something new had to be done. "                                 
#> [5] "And Ulysses may be the ideal text to annotate and collaborate with, as Joyce's work itself  "                                                                                                                                                                                             
#> [6] "What better novel to annotate than Ulysses, a novel full of jokes, references, and puzzles? "
```

You may also retreive the data describing individual annotations by id:

``` r
hs_read("Zzx_RC2cEeaSN18iqoj6Aw")
```
---
[Matthew Lincoln](http://matthewlincoln.net)
