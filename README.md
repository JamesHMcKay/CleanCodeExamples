# Clean code for statistical production

This project is a work in progress, there are not any decent code and test examples yet, but the bulk of the document below is complete.

## Introduction
This document presents a course in writing code that is maintainable, robust and easy for others to understand.  The principles are based on those presented elsewhere, such as Clean Code by Robert C. Martin or Refactoring by Martin Fowler, but with adaptations to languages used by data analysts (such as R and Python). This is not an exhaustive course on the matter but a starter on writing better code.

The R and Python (amongst others) languages are used by many as a means to analyse data, with code often run only a handful of times by a single researcher or analyst.  While I would argue even the researcher should be writing robust code, it is when code is used as part of a statistical production system that it is essential best practice is applied to ensure the results are reliable, the code is understandable in a team, and that the business does not suffer from the consequences of technical debt.
What is technical debt and refactoring?
Technical debt is the cost incurred when building software in a way that may solve the immediate problem but makes it more difficult to change and build upon later. It is often the result of poorly written code. One outcome of refactoring is the reduction of technical debt by reworking parts of the software to be more elegant, use cleaner abstractions and be easier to adapt, while the functionality of the system remains the same.
What is clean code?

There are various definitions of what we mean by “clean code”.  I’ll take two quotes from Robert’s book that I feel give a succinct summary:

*Clean code always looks like it was written by someone who cares.  There is nothing obvious that you can do to make it better.*

Michael Feathers (Martin 2009)

*I like my code to be elegant and efficient.…  Clean code does one thing well.*

Bjarne Stroustrup (Martin 2009)

We will come to define the scope of what one can do to make code better, which will make Michael’s statement more actionable.  However, the essence is clear, when code is clean it isn’t obvious how to improve it, there are no to do statements, or bits to fix up later.  It wouldn’t be easy for someone to come and make it easier to understand.  How we can achieve such code, without implementing everything from the start, is possible and the aim of this course is to show you how.
Why write clean code

It may not at first be obvious why we should treat our code like a work of art, carefully refactoring functions and worrying about variable names.  In the statistical world code is often written in a rush, with the focus being on the data, the insights and not how we got there.  When a business is focused on analytics, it is not the software that their customers care about, it is the insights.  The same can be seen in the research world, where results are the priority and the code takes a back seat.

