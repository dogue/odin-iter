package iter

import "base:intrinsics"

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

iter_init :: proc(data: []$T, start_index := 0) -> Iterator(T) {
    iter := Iterator(T) {
        data  = data[:],
        index = start_index,
    }
    return iter
}

iter_init_window :: proc(data: []$T, window_size: int, start_index := 0) -> Window_Iterator(T) {
    iter := Window_Iterator(T) {
        iter        = iter_init(data, start_index),
        window_size = window_size,
    }
    return iter
}

iter_init_step :: proc(data: []$T, step_by: int, start_index := 0) -> Step_Iterator(T) {
    iter := Step_Iterator(T) {
        iter    = iter_init(data, start_index),
        step_by = step_by,
    }
    return iter
}

iter_reset :: proc(it: ^$T) where intrinsics.type_is_subtype_of(T, Iterator) {
    it.iter.index = 0
}

iter_next :: proc {
    iter_next_single,
    iter_next_window,
    iter_next_step,
}

iter_prev :: proc {
    iter_prev_single,
    iter_prev_window,
    iter_prev_step,
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
    if it.index + it.step_by > len(it.data) {
        return {}, false
    }

    elem = it.data[it.index]
    it.index += it.step_by
    ok = true
    return
}

iter_prev_single :: proc(it: ^Iterator($T)) -> (elem: T, ok: bool) {
    if it.index < 0 {
        it.index = 0
        return {}, false
    }

    elem = it.data[it.index]
    it.index -= 1
    ok = true
    return elem, ok
}

iter_prev_window :: proc(it: ^Window_Iterator($T)) -> (elems: []T, ok: bool) {
    if it.index < 0 {
        it.index = 0
        return {}, false
    }

    if it.index + (it.window_size - 1) >= len(it.data) {
        it.index = len(it.data) - it.window_size
    }

    elems = it.data[it.index:][:it.window_size]
    it.index -= 1
    ok = true
    return elems, ok
}

iter_prev_step :: proc(it: ^Step_Iterator($T)) -> (elem: T, ok: bool) {
    if it.index < 0 {
        it.index = 0
        return {}, false
    }

    elem = it.data[it.index]
    it.index -= it.step_by
    ok = true
    return elem, ok
}
