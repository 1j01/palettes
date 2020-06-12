
jump_sound = new Howl urls: ["sound/jump.wav"], volume: 0.1
pickup_sound = new Howl urls: ["sound/pickup.wav"], volume: 0.1
deposit_sound = new Howl urls: ["sound/deposit.wav"], volume: 0.01
triple_jump_unlocked_sound = new Howl urls: ["sound/triple-jump-unlocked.wav"], volume: 0.1
respawn_sound = new Howl urls: ["sound/respawn.wav"], volume: 0.1
drop_sound = new Howl urls: ["sound/drop.wav"], volume: 0.05
crumble_sound = new Howl urls: ["sound/crumble.wav"], volume: 0.5
enter_pipe_sound = new Howl urls: ["sound/enter-pipe.wav"], volume: 0.1
exit_pipe_sound = new Howl urls: ["sound/exit-pipe.wav"], volume: 0.3

keys = {}
addEventListener "keydown", (e)->
	console.log e.keyCode if e.altKey
	return if e.ctrlKey or e.altKey or e.metaKey
	return if e.target.tagName.match /input|button|select|textarea/i
	keys[e.keyCode] = on
	e.preventDefault() if e.keyCode in [32, 39, 38, 37, 40]
	switch e.keyCode
		when 82 # R
			restart_button.click()
		when 77 # M
			toggle_mute_button.click()
		when 70 # F
			fullscreen_button.click()

addEventListener "keyup", (e)->
	delete keys[e.keyCode]

class Column
	constructor: (@x, @y, @w, @h)->
		@rim_extension = 5
		@rim_height = 5
		
		@triggered = no
		@resetting = no
		@shaking = no
		@original_y = @y
		@fall_by = 0
		
		@signal = no
		@signaliness = 0
	
	step: ->
		shaking_prev = @shaking
		@shaking = no
		{player} = game.level
		
		if @resetting
			if @y > @original_y
				@y -= 1
				@shaking = yes
				if player.collision(player.x, player.y)
					player.y -= 1
				if player.collision(player.x, player.y)
					@y += 1
					@shaking = no
			else
				unless player.collision(player.x, player.y+1) is @
					@resetting = no
					@triggered = no
		else if @triggered
			if @y < @original_y + @fall_by
				if player.collision(player.x, player.y + 1) is @
					player.y += 1
				@y += 1
				@shaking = yes
			else
				@triggered = no
				setTimeout =>
					@resetting = yes
				, 2000
		
		if @shaking and not shaking_prev
			crumble_sound.play()
	
	draw: ->
		ctx.save()
		ctx.translate(@x, @y)
		
		ctx.strokeStyle = "black"
		ctx.lineWidth = 2 + @signaliness * 2
		ctx.fillStyle = @gradient ? "gray"
		
		@signaliness *= 0.9
		@signaliness = 1 if @signal
		
		ctx.beginPath()
		ctx.stroke()
		ctx.fill()
		ctx.beginPath()
		curve_length = 10
		ctx.moveTo(0, @h - @rim_height)
		ctx.lineTo(0, @rim_height + curve_length)
		ctx.quadraticCurveTo(0, @rim_height, -@rim_extension, @rim_height)
		ctx.lineTo(-@rim_extension, 0)
		ctx.lineTo(@w+@rim_extension, 0)
		ctx.lineTo(@w+@rim_extension, @rim_height)
		ctx.quadraticCurveTo(@w, @rim_extension, @w, @rim_height + curve_length)
		ctx.lineTo(@w, @h - @rim_height)
		ctx.stroke()
		ctx.fill()
		ctx.beginPath()
		ctx.rect(-1, @h-5, @w+2, 5)
		ctx.stroke()
		ctx.fill()
		ctx.beginPath()
		ctx.fillStyle = @top_gradient ? @gradient
		ctx.rect(-@rim_extension, 0, @w+@rim_extension*2, 5)
		ctx.stroke()
		ctx.fill()
		
		ctx.restore()
		
		@signal = no

