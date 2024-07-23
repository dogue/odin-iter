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
test_iter_prev_single :: proc(t: ^testing.T) {
    it := iter_init([]int{0, 1, 2, 3, 4, 5}, 5)
    expected := []int{5, 4, 3, 2, 1, 0}

    i := 0
    for n, ok := iter_prev(&it); ok; n, ok = iter_prev(&it) {
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
test_iter_prev_window :: proc(t: ^testing.T) {
    it := iter_init_window([]int{0, 1, 2, 3, 4, 5}, 3, 5)
    expected := [][]int{{3, 4, 5}, {2, 3, 4}, {1, 2, 3}, {0, 1, 2}}

    i := 0
    for n, ok := iter_prev(&it); ok; n, ok = iter_prev(&it) {
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

@(test)
test_iter_prev_step :: proc(t: ^testing.T) {
    it := iter_init_step([]int{0, 1, 2, 3, 4, 5}, 2, 5)
    expected := []int{5, 3, 1}

    i := 0
    for n, ok := iter_prev(&it); ok; n, ok = iter_prev(&it) {
        testing.expect_value(t, n, expected[i])
        i += 1
    }
}
