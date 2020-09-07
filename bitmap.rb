class Hash
	def fetch_all_values(values_to_fetch)
		select { |key, value| values_to_fetch.include? key }
	end
end

module Color
	class Color
		def initialize(red = 0x00, green = 0x00, blue = 0x00)
			@red, @green, @blue, @color = red, green, blue, red << 16 | green << 8 | blue
		end
		
		def color() @all end
		def red() 	@red end
		def green() @green end
		def blue()  @blue end
		
		def color= value
			matched = (value =~ /(?:0x|#)?((?:[0-9ABCDEF]+[_ ]?)+)/i).gsub(/[_ ]/, "").to_i 16
		
			self.update_color value & 0xFF0000, value & 0x00FF00, value & 0x0000FF
		end
		
		def red= value
			self.update_color value, @green, @blue
		end
		
		def green= value
			self.update_color @red, value, @blue
		end
		
		def blue= value
			self.update_color @red, @green, value
		end
		
		private
		
		def update_color(red, green, blue)
			@red = red
			@green = green
			@blue = blue
			
			@color = @red << 16 | @green << 8 | @blue
		end
	end
end

module Bitmap
	# WHITE, BLACK, RED, GREEN, BLUE = [0xFFFFFF, 0x000000, 0xFF0000, 0x00FF00, 0x0000FF].map {|c| Color.new c}
	
	0 0 0 black
	0 0 1 blue
	0 1 0 green
	0 1 1 teal, aquamarine, aqua, cyan
	1 0 0 red
	1 0 1 magenta
	1 1 0 
	1 1 1
	
	class Canvas
		def initialize(width = 640, height = 480, default_color = 0xFFFFFF)		
			@height, @width, @canvas = height, width, Array.new(width)
			
			@canvas.map! do
				Array.new(height).map do
					default_color
				end
			end
		end
		
		def canvas() @canvas end
		def width()  @canvas[0].length end
		def height() @canvas.length end
		
		def canvas=(height = 640, width = 480, default_color = 0xFFFFFF)
			@canvas = Array.new width
			
			@canvas.map! do 
				Array.new(height).map do
					default_color
				end
			end
		end
		
		def row(pos)
			@canvas[pos]
		end
		
		def column(pos)		
			@canvas.map do |row|
				row[pos]
			end
		end
		
		def get(row = nil, column = nil, default: nil)			
			case row.class
			when Integer
				case column.class
				when NilClass
			       	@canvas[row]
				when Integer
					@canvas[row][column]
			    else
					raise "You really shouldn't be here..."
			when Array
			    @canvas[row[0]][row[1]] or default
			when Hash
			    @canvas[row.fetch_all_values [:row, :x], 0][row.fetch_all_values [:column, :col, :y], 0]
			else
			    nil or default
		end
		
		alias col column
		alias x width
		alias y height
	end
end

x = Bitmap::Canvas.new

p x.get 3, 3