class PinkColumn extends Column
	colors = ["rgb(119, 84, 83)", "rgb(139, 81, 85)", "rgb(170, 84, 92)", "rgb(199, 90, 104)", "rgb(211, 97, 124)", "rgb(219, 102, 139)", "rgb(211, 102, 138)", "rgb(217, 127, 164)", "rgb(222, 160, 188)", "rgb(231, 186, 206)", "rgb(229, 177, 202)", "rgb(220, 135, 171)", "rgb(205, 98, 133)", "rgb(189, 87, 114)", "rgb(194, 118, 141)", "rgb(235, 202, 214)", "rgb(247, 238, 241)", "rgb(233, 228, 229)", "rgb(232, 213, 221)", "rgb(234, 188, 207)", "rgb(233, 167, 193)", "rgb(223, 128, 164)", "rgb(207, 107, 136)", "rgb(181, 92, 114)", "rgb(211, 115, 149)", "rgb(218, 116, 153)", "rgb(211, 101, 130)", "rgb(199, 91, 107)", "rgb(178, 83, 92)", "rgb(134, 72, 78)", "rgb(118, 71, 73)", "rgb(157, 80, 90)"]
	
	gradient = ctx.createLinearGradient(0, 0, 120/3, 25/3)
	
	for color, i in colors
		gradient.addColorStop i/colors.length, color
	
	draw: ->
		ctx.save()
		ctx.translate(@x, @y)
		
		ctx.beginPath()
		ctx.rect(-@rim_extension, 0, @w+@rim_extension*2, 5) # top
		ctx.rect(-@rim_extension, @h-5, @w+@rim_extension*2, 5) # bottom
		mini_columns = 3
		for i in [0...mini_columns]
			ctx.rect(@w/(mini_columns-1)*(i-0.25), 0, @w/mini_columns/2+1, @h)
		
		ctx.fillStyle = gradient
		ctx.strokeStyle = "black"
		ctx.lineWidth = 2
		ctx.stroke()
		ctx.fill()
		
		ctx.restore()

class YellowColumn extends Column
	gradient = ctx.createLinearGradient(0.000, 150.000, 20, 150.000)

	gradient.addColorStop(0.000, 'rgba(255, 110, 2, 1.000)')
	gradient.addColorStop(0.083, 'rgba(255, 187, 0, 1.000)')
	gradient.addColorStop(0.223, 'rgba(255, 233, 0, 1.000)')
	gradient.addColorStop(0.495, 'rgba(255, 255, 0, 1.000)')
	gradient.addColorStop(0.748, 'rgba(255, 229, 0, 1.000)')
	gradient.addColorStop(0.901, 'rgba(255, 109, 0, 1.000)')
	gradient.addColorStop(1.000, 'rgba(127, 0, 0, 1.000)')

	top_gradient = ctx.createLinearGradient(-5, 150.000, 30, 150.000)

	top_gradient.addColorStop(0.000, 'rgba(255, 110, 2, 1.000)')
	top_gradient.addColorStop(0.083, 'rgba(255, 187, 0, 1.000)')
	top_gradient.addColorStop(0.223, 'rgba(255, 233, 0, 1.000)')
	top_gradient.addColorStop(0.495, 'rgba(255, 255, 0, 1.000)')
	top_gradient.addColorStop(0.748, 'rgba(255, 229, 0, 1.000)')
	top_gradient.addColorStop(0.901, 'rgba(255, 109, 0, 1.000)')
	top_gradient.addColorStop(1.000, 'rgba(127, 0, 0, 1.000)')
	
	gradient: gradient
	top_gradient: top_gradient
	
	constructor: (x, y, w, h)->
		super
		if random() < 0.6
			@fall_by = 20 + ~~(random() * 50)
			@fall_by = 0 if @y + @fall_by + 5 > game.level.bottom

class CheckpointColumn extends Column
	
	gradient = ctx.createLinearGradient(0.000, 150.000, 40, 150.000)
	
	gradient.addColorStop(0.000, 'rgba(0, 167, 175, 1.000)')
	gradient.addColorStop(0.271, 'rgba(0, 255, 33, 1.000)')
	gradient.addColorStop(0.477, 'rgba(167, 255, 104, 1.000)')
	gradient.addColorStop(0.851, '#00ffa5')
	gradient.addColorStop(1.000, 'rgba(0, 63, 127, 1.000)')
	
	gradient: gradient

