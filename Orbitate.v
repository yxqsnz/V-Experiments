module main

import gg
import gx
import time
import math

struct Game {
mut:
	gg               &gg.Context = unsafe { nil }
	delta_time       f64
	total_delta_time f64
}

fn main() {
	mut game := &Game{
		delta_time: 0
		total_delta_time: 0
	}

	game.gg = gg.new_context(
		bg_color: gx.rgb(174, 198, 255)
		width: 600
		height: 400
		user_data: game
		window_title: 'Hello'
		frame_fn: frame
	)

	game.gg.run()
}

[live]
fn frame(mut game Game) {
	ctx := game.gg
	sw := time.new_stopwatch()
	size := ctx.window_size()

	speed := game.total_delta_time - game.delta_time

	mut a, mut b := f64(size.width / 2), f64(size.height / 2)
	a += 164 * math.sin(speed)
	b += 100 * math.cos(speed) 

	ctx.begin()

	ctx.show_fps()
	ctx.draw_circle_filled(f32(a), f32(b), 100, gx.red)
	ctx.draw_text_def(0, 30, "Delta: ${game.delta_time}")
	ctx.draw_text_def(0, 40, "Total Delta: ${game.total_delta_time}")


	ctx.end()

	finished := sw.elapsed().seconds()
	game.delta_time = 0.5 * math.pi * finished
	game.total_delta_time += game.delta_time
}
