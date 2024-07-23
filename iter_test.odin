package iter

import "core:testing"

@(test)
test_iter_next_single :: proc(t: ^testing.T) {
    it := iter_init([]int{0, 1, 2, 3, 4, 5})
    expected := []int{0, 1, 2, 3, 4, 5}

    i := 0
    for n, ok := iter_next(&it); ok; n, ok = iter_next(&it) {
        testing.expect_value(t, n, expected[i])
        i += 1
    }
}

@(test)
test_iter_next_window :: proc(t: ^testing.T) {
    it := iter_init_window([]int{0, 1, 2, 3, 4, 5}, 3)
    expected := [][]int{{0, 1, 2}, {1, 2, 3}, {2, 3, 4}, {3, 4, 5}}

    i := 0
    for n, ok := iter_next(&it); ok; n, ok = iter_next(&it) {
        testing.expect_value(t, n[0], expected[i][0])
        testing.expect_value(t, n[1], expected[i][1])
        testing.expect_value(t, n[2], expected[i][2])
        i += 1
    }
}

@(test)
test_iter_next_step :: proc(t: ^testing.T) {
    it := iter_init_step([]int{0, 1, 2, 3, 4, 5}, 2)
    expected := []int{0, 2, 4}

    i := 0
    for n, ok := iter_next(&it); ok; n, ok = iter_next(&it) {
        testing.expect_value(t, n, expected[i])
        i += 1
    }
}
