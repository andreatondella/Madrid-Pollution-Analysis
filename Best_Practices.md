# Best Practices

The best practice is to keep every R.script as concise and targeted to a single issue as possible.

## Dealing with libraries and user defined functions

* The idea is to create a script named lib_loading.R or similar where to write down all the library() instruction

* At the beginning of every script is then sufficient to call: source("lib_loading.R") to have all the library loaded, with no need to write them all down

* Same goes for user defined functions that will be used in more than one script: create a R.script like funX_definition.R and then call the function when needed with source("funX_definition.R")