This approach is all and well for the first draft of a paper, or the initial processing of a data set.  It works particularly well when you know what you are aiming for at the start, get your results, and move on (and if you're lucky, your code didn’t contain any bugs hiding somewhere in a 200 line long function).  However, as we all know, these situations are rare.

Clean code is maintainable.  How many times have you written a process and decided you were missing a dimension to your analysis, or suddenly the scope has changed and you need to apply the same analysis to every one of the last ten years?  How many times have you ended up copying and pasting a function, just to change a few lines?  Agile software development is based on writing code that meets the requirements, and doesn’t over deliver, while allowing for iterative improvements based on changing requirements.  This is the mindset we need when writing code.  Write your code like you will be changing it tomorrow, because chances are, you will be.  Clean code is easy to change, it is adaptable and reusable.

Clean code can be understood by others.  When working with someone else's code, or your own code that you no longer remember writing, how much time do you spend understanding what it does?  How much time is spent scrolling up and down, trying to understand what the difference between “data_1” and “data_5” is?  Or what the third nested IF statement is really trying to achieve.  Good clean code can be read like a book, it has a narrative and can be understood quickly.

Clean code is much more likely to be bug free.  When your code can be understood and maintained, it is much less likely to contain bugs.  If you can read the narrative of a function, it is easy to spot when the logic does not follow.  However, if the author’s intentions were not clear, then it is much more difficult to tell if their logic is correct, or simply a typo.

Clean code has unit tests.  The obvious advantage of unit testing code is that we can be more confident it is doing what we intended, both before and after making changes.  Unit tests allow us to make changes faster without worrying about breaking existing functionality.  Another advantage of unit testing is that it encourages the author to break the code down into small functions, which do one thing well, as unit testing anything else is always going to be difficult.

The final and most important reason for keeping code clean is to avoid technical debt.  The productivity team is severely impacted by hard to maintain code.  When making a simple change requires modifying dozens of different functions, a trivial change can take hours or days.  The potential bugs introduced by any change are also numerous, making the developers extremely hesitant to change anything in fear of introducing new issues.  Clean code takes more effort up front, but unless you intend on never touching that code again, it is always worth the time.

## Formatting

Formatting is one of the easiest ways to make your code look professional.  Well formatted code is also much easier to read, and achieves the goal of making it look like the author really cares.

Consider the following code I wrote which takes a response from an API request and checks that the type is as expected, and that the response code is 200.  While there are improvements that can be made to this function, it is at least formatted nicely.

```python
parse_httr_response <- function(response) {
  if (http_type(response) != "application/json") {
    warning("request did not return json")
    return(NULL)
  }
  if (status_code(response) != 200) {
    warning(
      paste(
        "request failed with response code",
        status_code(response)
      )
    )
    return(NULL)
  }
  result <- jsonlite::fromJSON(
    content(response, "text", encoding = "UTF-8"),
    simplifyDataFrame = TRUE
  )
  return(result)
}
```



Compare this with the following version of the same code.

```python
parse_httr_response <-function(response){
if (http_type(response)!= "application/json"){
warning("request did not return json")


   return(NULL)}
  if (status_code(response)!= 200) {
    warning(paste("request failed with response code", status_code(response)))
    return(NULL)
  }
  result <- jsonlite::fromJSON(content(response, "text", encoding = "UTF-8"), simplifyDataFrame =TRUE


  )
  return (result)}
```

This example might seem extreme, but I regularly see code written like this, and was once guilty of doing it myself.  While formatting has no impact on the actual operation (it’s all the same to the computer), it has a profound impact on the ability of others to read your code, find bugs, and for it to be maintained - let alone your professional reputation!

Formatting is achieved by following a set of rules that a team agrees upon.  These rules are generally based around the same concepts of horizontal and vertical spacing, spacing around operators, line lengths and file lengths.  We will discuss naming conventions and comments later, as they deserve their own chapter.

Like most languages there is a widely agreed upon standard for R code.  It is best to follow standards that mean others can come from outside your team and understand your code, and work with it without having to get used to new styles (and change old habits).  The Tidyverse style guide is widely accepted.  The Google style guide is an extension of the Tidyverse one with some modifications, some of which, such as explicit return statements, are worth taking on.

Style guides also give details on how to name functions and objects, we will deal with this in a later chapter.

### White space
Before beginning a discussion on formatting the first order of business is to set your editor to show white space, and set a vertical rule to define your intended line length limit.

RStudio also makes it possible to set an option for removing trailing white space whenever you save a file.  This is immensely useful, and can be set both the project and global level.  This should be set by default, but unfortunately it is not.

### Basic formatting conventions

The following basic rules apply whatever language you are using and you should have a good case if not following them.
Be consistent with your style.
No trailing white space (this is white space characters at the end of a line or on an empty line).
Do not use more than one empty line to create vertical space.
Put white space around all operators (=, /, + ).  Some conventions allow no white space when used within function arguments but we will not use this approach in R.
Use indentation appropriately.
Keep line lengths under some sensible limit.

### Indentation

Indentation is one of the key ways to improve the readability of code.  There are various different standards for indentation, how many spaces to use, tabs versus spaces and how to apply indentation in different circumstances.

The standard in R is 2 spaces (not tabs).  This can be set in the RStudio global options.  The listing above gives an example of indentation within a function and within IF statements.

### Line length

The Tidyverse style guide recommends a limit of 80, I currently have mine set to 100 and find that a reasonable width.

Setting an upper limit on line length can help you to identify overly complex pieces of code and make your code easier to read.  If you have a long expression, consider breaking it down into steps.  If your function call has too many arguments, consider passing them via a list instead.

In many cases it is not easy to break a line down further, so we need to split the expression over multiple lines to fit under our upper bound.  In Listing 1 above we split long lines a couple of places, this is achieved using indentation.

### White space

There are various rules for white space around brackets, after commas and around operators.

### Naming

As a programmer we are constantly choosing names.  Variables, functions, classes and files all require names that are often thought up quickly.  In many cases we don’t choose the best name, either because we didn’t properly anticipate what the name would end up representing (once we had finished writing our code) or were just sloopy and picked a name that was too generic.

Code is constantly evolving, so should names
One of the common issues with names is that they become out of date.  Often we see functions that have a name which doesn’t represent that actual behaviour.  Perhaps more functionality has been added (in which case this likely violates our idealistic case of a function doing only one thing - but that’s another story), or the original functionality has substantially changed.

In other cases a variable name may have been appropriate when first chosen, but over time the code has changed and it no longer represents what the object assigned to it actually is.

There is also the case of poorly chosen names in the first place.  In all of these cases you should feel free to rename.  Often we are afraid to modify existing code, but there are tools to ensure you do not introduce an error, and in theory your unit tests will ensure the code still functions.


## Functions

One of the key rules to follow when writing clean code is: don’t repeat yourself.  Functions make it possible to achieve this.



Functions should be:
* Small
* Do one thing
* Have no more than three arguments
* Have no side effects
* One level of abstraction per function.


### One level of abstraction per function

This is a hard rule to follow.  It means keeping everything in your function at the same level.  This means we don’t want things at a very high level of abstraction, such as run_entire_module() combined with a function like filename <- paste0(directory, path).  One is at the lowest level of abstraction (well, you could write a function that took the directory and the path, but that would be a bit redundant), and one is very high level (it contains a lot of logic, and likely more functions within it).

Reading code from top to bottom: the Step Down Rule

We want the code to read like a top-down narrative.  So it should read as a set of TO paragraphs, each of which is describing the current level of abstraction and referencing subsequent TO paragraphs at the next level down.

In the get_census_data example we have the following:

To get the most common occupation, we load the data from the file, then we get the most common row by count.

To load the data from a file we read from csv.


## Comments

**_Comments mean I have to read everything twice._**

Comments are added with the best intentions but are hardly ever the right thing to do.  To quote Robert Martin’s Clean Code:

The proper use of comments is to compensate for our failure to express ourself in code… Comments are always failures. We must have them because we cannot always figure out how to express ourselves without them, but their use is not a cause for celebration.

This might seem a bit over the top, but he has a fair point.  In this chapter we will explore good and bad comments and demonstrate how to replace a comment with a well written piece of code.
The aim of commenting can be summarised well in this quote:

*"Code tells you how; Comments tell you why."*
— Jeff Atwood (aka Coding Horror)

Comments are intended for developers or maintainers of your code.

Documentation is not commenting.  Documentation is intended to describe the use and functionality to the users of your code.  It’s not necessarily intended for developers or maintainers of your code, but the end users.

### Good comments

### Informative comments
There are some cases where it is simply not possible to make the code any clearer.  In these cases.

Here is an example from my own code that could have done with a comment:
```python
some_variable_clean <- gsub(
  "\\s*\\([^\\)]+\\)",
  "",
  some_variable
)
```
This isn’t immediately clear what the regex is doing.  It might be worth adding a comment:

```python
# remove any text within rounded brackets
some_variable_clean <- gsub(
  "\\s*\\([^\\)]+\\)",
  "",
  some_variable
)
```

### Explanatory comments

### Bad comments


## Best practice in using R for data analysis and processing

Don’t set the working directory.

Use projects.

Use version control.

Don’t use more packages than you need, remove any redundant references.


https://github.com/czeildi/erum-2018-clean-r-code/blob/infra/clean_r_code_cheatsheet_2018-05-08.pdf

## Unit tests
Testing is an important part of the software development process.  Tests enable us to make changes and refactor our code with confidence that we are not changing the intended functionality of the code.

Testable code is often better code.  Tests help us find bugs during the development process and properly define what we intend a function to do.

What do we mean by unit tests?  Unit tests are designed to test a small part of code (or unit) in isolation.  This unit should be a method (function) or basic functionality of a class.  With well written functions that do only one thing, the unit tests as a result only test one behaviour.

Test driven development (TDD) has become a popular methodology in software development.  To practice TDD properly one should be writing tests, then writing code, then writing more tests, with a very high frequency cycle.

### Three laws of TDD

* You may not write production code until you have written a failing unit test.
* You may not write more of a unit test than is sufficient to fail, and not compiling is failing.
* You may not write more production than is sufficient to pass the currently failing test.

By following these rules we end up in a very short cycle. The tests are written along with the code.

Following proper TDD will result in thousands of unit tests. This base of unit test code can become just as out of control as the production code itself, so we need to follow best practice to build and maintain this large library of code.

## The case for keeping tests clean

It can be easy to write quick tests, not worrying about the quality of the unit test code. If the tests pass, and the function does as expected then there may be no desire to refine it.  However, unit tests must change as the production code changes.  Eventually a small change in the code can result in a complicated task of making the unit tests pass, to the point where tests get deleted or the whole process turned off completely.  If tests are not clean there may be little point in having them in the first place.

It may seem like unit tests make it harder to change your production code.  Every little change results in a test having to change, which seems like more work?  However, without the tests, making change is far more difficult.  How do you ensure that you haven’t broken anything, and that the system does as expected?  Without tests every change is a possible bug, so once code is in production, there can be very low confidence to make a change without creating a bug.

What makes a clean test?  Readability.  This is achieved through clarity, simplicity and density of expression.  The same principles of no duplication, sensible naming, the use of functions and doing one thing well all apply to writing test code.

Tests need to be:

* Fast - run quickly.
* Independent - not depend on each other.  No set up between tests.  Can run in any order.
* Repeatable - same in any environment.  They should work in all environments, no special cases where they can not pass.
* Self-Validating - They return a pass or fail.  There is no manual work to read through log files or compare outputs to establish if the test passed or not.
* Timely - Tests should be written in a timely fashion.  They should be written just before the production code that makes them pass.  Writing tests after writting production code will often show that your production code is hard to test.


## Refactoring basics

###Remove magic numbers
This refactoring is one of the easiest to implement but can have a huge impact on code readability and maintainability. Consider the line of code below.

converted_date = as.Date(input_date, origin = "1970-01-01")


Now this can be written as
```python
REFERENCE_DATE = "1970-01-01"

converted_date = as.Date(input_date, origin = REFERENCE_DATE)
```

This can become particularly relevant with constants that are irrational numbers, where mistakes can be made in entering them, or different levels of precision used in different places.
```python
volume = (4/3) * 3.141592654 * radius
```

The above line of code is much clearer as follows.

```python
# header or configuration file
PI = 3.141592654

# function body
volume = (4/3) * PI * radius
```

We could take this further and include the factor of (4/3) in the constant definition.  However, in most cases we would actually pull pi from a standard library (in R for example, “pi” is a predefined variable), and the factor of 4/3 is well known enough in this particular expression.

## Extract into function

Extracting code into functions is generally the first step in a refactoring process.  Functions will enable us to avoid duplication of code and make higher level functions more readable.

Functions do not have to be used to reduce duplication.  In many cases your function will only be used once.

In a long method functions can be used to extract related parts of the logic, such that the method can be read without the reader having to understand every line of code.

Consider the following function which downloads a zip file with data, unzips it, reads it in and returns the row with the most common occupation (the highest value of count).

```python
dir.create(file.path(".", "data"), showWarnings = FALSE)
download.file(
paste0(
   "https://www.stats.govt.nz/assets/Uploads/2018-Census-totals-by-topic/",
   "Download-data/2018-census-totals-by-topic-national-highlights-csv.zip"
),
    "./data/file.zip"
)
unzip("./data/file.zip",exdir = "./data")

data <- read.csv(
    "data/occupation-2018-census-csv.csv",
    stringsAsFactors = F,
    col.names = c("code", "occupation", "count")
  )

index <- which(data$count == max(occupation_data$count))
return(data[index,])
```


The same method with functions used to abstract out the related parts of logic.

```python
download_data()
data <- load_data_from_file(
  "data/years-at-usual-residence-2018-census-csv.csv",
  c("code","years_at","count")
)

return (get_most_common_row_by_count(data))
```


In this example the reader can now focus on the code that is relevant.  If they are not interested in how the inputs are loaded, then this can be skipped over, with the implementation carried out in function.  The functions required are:

```python
download_data <- function() {
  dir.create(file.path(".", "data"), showWarnings = FALSE)
  download.file(
    paste0(
   "https://www.stats.govt.nz/assets/Uploads/2018-Census-totals-by-topic/",
    "Download-data/2018-census-totals-by-topic-national-highlights-csv.zip"
    ),
     "./data/file.zip"
  )
  unzip("./data/file.zip",exdir = "./data")
}

load_data_from_file <- function(filename, col_names) {
  data <- read.csv(
    filename,
    stringsAsFactors = F,
    col.names = col_names
  )
  return(data)
}

get_most_common_row_by_count <- function(data) {
  index <- which(data$count == max(data$count))
  return(data[index,])
}
```


We can effectively use functions instead of comments.  In this case there is no need to write comments in the script to explain what is happening, as the names of the functions make this clear.

It is not always possible to immediately split out code into functions like in the example above.  This may be due to variables being used across a number of lines, tangled logic between various parts of the method, or repeated logic that is not generic enough to make an obvious function from. In these cases start by moving the code around into parts that are related, this may require renaming variables and shifting logic around, until it becomes clear how it can be split apart.
Remove flag argument
Flag arguments are often found in functions like the following:
```python
do_something <- function(x, y, flag) {
  if (flag = True) {
    return x * y
  } else {
    return x + y
  }
}
```

This can create a number of problems, naming the function being one of them.  It’s difficult to refactor this function further, it has an additional parameter and isn’t clear what it is doing.  Much better is to split it into two functions as below.

```python
add_numbers <- function(x, y) {
    return x + y
}


multiply_numbers <- function(x, y) {
    return x * y
}
```

### Code reviews and quality assurance
In an agile team code reviews and the quality assurance (QA) process are an important part of the software development lifecycle.  Code reviews help developers share knowledge about a code base, maintain consistency between coding style and practices, and uphold a level of discipline that is difficult to do when programming alone.

In this chapter we will discuss some guidelines to follow when conducting a code review, and some steps that should be followed when performing QA on a piece of software.

### Sizing

The code review and QA process will usually occur when a developer (or team) has finished work on a particular piece of functionality, this may be aligned with a “task”, “user story” or “bug”.  The code would generally represent a few days' work, and should not be on the scale of a large feature with thousands of lines of code.  However, in most cases the work submitted for review should be “finished” in that it can be merged into the current development branch, and staged for release.

## The aim of a code review
The code review is intended to improve the quality of the submitted code.  Quality can include test coverage, correctness, style, design, and performance.  We list these and other things to check in a list below.

As a developer it is easy to miss things when focusing on a particular problem.  It is also possible to over-engineer a piece of work, especially if we know it is going straight into production.  The code review gives us a formal process for ensuring our code meets the standards we require as a team, while still being able to move quickly with confidence.

### Code review checklist
The following is a list of items to check during a code review.  The items in this list won’t apply in every situation, but it gives an idea of what to look out for when reviewing code.


* Correctness, is the algorithm doing what was intended?
* Formatting.
* Style, does the code follow your team’s agreed upon standards?  Could the function and variable names be clearer?
* Design
* Does the code follow best practice?
* Is there a better or more elegant way to code the same algorithm?
* Is the code overly complicated?
* Is there an obvious refactoring that could be done to make it easier to maintain?
* Performance, is the code efficient?


### How much is too much
The code review process does not have to be an exhaustive exercise in finding fault in your colleagues work. It is a process used to iteratively improve the code, and to share knowledge and skills within a team. The code review process can be an opportunity to learn from others, and share your input into how to solve a problem.

It is always worth remembering that hindsight can be valuable when developing a system, and that your colleague may also appreciate that there would have been better ways to develop something after the fact. Do not always insist that something be changed, instead offering suggestions or optional modifications, unless it is simply not correct or a security risk.

If you see the same error repeated many times, such as a formatting issue, then only point this out a few times or make a general observation. There is no need to comment on every single missing space, or unusual variable name; give your colleague the opportunity to fix the rest on their own, this will also save your own time.





