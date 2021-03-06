if typeof require is 'function'
  buster = require 'buster'
  pp     = require '../lib/pp'

buster.testCase 'pp.iterator',
  'iteration': ->
    currentValue = '0'
    iter = pp.iterator [
      ->
        currentValue = '1st'
        return
      ->
        currentValue = '2nd'
        return
      ->
        currentValue = '3rd'
        return
      ->
        currentValue = '4th'
        return
    ]
    iter2 = iter()
    assert.same currentValue, '1st'

    iter3 = iter2()
    assert.same currentValue, '2nd'

    iter4 = iter3()
    assert.same currentValue, '3rd'

    iter4()
    assert.same currentValue, '4th'

    iter1n = iter.next()
    iter1n()
    assert.same currentValue, '2nd'

buster.testCase 'pp.waterfall',
  'waterfall multiple tasks': (done) ->
    pp.waterfall [
      (next) -> next null, 1
      (next, v) ->
        assert.same v, 1
        next null, v * 2, v
      (next, v1, v2) ->
        assert.same v1, 2
        assert.same v2, 1
        next null, v1 + v2, v1 * 2, v2 * 5
      (next, v1, v2, v3) ->
        assert.same v1, 3
        assert.same v2, 4
        assert.same v3, 5
        next null, v1 + v2 + v3
    ], (error, result) ->
      assert.isNull error
      assert.same result, 12
      done()

