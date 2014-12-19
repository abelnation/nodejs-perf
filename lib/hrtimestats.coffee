
Stats = require('fast-stats').Stats

class HRTimeStats
	constructor: (@hrtimes) ->
		@stats = new Stats()

		for time in @hrtimes
			ms = (time[0] * 1e3) + (time[1] * 1e-6)
			@stats.push(ms)

	printSummary: () ->
		console.log "Mean:   #{ @stats.amean().toFixed(3) }ms"
		console.log "Median: #{ @stats.median().toFixed(3) }ms"
		console.log "Range:  #{ @stats.range()[0].toFixed(3) }ms - #{ @stats.range()[1].toFixed(3) }ms"
		console.log "StdDev: #{ @stats.stddev().toFixed(3) }ms"
		console.log ''
		console.log 'Percentiles'
		console.log "20: #{ @stats.percentile(20).toFixed(3) }ms"
		console.log "40: #{ @stats.percentile(40).toFixed(3) }ms"
		console.log "60: #{ @stats.percentile(60).toFixed(3) }ms"
		console.log "80: #{ @stats.percentile(80).toFixed(3) }ms"

		@printBoxPlot()

	printBoxPlot: () ->
		[min, max] = @stats.range()
		median = @stats.median().toFixed(3)
		lowerQuart = @stats.percentile(25).toFixed(3)
		upperQuart = @stats.percentile(75).toFixed(3)

		console.log "#{ min }"
		console.log "#{ lowerQuart }"
		console.log "#{ median }"
		console.log "#{ upperQuart }"
		console.log "#{ max }"

module.exports = HRTimeStats

# plot = [
# 	' ┬ ',
# 	' │ ',
# 	' │ ',
# 	' │ ',
# 	' │ ',
# 	'┌┴┐',
# 	'│ │',
# 	'├─┤',
# 	'└┬┘',
# 	' │ ',
# 	' │ ',
# 	' │ ',
# 	' ┴ ',
# ]

# console.log plot.join('\n')