class Player
	keys_previous = {}
	
	constructor: (@x, @y)->
		@w = 16
		@h = 32
		@vx = 0
		@vy = 0
		@gravity = 0.5
		@max_jumps = 2
		@jumps = @max_jumps
		
		@footing = null
		@previous_footing = null
		@entering_pipe = null
		
		@arm_angle = 0
		@arm_angle_2 = 0
		@leg_angle = 0
	
	step: ->
		move = (keys[39]? or keys[68]?) - (keys[37]? or keys[65]?)
		jump =
			(keys[38]? and not keys_previous[38]?) or
			(keys[87]? and not keys_previous[87]?) or
			(keys[32]? and not keys_previous[32]?)
		enter = (keys[40]? or keys[83]? or keys[13]?)
		
		keys_previous = {}
		keys_previous[k] = v for k, v of keys
		
		@footing = @collision(@x, @y + 1)
		
		@facing = move unless move is 0
		
		@vx += move
		
		if @footing
			@jumps = @max_jumps
		if jump
			if @jumps
				@jumps -= 1
				@vy = -9
				jump_sound.play()
		
		if @footing instanceof CheckpointColumn
			if @footing isnt @previous_footing
				@footing.signal = yes
			@checkpoint = @footing
			for gem in game.level.gems when gem.collected and not gem.deposited
				gem.vy -= 20
				gem.deposited = yes
				gem.deposited_to = @checkpoint
			
			if enter and not @entering_pipe
				@entering_pipe = @footing
				enter_pipe_sound.play()
				delay = 500 # imediately after the enter sound finishes
				delay += 500
				unless game.entered_pipe
					game.entered_pipe = yes
					game.effects.push new TextEffect("Ceci n'est pas une pipe", 2)
					delay += 500
					setTimeout =>
						game.effects.push new TextEffect("Ceci est soit une colonne ou un canon", 1)
					, delay
					delay += 500
				setTimeout =>
					@y = @entering_pipe.y - @h - 2
					@vy = -20
					exit_pipe_sound.play()
					@entering_pipe = null
				, delay
		
		if @entering_pipe
			@y += 2
			x_to = min(max(@x, @entering_pipe.x), @entering_pipe.x + @entering_pipe.w - @w)
			@x += (x_to - @x) / 5
		
		if @footing?.fall_by
			@footing.triggered = yes
		
		@vx *= 0.8
		@vy += @gravity
		
		mx = @vx
		my = @vy
		resolution = 0.1
		x_step = resolution * sign(mx)
		y_step = resolution * sign(my)
		while abs(mx) > resolution
			if @collision(@x + x_step, @y)
				@vx = 0
				break
			mx -= x_step
			@x += x_step
		while abs(my) > resolution
			if @collision(@x, @y + y_step)
				@vy = 0
				break
			my -= y_step
			@y += y_step
		
		@previous_footing = @footing
	
	collision: (x, y)->
		for column in game.level.columns
			unless x + @w < column.x or column.x + column.w < x or y + @h < column.y or column.y + column.h < y
				return column
		return null
	
	draw: ->
		ctx.save()
		ctx.translate(@x + @w/2, @y)
		ctx.scale(-1, 1) if @facing > 0
		
		###
		# LEGS
		###
		
		ctx.save()
		ctx.translate(0, @h/2 - 4)
		
		leg_angle =
			if @footing
				if abs(@vx) > 0.5
					0.2 + Math.sin(Date.now() / 50) / 5
				else
					0.2 + Math.sin(Date.now() / 800) / 30
			else
				0.7 + Math.sin(Date.now() / 100) / 10
		
		if @vy > 2
			leg_angle /= @vy / 2
		
		@leg_angle += (leg_angle - @leg_angle) / 3
		
		ctx.fillStyle = "#B0BCC5"
		
		draw_leg = (right)=>
			ctx.save()
			ctx.scale(-1, 1) if right
			# leg
			ctx.rotate(@leg_angle)
			ctx.fillRect(-3, 0, 4, @h/2+4)
			# shoe
			ctx.fillStyle = "#51576C"
			ctx.fillRect(-4, @h/2+1, 5, 3)
			ctx.restore()
		
		draw_leg yes
		draw_leg no
		
		ctx.restore()
		
		###
		# TORSO
		###
		
		ctx.fillStyle = "#EFD57C"
		ctx.fillRect -@w*0.3, -1, @w*0.6, @h/2+1
		
		###
		# ARMS
		###
		
		ctx.lineCap = "round"
		
		arm_angle = 0.8
		arm_angle_2 = 1.6
		arm_angle_2 += Math.sin(Date.now() / 100) / 20
		if @vy > 2
			arm_angle += Math.sin(Date.now() / 155)
			arm_angle_2 += Math.sin(Date.now() / 94)
		
		if @entering_pipe
			arm_angle = -3.5
			arm_angle_2 = 0.5
		
		@arm_angle += (arm_angle - @arm_angle) / 3
		@arm_angle_2 += (arm_angle_2 - @arm_angle_2) / 3
		
		ctx.save()
		ctx.translate(0, @h/20 - 4)
		
		draw_arm = (right)=>
			ctx.save()
			ctx.scale(-1, 1) if right
			ctx.translate(-2, 0) if @entering_pipe
			if @footing and not @entering_pipe
				if right
					ctx.rotate(TAU/4-@arm_angle)
				else
					ctx.rotate(@arm_angle)
				if @footing and abs(@vx) > 0.5
					ctx.rotate(2 * Math.sin(Date.now() / 50) / 5)
			else if @entering_pipe
				ctx.rotate(@arm_angle)
			else
				ctx.rotate(-@arm_angle)
			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(0, @h/3)
			ctx.lineWidth = 4
			ctx.strokeStyle = "#EFD57C"
			ctx.stroke()
			ctx.translate(0, @h/3)
			if right and abs(@vx) > 0.5 or not @footing
				ctx.rotate(-@arm_angle_2)
			else
				ctx.rotate(@arm_angle_2)
			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(0, @h/4)
			ctx.lineWidth = 3
			ctx.strokeStyle = "#DFAF78"
			ctx.stroke()
			ctx.restore()
		
		draw_arm no
		draw_arm yes
		
		ctx.restore()
		
		###
		# HEAD
		###
		
		ctx.fillStyle = "#DFAF78"
		ctx.beginPath()
		ctx.arc 0, -5, @w*0.2, 0, TAU, no # head
		ctx.rect -@w*0.15, -3, @w*0.3, 2 # neck
		ctx.fill()
		# hair
		ctx.beginPath()
		ctx.strokeStyle = "#3D3127"
		ctx.moveTo -@w*0.1, -7
		ctx.lineTo -@w*0.12, -6
		ctx.moveTo -@w*0.1, -7.5
		ctx.lineTo @w*0.12, -7
		ctx.lineWidth = 1
		ctx.stroke()
		ctx.beginPath()
		ctx.moveTo @w*0.13, -6.5
		ctx.lineTo @w*0.14, -5.5
		ctx.lineWidth = 2
		ctx.stroke()
		
		###
		# ze end
		###
		
		ctx.restore()

