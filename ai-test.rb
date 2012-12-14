require 'chingu'

class Game < Chingu::Window

	def setup
		super
		@player = Player.create
		Background.create
	end

	def update
		super

		@player.minelist.each do |mine|
			mine.moving_ai(@player.x, @player.y)
		end

		self.caption = "FPS #{self.fps} wasd to move, f to spawn mines"
	end
end

class Player < Chingu::GameObject
	has_traits :velocity, :bounding_circle, :timer
	traits :collision_detection

	attr_reader :minelist, :x, :y

	def setup
		self.input = {
			esc: :exit,
			holding_f: :mine,

			#player movement
			holding_w: :accelerate,
			holding_s: :decelerate,
			holding_a: :left,
			holding_d: :right

			#secondary controls
		}

		@image = Gosu::Image["first_ship.png"]

		@x = 100
		@y = 100
		@angle = 0

		@minelist = []
	end

	def accelerate
	    self.velocity_x += Gosu::offset_x(@angle, 1)
   		self.velocity_y += Gosu::offset_y(@angle, 1)
	end

	def decelerate
		self.velocity_y *= 0.8
		self.velocity_x *= 0.8
	end

	def right
		@angle += 4.5
	end

	def left
		@angle -= 4.5
	end

	def mine
		@minelist << MineAi.create
	end

	def update
		
		self.velocity_y *= 0.95
		self.velocity_x *= 0.95

		@x %= 800
		@y %= 600

		self.each_collision(@minelist) do |nought, mine|
			mine.destroy
		end
	end
end




class MineAi < Chingu::GameObject
	has_traits :velocity, :bounding_circle
	traits :collision_detection

	def setup
		@image = Gosu::Image["mine.png"]
		@x = rand(800)
		@y = rand(600)
		@checker = false
	end

	def moving_ai(target_x, target_y)


		if (
				target_x - self.x < 100 and self.x - target_x < 100 and
				target_y - self.y < 100 and self.y - target_y < 100 and
				@checker == false
			)
			@checker = true
		else
			@checker = false
		end


		if @checker == true			
			if self.x < target_x
				@x += 1
			elsif self.x > target_x
				@x -= 1		
			end

			if self.y < target_y
				@y += 1
			elsif self.y > target_y
				@y -= 1			
			end
		end
	end

end






class Background < Chingu::GameObject
	def setup
		@image = Gosu::Image["menu_background.png"]
		@x = $window.width/2
		@y = $window.height/2
		@zorder = -1
	end
end
Game.new.show