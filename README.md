# Cancellation Curve Visualizer

This R script helps you visualize when users cancel their plans in a SaaS product.

For example, here are the cancellation curves for an example SaaS product with three plans, Gold, Silver, and Bronze:

![Cancellation Curve Example](images/example.png)

This shows is that most users who cancel do so pretty quickly and that long term about 30% of Gold plans, 20% of Silver plans, and 10% of Bronze plans cancel their subscription.

# How to run

If you've never used R before, you'll need to [install R](https://cran.r-project.org/mirrors.html) and optionally download a tool like [RStudio](https://www.rstudio.com/products/rstudio/download/) to run this script. You'll also need to install the `ggplot2` package with `install.packages("ggplot2")` and use `setwd()` to change the working directory to match the location of this script.

## How it works

In order for it to work, all you need to do is to generate a CSV file containing three columns:

1. The unix timestamp when people purchased a plan
2. The unix timestamp when people cancelled the plan (or blank if it hasn't been cancelled)
3. The name of the plan

You should not include column headers.

Here's an example:

```
1451606400,1453359994,gold
1451606400,,gold
1451606400,,gold
1451606400,,silver
1451606400,,silver
1451606400,1455394199,silver
```

The provided `data/example.csv` contains a test dataset that you can use to test the script.

You'll need to edit the `file` variable at the top of `cancellation-curve.r` based on the name and location of your actual data file.

## Testing the script

Within RStudio, simply load the script using `source("cancellation-curve.r")`.

If all went well, it should generate the chart above.

## Contact

If you have any suggestions, find a bug, or just want to say hey drop me a note at [@mhmazur](https://twitter.com/mhmazur) on Twitter or by email at matthew.h.mazur@gmail.com.

## License

MIT © [Matt Mazur](http://mattmazur.com)