class Gem
	gradient = ctx.createLinearGradient(-5, -8, 5, 15)

	gradient.addColorStop(0.00, 'rgba(255, 255, 255, 0.0)')
	gradient.addColorStop(0.25, 'rgba(255, 255, 255, 1.0)')
	gradient.addColorStop(0.40, 'rgba(255, 255, 255, 0.3)')
	gradient.addColorStop(0.50, 'rgba(255, 255, 255, 0.5)')
	gradient.addColorStop(0.60, 'rgba(255, 255, 255, 0.3)')
	gradient.addColorStop(0.75, 'rgba(255, 255, 255, 0.0)')
	gradient.addColorStop(1.00, 'rgba(255, 255, 255, 0.3)')
	
	constructor: (@x, @y)->
		@color = "hsl(#{random()*360}, 100%, 50%)"
		@sides = ~~(random() * 5 + 3)
		@radius = 3 + @sides / 2
		@rotation = random() * TAU
		@start_x = @x
		@start_y = @y
		@vx = 0
		@vy = 0
		@collected = no
		@deposited = no
		@deposited_to = null
		@deposited_fully = no # for animation
		@dropped = no # for sound and score animation
		@value = 100
	
	step: ->
		{player} = game.level
		dx = player.x + player.w/2 - @x
		dy = player.y + player.h/2 - @y
		dist = sqrt(dx*dx + dy*dy)
		force = 0
		if dist > 1
			if dist < 50
				force = 3
				if dist < 20
					force = 2
				if dist < 10
					force = 1
					unless @collected or @deposited
						pickup_sound.play()
						@collected = yes
						@dropped = no
			if @collected
				force = 1.1
		if force > 0
			@vx += dx / dist * force
			@vy += dy / dist * force
		
		if @deposited
			dx = @deposited_to.x + @deposited_to.w/2 - @x
			dy = @deposited_to.y - @y
			dist = sqrt(dx*dx + dy*dy)
			if abs(dx > 100)
				@vy -= 1
			if dist > 1
				force = 3
				@vx += dx / dist * force
				@vy += dy / dist * force
				unless @deposited_fully
					deposit_sound.play()
					@deposited_fully = yes if dist < 10
		
		dx = @start_x - @x
		dy = @start_y - @y
		dist = sqrt(dx*dx + dy*dy)
		if dist > 1
			force = 1
			if dist < 5
				force = 0.5
				if @dropped
					@dropped = no
					drop_sound.play()
			if dist < 2
				force = 0.1
			@vx += dx / dist * force
			@vy += dy / dist * force
		
		@x += @vx *= 0.9
		@y += @vy *= 0.9
	
	draw: ->
		if @deposited_fully
			return
		ctx.save()
		if @collected
			ctx.globalAlpha = 0.1
		ctx.translate(@x, @y)
		ctx.beginPath()
		for i in [0..@sides]
			ctx.lineTo(
				@radius * sin(i / @sides * TAU + @rotation)
				@radius * cos(i / @sides * TAU + @rotation)
			)
		ctx.fillStyle = @color
		ctx.stroke()
		ctx.fill()
		ctx.fillStyle = gradient
		ctx.fill()
		ctx.restore()

