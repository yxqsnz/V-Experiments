module main

import gg
import gx
import time
import math

const (
	forcey = 200
	forcex = 200
)

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
		bg_color: gx.black
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

	ca, cb := f64(size.width / 2), f64(size.height / 2)

	mut a, mut b := ca, cb
	mut a2, mut b2 := ca, cb

	a += forcex * math.sin(speed)
	b += forcey * math.cos(speed)
	a2 += forcex * -math.sin(speed)
	b2 += forcey * -math.cos(speed)

	ctx.begin()

	ctx.show_fps()

	ctx.draw_circle_filled(f32(a2), f32(b2), 100, gx.white)
	ctx.draw_circle_filled(f32(a), f32(b), 100, gx.pink)

	cfg := gx.TextCfg{
		color: gx.pink
		size: 20
	}

	ctx.draw_text(0, 30, 'Delta: ${game.delta_time}', cfg)
	ctx.draw_text(0, 50, 'Total Delta: ${game.total_delta_time}', cfg)
	ctx.draw_text(0, 70, 'Pos (x, y; x, y): ${a} ${b}; ${a2} ${b2}', cfg)
	ctx.end()

	finished := sw.elapsed().seconds()
	game.delta_time = 0.5 * math.pi * finished
	game.total_delta_time += game.delta_time
}
