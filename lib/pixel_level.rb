require_relative 'config'

class Fixnum
	include ConfigVars

	def to_pixel
		self.to_tile * @@tile_size
	end

	def to_tile
		2 ** self
	end

	def to_level
		# TODO change to round maybe?
		Math.log2(1.0 * self / @@tile_size).ceil
	end

	def to_pixel_offset
		self * @@tile_size
	end

	def to_binary_str level
		self.to_s(2).rjust(level, "0")
	end
end