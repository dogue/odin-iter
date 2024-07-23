package iter

import "core:fmt"

Iterator :: struct($T: typeid) {
    data:  []T,
    index: int,
}

Window_Iterator :: struct($T: typeid) {
    using iter:  Iterator(T),
    window_size: int,
}

Step_Iterator :: struct($T: typeid) {
    using iter: Iterator(T),
    step_by:    int,
}

iter_init :: proc(data: []$T) -> Iterator(T) {
    iter := Iterator(T) {
        data  = data[:],
        index = 0,
    }
    return iter
}

iter_init_window :: proc(data: []$T, window_size: int) -> Window_Iterator(T) {
    iter := Window_Iterator(T) {
        iter        = iter_init(data),
        window_size = window_size,
    }
    return iter
}

iter_init_step :: proc(data: []$T, step_by: int) -> Step_Iterator(T) {
    iter := Step_Iterator(T) {
        iter    = iter_init(data),
        step_by = step_by,
    }
    return iter
}

iter_next :: proc {
    iter_next_single,
    iter_next_window,
    iter_next_step,
}

iter_next_single :: proc(it: ^Iterator($T)) -> (elem: T, ok: bool) {
    if it.index >= len(it.data) {
        return {}, false
    }

    elem = it.data[it.index]
    it.index += 1
    ok = true
    return
}

iter_next_window :: proc(it: ^Window_Iterator($T)) -> (elems: []T, ok: bool) {
    if it.index + (it.window_size - 1) >= len(it.data) {
        return {}, false
    }

    elems = it.data[it.index:][:it.window_size]
    it.index += 1
    ok = true
    return
}

iter_next_step :: proc(it: ^Step_Iterator($T)) -> (elem: T, ok: bool) {
    if it.index + it.step_by >= len(it.data) {
        return {}, false
    }

    elem = it.data[it.index]
    it.index += it.step_by
    ok = true
    return
}

main :: proc() {
    numbers := []int{0, 1, 2, 3, 4, 5}
    it := iter_init_window(numbers, 3)

    for elem, ok := iter_next(&it); ok; elem, ok = iter_next(&it) {
        fmt.printf("%v\n", elem)
    }
}
