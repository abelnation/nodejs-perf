
require('coffee-script/register')

Promise = require('bluebird')
Benchmarker = require('./lib/benchmarker')

NUM_RUNS = 50
RUN_PARALLEL = false

async01 = (callback) ->
	# do work in separate stack
	setImmediate () ->
		x = 0
		for i in [0...10000000]
			x = x + 2 / 5 * 3
		callback(null, x)

async01_p = Promise.promisify(async01)

async02 = (callback) ->
	# do work in separate stack
	setImmediate () ->
		x = 0
		for i in [0...10000000]
			x = x + 2 / 5 * 3
		callback(null, x)

async02_p = Promise.promisify(async02)

runBluebirdTest = (callback) ->
	console.log ""
	console.log "Bluebird Test"

	testFn = (done) ->
		async01_p().then (x) ->
			# console.log "async01 x: #{ x }"
			return async02_p()
		.then (x) ->
			# console.log "async02 x: #{ x }"
			done()
		.catch (err) ->
			console.log "error: #{ err }"
			done()

	b = new Benchmarker(testFn, NUM_RUNS, RUN_PARALLEL)
	b.runFullTest (results) ->
		b.printSummary()
		callback()

runBluebirdLazyPromisifyTest = (callback) ->
	console.log ""
	console.log "Bluebird Lazy Promisify Test"

	testFn = (done) ->
		Promise.promisify(async01)().then (x) ->
			# console.log "async01 x: #{ x }"
			return Promise.promisify(async02)()
		.then (x) ->
			# console.log "async02 x: #{ x }"
			done()
		.catch (err) ->
			console.log "error: #{ err }"
			done()

	b = new Benchmarker(testFn, NUM_RUNS, RUN_PARALLEL)
	b.runFullTest (results) ->
		b.printSummary()
		callback()

runVanillaTest = (callback) ->
	console.log ""
	console.log "Vanilla Test"

	testFn = (done) ->
		async01 (err, x) ->
			# console.log "async01 x: #{ x }"
			async02 (err, x) ->
				# console.log "async02 x: #{ x }"
				done()

	b = new Benchmarker(testFn, NUM_RUNS, RUN_PARALLEL)
	b.runFullTest (results) ->
		b.printSummary()
		callback()

tests = [
	runBluebirdTest,
	runBluebirdLazyPromisifyTest,
	runVanillaTest
]

main = () ->
	testNum = parseInt(process.argv[2], 10)
	testNum ?= 0
	test = tests[testNum]

	test () ->
		console.log "Done"
		process.exit(0)

main()