file <- "data/example.csv"

kSecondsPerDay <- 86400

data <- read.csv( file,
	col.names = c( "subscribed_at", "cancelled_at", "segment.name" ) )
data$lifetime = ceiling( ( data$cancelled_at - data$subscribed_at )
	/ kSecondsPerDay )

# We'll analyze each of the segments individually and then add the
# results to this data frame for charting purposes
segments.df <- data.frame(
	segment = numeric( 0 ),
	days = numeric( 0 ),
	cancellation.rate = numeric( 0 ) )

for ( segment in unique( data$segment ) ) {
	segmented.data <- subset( data, segment.name == segment )
	cancellation.data <- segmented.data[ !is.na( segmented.data$cancelled_at ), ]

	# If there haven't been any cancellations for this segment, skip charting it
	if ( nrow( cancellation.data ) == 0 ) {
		next
	}

	initial.subscribers = length( is.na( segmented.data$cancelled_at ) )

	days <- c( 0 )
	cancelled <- c( 0 )
	remaining <- c ( initial.subscribers )

	# Calculation the cumulative cancellation rate each day
	for ( n in 1:max( cancellation.data$lifetime ) ) {
		days <- c( days, n )

		# We don't actually need all this data to generate the chart, but add
		# it to the segment's data frame anyway in case you want to inspect the
		# raw data to gain insights beyond what you get from the chart
		total.cancelled <- nrow( subset( cancellation.data, lifetime <= n ) )
		total.remaining <- initial.subscribers - total.cancelled
		cancelled <- c( cancelled, total.cancelled )
		remaining <- c( remaining, total.remaining )
	}

	plan.df <- data.frame( segment, days, cancelled, remaining )
	plan.df$cancellation.rate <- round( ( plan.df$cancelled /
		initial.subscribers ) * 100 )

	# For the chart, we only need a few columns
	segments.df <- rbind( segments.df, subset( plan.df,
		select = c( segment, days, cancellation.rate ) ) )
}

# Generate the cancellation curve
g <- ggplot( segments.df,
	aes( x = days, y = cancellation.rate, group = segment, color = segment ) )
g <- g + geom_line( size = 2 )
g <- g + ggtitle( "Cancellation Curve" )
g <- g + theme( plot.title = element_text( lineheight = 1.2, face = "bold",
	size = rel( 1.5 ) ) )
g <- g + theme( axis.ticks = element_blank() )
g <- g + theme( plot.background = element_rect( fill = "#F6F8FA" ) )
g <- g + theme( panel.background = element_blank() )
g <- g + theme( panel.grid.major = element_line( color = "#DDDDDD",
	size = 0.2 ) )
g <- g + theme( legend.title = element_blank() )
g <- g + theme( legend.position = "bottom" )
g <- g + labs( x = "Days", y = "Cancellation Rate" )

print( g )
