class Fixnum
	def bin_str level
		self.to_s(2).rjust(level, "0")
	end
end

module Tily
	# Implements a simple tile calculating system according to
	# A dev guide named "Bing Maps Tile System".
	# Link here: http://msdn.microsoft.com/en-us/library/bb259689.aspx
	class TileSystem
		attr_accessor :unit_size
		attr_accessor :raw_width
		attr_accessor :raw_height

		# Initialize with customizable unit tile size
		# Default value: 256
		def initialize unit_size = 256 # defaults to 256
			@unit_size = unit_size
		end

		# Read in raw dimension to be processed
		def read_raw_dimension width, height
			@raw_width = width
			@raw_height = height
		end

		# Calculates level size of the raw dimensions
		# Basically, it calculates level from width and
		# height respectly, and return the bigger number
		def max_level
			[to_level(@raw_width), to_level(@raw_height)].max
		end

		# Returns the normalized number
		# Sometimes, the image is not so well prepared in dimension
		# so, we need to calculate the normalized size
		def normalized_size
			tile_size(max_level) * @unit_size
		end

		# Returns the number of tile as for rows/columns in a level
		def tile_size level
			2 ** level
		end

		# Returns the pixel offset in the image
		def tile_offset index
			@unit_size * index
		end

		# Calculates quadkey for tile (<x>, <y>) on level <level_number>
		# The process is kind of complex, here's what it does:
		# 1. Converts x, y to binary string
		# 2. Interleave the bits of y and x coordinates
		# 3. Interprate the result as a base-4 number (with leading zeros maintained)
		def quadkey level, x, y
			x_chars = x.bin_str(level).split ""
			y_chars = y.bin_str(level).split ""

			y_chars.zip(x_chars).flatten.join("").to_i(2).to_s(4).rjust(level, "0")
		end

		# Returns the list of possible levels
		def each_level
			(1..max_level).each do |level|
				yield level if block_given?
			end
		end

		# Builds the "x, y" pairs, and returns these pairs in block
		def each_tile level
			size = tile_size level
			(0...size).each do |y|
				(0...size).each do |x|
					yield(x, y) if block_given?
				end
			end
		end

		# Builds the "x, y, index" pairs, and returns these pairs in block
		def each_tile_with_index level
			idx = 0
			size = tile_size level
			(0...size).each do |y|
				(0...size).each do |x|
					yield(x, y, idx) if block_given?
					idx += 1
				end
			end
		end

		# Generates meta info for current TileSystem
		def meta
			{
				total_level: max_level, 
				unit_size:   @unit_size,
				raw_width:   @raw_width, 
				raw_height:  @raw_height
			}
		end

		private
		# Calculate level size from raw size with the following fomula:
		#    level = ceil(log2(raw size / unit_size))
		def to_level raw_size
			Math.log2(1.0 * raw_size / @unit_size).ceil
		end

	end
end