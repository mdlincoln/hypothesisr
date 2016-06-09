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

You can specify any of the available annotation data fields with a named list using the `custom` parameter.
For example, to find all the annotations on a domain, query the `uri.parts` field (but don't include `.com`, `.org`, `.edu` and the like; this currently results in the API returning annotations sharing any of those TLDs.)

``` r
ph <- hs_search_all(custom = list(uri.parts = "programminghistorian"))

library(dplyr)
# Display the top 5 most-annotated pages under this domain
slice(count(ph, uri, sort = TRUE), 1:5)
```

| uri                                                                                                              |    n|
|:-----------------------------------------------------------------------------------------------------------------|----:|
| <http://programminghistorian.org/lessons/getting-started-with-markdown>                                          |    6|
| <http://programminghistorian.org/lessons/graph-databases-and-SPARQL>                                             |    6|
| <http://programminghistorian.org/lessons/intro-to-the-zotero-api>                                                |    6|
| <http://programminghistorian.github.io/ph-submissions/lessons/building-static-sites-with-jekyll-github-pages>    |    5|
| <http://programminghistorian.org/lessons/creating-new-items-in-zotero>                                           |    5|

`hs_search()` will retrieve one page of annotations (up to 200 annotations per page), while `hs_search_all()` will page through all available annotations until they are all downloaded.

Note: running `hs_search_all()` with no parameters will download _all_ publicly accessible hypothes.is annotations.

### Create, read, update, and delete annotations

To create and delete annotations, you will need to register for an API token at <https://hypothes.is/register>.

_At the moment, hpothesisr cannot create annotations targeted to a particular section of a webpage, such as a highlighted line. These annotations will be visible at the page-level._

``` r
user_token <- "xxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
hs_create(token = user_token, uri = "https://github.com/mdlincoln/hypothesisr", user = "acct:mdlincoln@hypothes.is", tags = c("testing", "R"), text = "R made me!")
#> [1] "WFMnSC3FEeaNvLeGkQeJbg"
```

You may also retrieve the data describing individual annotations by id:

``` r
a <- hs_read("WFMnSC3FEeaNvLeGkQeJbg")
a$uri
#> [1] "https://github.com/mdlincoln/hypothesisr"
a$text
#> [1] "R made me!"
a$user
#> [1] "acct:mdlincoln@hypothes.is"
```

You can update individual fields of annotations by passing your token, the annotation ID, and one or more fields with replacement values.

``` r
hs_update(user_token, "WFMnSC3FEeaNvLeGkQeJbg", text = "Now even more annotate-y!")
hs_read("WFMnSC3FEeaNvLeGkQeJbg")$text
#> [1] "Now even more annotate-y!"
```

You can also delete annotations (at least, those for which you have the permissions to delete):

``` r
hs_delete(user_token, "lDf9rC3EEea6ck-G5kLdXA")
#> [1] TRUE
```

### Other utilities

Easily reply to an annotation with `hs_reply()`, which sends useful defaults to `hs_create()` in order to construct a new annotation that will show up as a reply to an existing annotation.

`open_context(id)` will open a hypothes.is annotation in context in the browser.

## To-do

1. Target annotations to specific parts of a webpage

---
[Matthew Lincoln](http://matthewlincoln.net)
