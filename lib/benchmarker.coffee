
HRTimeStats = require('./hrtimestats')

class Benchmarker
	constructor: (@fn, @ntimes=50) ->
		@runs = []
		@stats = null

	runFullTest: (done) ->

		@runs = []
		numCompleted = 0

		onRunCompleted = (runTime) =>
			# console.log "t: #{ runTime }"
			@runs.push(runTime)
			numCompleted++
			if numCompleted == @ntimes
				@calculateStats()
				done(@runs)

		for i in [0...@ntimes]
			@doSingleRun(onRunCompleted)

	doSingleRun: (callback) ->
		# get time with nanosecond resolution
		start = process.hrtime()

		# callback for async benchmarks
		done = () ->
			runTime = process.hrtime(start)
			callback(runTime)

		@fn(done)

	calculateStats: () ->
		@stats = new HRTimeStats(@runs)

	printSummary: () ->
		console.log "Num runs: #{ @ntimes }"
		if @stats?
			@stats.printSummary()

module.exports = Benchmarker

if require.main == module

	testFn = (done) ->
		x = 0
		for i in [0...10000000]
			x = x + 2 / 5 * 3
		done()

	b = new Benchmarker(testFn, 50)
	b.runFullTest (results) ->
		b.printSummary()