class Level
	constructor: ->
		@bottom = 500
	
	generate: ->
		@columns = []
		last_checkpoint = 0
		x = 0
		while x < 1500
			SomeColumn = if random() < 0.5 then PinkColumn else YellowColumn
			width = 20
			if random() < 0.7 and x > last_checkpoint + 400
				SomeColumn = CheckpointColumn
				last_checkpoint = x
				width = 40
			height = ~~(random() * @bottom/2 + 15)
			column = new SomeColumn(x, @bottom-height, width, height)
			@columns.push column
			
			x += width/4 if width > 20
			
			if random() < 0.3
				SomeColumn = if random() < 0.5 then PinkColumn else YellowColumn
				floater_width = 20
				floater_height = random() * 20 + 20
				floater_y = column.y - floater_height - random() * 250 - if column instanceof CheckpointColumn then 60 else 20
				floating_column = new SomeColumn(x, floater_y, floater_width, floater_height)
				@columns.push floating_column
			
			x -= width/4 if width > 20
			
			x += 30 + width + if random() < 0.5 then 10 else 0

		@gems = []
		for x in [-50..1550] by 48
			for [0..2]
				loop
					gem = new Gem(x + random() * 50, random() * @bottom)
					okay = yes
					for column in @columns
						if column.x <= gem.x <= column.x + column.w and column.y <= gem.y <= column.y + column.h
							okay = no
					break if okay
				@gems.push gem
				break if @gems.length is 100
			break if @gems.length is 100
		@effects = []
	
	spawn_player: ->
		for gem in @gems when gem.collected
			gem.collected = no
			gem.dropped = yes
		if @player?
			@player.x = @player.checkpoint.x
			@player.y = @player.checkpoint.y
			@player.vx = 0
			@player.vy = 0
			@player.jumps = @player.max_jumps
		else
			column = @columns[3]
			@player = new Player(column.x + 2, column.y)
			@player.checkpoint = column
		@player.y = min(@player.y, game.level.bottom)
		@player.y -= @player.h * 5
		@player.y -= 1 while @player.collision(@player.x, @player.y)
	
	respawn_player: ->
		@spawn_player()
		respawn_sound.play()
	
	step: ->
		if @player.y > @bottom and not @player.entering_pipe
			@respawn_player()
		
		gem.step() for gem in @gems
		column.step() for column in @columns
		@player.step()
	
	draw: ->
		gem.draw() for gem in @gems
		@player.draw() if @player.entering_pipe
		column.draw() for column in @columns
		@player.draw() unless @player.entering_pipe
		effect.draw() for effect in @effects

