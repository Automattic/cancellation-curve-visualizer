# This script generates the data in data/example.csv

# We'll use the same unix timestamp for all of these
# because it doesn't matter for the fake data
kUnixTimestamp <- 1451606400

kDataPoints <- 20000
kSecondsPerDay <- 86400

kCancellationRate <- 0.20
kPlans <- list( gold = 0.3, silver = 0.2, bronze = 0.1 )
kPlanNames <- names( kPlans )
kMaxDays <- 365

subscribed_at <- rep( kUnixTimestamp, kDataPoints )
fake.data <- data.frame( subscribed_at )
fake.data$segment.name <- sample( kPlanNames, kDataPoints, replace = TRUE )

# See: http://imgur.com/gallery/AfgkjCf
fake.data$lifetime <- round( replicate( kDataPoints, rlnorm( 1 ) * kSecondsPerDay * runif( 1, 0, 100 ) ) )

for ( plan.name in kPlanNames ) {
	plan.cancellation.rate <- kPlans[[ plan.name ]]
	plan.indeces <- which( fake.data$segment.name == plan.name )
	plans.to.retain <- round( nrow( subset( fake.data, segment.name == plan.name ) ) * ( 1 - plan.cancellation.rate ) )
	fake.data[ sample( plan.indeces, plans.to.retain ), ]$lifetime = NA
}

fake.data$cancelled_at <- fake.data$subscribed_at + fake.data$lifetime

fake.data <- subset( fake.data, is.na(lifetime) | lifetime <= kMaxDays * kSecondsPerDay )

fake.data <- fake.data[, c("subscribed_at", "cancelled_at", "segment.name")]

write.table( fake.data, "data/example.csv", col.names = FALSE, row.names = FALSE, na = "", sep = ",", quote = FALSE )
