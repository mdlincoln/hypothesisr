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

### Search and retrieve annotations

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

`hs_search()` will retrieve one page of annotations (up to 200 annotations per page), while `hs_search_all()` will page through all available annotations until they are all downloaded.

Note: running `hs_search_all()` with no parameters will download _all_ publicly accessible hypothes.is annotations.

### Create, read, update, and delete annotations

To create and delete annotations, you will need to register for an API token at <https://hypothes.is/register>.

_At the moment, hpothesisr cannot create annotations targeted to a particular section of a webpage, such as a highlighted line. These annotations will be visible at the page-level._

``` r
user_token <- "xxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
hs_create(token = user_token, uri = "https://github.com/mdlincoln/hypothesisr", user = "acct:mdlincoln@hypothes.is", tags = c("testing", "R"), text = "R made me!")
#> [1] "lDf9rC3EEea6ck-G5kLdXA"
```

You may also retrieve the data describing individual annotations by id:

``` r
hs_read("lDf9rC3EEea6ck-G5kLdXA")
#>                            updated     group
#> 1 2016-06-08T22:01:40.496319+00:00 __world__
#>                                     target
#> 1 https://github.com/mdlincoln/hypothesisr
#>                                                   links.json
#> 1 https://hypothes.is/api/annotations/lDf9rC3EEea6ck-G5kLdXA
#>                                     links.html
#> 1 https://hypothes.is/a/lDf9rC3EEea6ck-G5kLdXA
#>                                                          links.incontext
#> 1 https://hyp.is/lDf9rC3EEea6ck-G5kLdXA/github.com/mdlincoln/hypothesisr
#>         tags       text                          created
#> 1 testing, R R made me! 2016-06-08T22:01:40.496312+00:00
#>                                        uri                       user
#> 1 https://github.com/mdlincoln/hypothesisr acct:mdlincoln@hypothes.is
#>                                       link                     id
#> 1 https://github.com/mdlincoln/hypothesisr lDf9rC3EEea6ck-G5kLdXA
#>   permissions.read          permissions.admin         permissions.update
#> 1  group:__world__ acct:mdlincoln@hypothes.is acct:mdlincoln@hypothes.is
#>           permissions.delete
#> 1 acct:mdlincoln@hypothes.is
```

You can update individual fields of annotations by passing your token, the annotation ID, and one or more fields with replacement values.

``` r
hs_update(user_token, "lDf9rC3EEea6ck-G5kLdXA", text = "Now even more annotate-y!")
hs_read("lDf9rC3EEea6ck-G5kLdXA")$text
#> [1] "Now even more annotate-y!"
```

You can also delete annotations (at least, those for which you have the permissions to delete):

``` r
hs_delete(user_token, "lDf9rC3EEea6ck-G5kLdXA")
#> [1] TRUE
```

## To-do

1. Target annotations to specific parts of a webpage
1. Generalize hypothesisr to work on localized installations of hypothes.is

---
[Matthew Lincoln](http://matthewlincoln.net)