class TextEffect
	constructor: (@text, @repeat = Infinity)->
		@triple_jump_unlocked = 0
		@animation = 0
		@animation_velocity = 0
		@animation_time = 0
	
	draw: ->
		return if @animation_time > 26 * @repeat
		
		@animation_time += 1
		to = 20 + (if @repeat is Infinity then @animation_time else 0)
		delta = to - @animation
		@animation_velocity += delta / 20
		@animation += @animation_velocity
		
		font_size = max(30, (canvas.width + canvas.height) / 30)
		ctx.font = "#{font_size}px sans-serif"
		ctx.textAlign = "center"
		ctx.textBaseline = "middle"
		
		ctx.save()
		ctx.translate(canvas.width/2, canvas.height/2)
		scale = min(1, @animation/20)
		ctx.translate(0, min(1, scale))
		ctx.globalAlpha = scale
		ctx.scale(scale, scale)
		ctx.beginPath()
		
		draw_text = (color, jitter, fill)=>
			ox = sin(Date.now()/1000 * jitter) * jitter * 2
			oy = cos(Date.now()/1000 * jitter) * jitter * 3
			rot_origin_x = (random() * 2 - 1) * 500
			ctx.translate(rot_origin_x, 0)
			ctx.rotate((random() * 2 - 1) * 0.01)
			ctx.translate(-rot_origin_x, 0)
			if fill
				ctx.fillStyle = color
				ctx.fillText(@text, ox, oy)
			else
				ctx.strokeStyle = color
				ctx.strokeText(@text, ox, oy)
		
		ctx.lineWidth = 5
		ctx.globalCompositeOperation = "multiply"
		draw_text "rgb(255, 255, 0)", 4.35
		draw_text "rgb(255, 0, 0)", 3.32
		draw_text "rgb(0, 255, 255)", 2.57
		draw_text "rgb(0, 0, 0)", 1.23
		ctx.globalCompositeOperation = "normal"
		draw_text "rgb(255, 255, 255)", 0, yes
		ctx.restore()

class Game
	constructor: ->
		@holding_score = 0
		@deposited_score = 0
		@dropping_score = 0
		@maximum_score = 0
	
	restart: ->
		@start()
	
	start: ->
		@level = new Level
		@level.generate()
		@level.spawn_player()
		{player} = @level
		
		@effects = []
		
		@view = {cx: player.x, cy: player.y, scale: 1}
		@view_to = {cx: player.x, cy: player.y, scale: 1}
		
		@triple_jump_unlock_score = 7000
		@triple_jump_unlocked = 0
		@won = no
		@entered_pipe = no
	
	animate: ->
		animate =>
			ctx.fillStyle = "#fff"
			ctx.fillRect 0, 0, canvas.width, canvas.height
			
			ctx.save()
			@view_to.cx = @level.player.x
			@view_to.cy = @level.player.y + if keys[40] then 150 else 50
			@view_to.scale =
				if canvas.width > 1500 then 2
				else if canvas.width > 1000 then 1.5 else 1
			@view.cx += (@view_to.cx - @view.cx) / 10
			@view.cy += (@view_to.cy - @view.cy) / 10
			@view.scale += (@view_to.scale - @view.scale) / 20
			@view.cy = Math.min(@view.cy, @level.bottom-canvas.height/2/@view.scale)
			
			if @level.player.footing?.shaking
				@view.cx += (random() * 2 - 1) * 3
				@view.cy += (random() * 2 - 1) * 5
			
			ctx.scale(@view.scale, @view.scale)
			ctx.translate(canvas.width/2/@view.scale-@view.cx, canvas.height/2/@view.scale-@view.cy)
			
			@level.step()
			@level.draw()
			
			ctx.restore()
			
			effect.draw() for effect in @effects
			
			@holding_score = 0
			@deposited_score = 0
			@dropping_score = 0
			@maximum_score = 0
			for gem in @level.gems
				@maximum_score += gem.value
				if gem.deposited
					@deposited_score += gem.value
				else if gem.dropped
					@dropping_score += gem.value 
				else if gem.collected
					@holding_score += gem.value 
			
			if @deposited_score >= @triple_jump_unlock_score and not @triple_jump_unlocked
				@triple_jump_unlocked = yes
				@level.player.max_jumps = 3
				triple_jump_unlocked_sound.play()
				@effects.push new TextEffect("Triple Jump Unlocked!", 3)
			
			if @deposited_score is @maximum_score and not @won
				@won = yes
				@level.player.max_jumps = 10
				for column in @level.columns
					column.fall_by += random() * 450
				triple_jump_unlocked_sound.play()
				@effects.push new TextEffect("You. Win. teh. Game. ah yes")
			
			font_size = max(20, (canvas.width + canvas.height) / 60)
			ctx.font = "#{font_size}px sans-serif"
			ctx.textAlign = "right"
			ctx.textBaseline = "top"
			ctx.fillStyle = "black"
			y = 15
			if @deposited_score > 0
				if @deposited_score is @maximum_score
					text = "100% yo"
				else if @deposited_score >= @triple_jump_unlock_score
					text = "#{@deposited_score} / #{@maximum_score}"
				else if @deposited_score >= @triple_jump_unlock_score / 2
					text = "#{@deposited_score} / #{@triple_jump_unlock_score}"
				else
					text = "#{@deposited_score}"
				ctx.fillText(text, canvas.width-15, y)
				y += 20 + font_size
			if @dropping_score > 0
				ctx.fillStyle = "rgb(150, 0, 0)"
				ctx.fillText("-#{@dropping_score}", canvas.width-15, y)
				y += 20 + font_size
			if @holding_score > 0
				ctx.fillStyle = "rgb(0, 150, 0)"
				ctx.fillText("+#{@holding_score}", canvas.width-15, y)
				y += 20 + font_size

@game = new Game
game.start()
game.animate()

toggle_mute_button = document.getElementById("toggle-mute")
fullscreen_button = document.getElementById("fullscreen")
restart_button = document.getElementById("open-restart-dialogue")
restart_dialogue = document.getElementById("restart-dialogue")
do_restart_button = document.getElementById("do-restart")
cancel_restart_button = document.getElementById("cancel-restart")
dialogPolyfill.registerDialog(restart_dialogue)

fullscreen_button.onclick = ->
	elem = document.body
	if elem.requestFullscreen
		elem.requestFullscreen()
	else if elem.msRequestFullscreen
		elem.msRequestFullscreen()
	else if elem.mozRequestFullScreen
		elem.mozRequestFullScreen()
	else if elem.webkitRequestFullscreen
		elem.webkitRequestFullscreen()

muted = no
toggle_mute_button.onclick = ->
	if muted
		Howler.unmute()
	else
		Howler.mute()
	muted = not muted
	toggle_mute_button.className = if muted then "unmute" else "mute"

restart_button.onclick = ->
	restart_dialogue.showModal()

do_restart_button.onclick = ->
	game.restart()
	restart_dialogue.close()

cancel_restart_button.onclick = ->
	restart_dialogue.close()

do_restart_button.addEventListener "keydown", (e)->
	if e.keyCode is 39
		cancel_restart_button.focus()

cancel_restart_button.addEventListener "keydown", (e)->
	if e.keyCode is 37
		do_restart_button.focus()
